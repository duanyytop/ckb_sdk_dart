import 'dart:io';
import 'dart:math';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/ckb_utils.dart';
import 'package:ckb_sdk_dart/src/core/transaction/script_group.dart';
import 'package:ckb_sdk_dart/src/core/transaction/secp256k1_sighash_all_builder.dart';
import 'package:ckb_sdk_dart/src/core/transaction/transaction_builder.dart';
import 'package:ckb_sdk_dart/src/core/type/outputs_validator.dart';
import 'package:ckb_sdk_dart/src/core/type/witness.dart';
import 'package:ckb_sdk_dart/src/crypto/blake2b.dart';
import 'package:ckb_sdk_dart/src/crypto/sign.dart';

import 'transaction/collect_utils.dart';
import 'transaction/receiver.dart';
import 'transaction/script_group_with_private_keys.dart';

const String NODE_URL = 'http://localhost:8114';
const String TestPrivateKey = 'e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3';
const String TestAddress = 'ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83';
const String ReceiveAddress = 'ckt1qyqxgp7za7dajm5wzjkye52asc8fxvvqy9eqlhp82g';
var api = Api(NODE_URL, hasLogger: false);
var UnitCkb = BigInt.from(pow(10, 8));
var duktapeTxHash;
var duktapeDataHash;
var udtCode;

void main() async {
  var duktape = File('./example/contract/minimal_udt/duktape');
  var data = listToHex(duktape.readAsBytesSync());
  duktapeTxHash = await uploadDepBinary(BigInt.from(300000) * UnitCkb, data);
  // duktapeTxHash = '0xe8d49063f99752b5aa23cfd110fa7d235898dec1626c09fae43e8d8d4a8b2a02';
  duktapeDataHash = Blake2b.hash(data);
  print('Upload duktape binary to ckb and tx hash: $duktapeTxHash');

  sleep(Duration(seconds: 20));

  var udt = File('./example/contract/minimal_udt/udt.js');
  udtCode = listToHex(udt.readAsBytesSync());
  var txHash = await createUdt(BigInt.from(10000) * UnitCkb, data: intToHex(100000, isWholeHex: true));
  print('Create UDT tx hash: $txHash');

  sleep(Duration(seconds: 10));
  var transferHash = await transaferUdt(BigInt.from(3000) * UnitCkb, BigInt.from(7000) * UnitCkb);
  print('Transfer UDT tx hash: $transferHash');

  sleep(Duration(seconds: 3));
  var transaction = await api.getTransaction(transferHash);

  print('Transfer tx: ${transaction.toJson()}');
}

Future<String> uploadDepBinary(BigInt capacity, String data) async {
  var scriptGroupWithPrivateKeysList = [];

  var txBuilder = TransactionBuilder(api);
  var txUtils = CollectUtils(api);

  var cellOutputs = txUtils.generateOutputs([Receiver(TestAddress, capacity)], TestAddress);
  txBuilder.addOutputs(cellOutputs);
  txBuilder.setOutputsData([data, '0x']);

  // You can get fee rate by rpc or set a simple number
  // BigInteger feeRate = Numeric.toBigInt(api.estimateFeeRate('5').feeRate);
  var feeRate = BigInt.from(1024);

  // initial_length = 2 * secp256k1_signature_byte.length
  var collectResult = await txUtils.collectInputs([TestAddress], txBuilder.buildTx(), feeRate, Sign.SIGN_LENGTH);

  // update change output capacity after collecting cells
  cellOutputs[cellOutputs.length - 1].capacity = collectResult.changeCapacity;
  txBuilder.setOutputs(cellOutputs);

  var startIndex = 0;
  for (var cellsWithAddress in collectResult.cellsWithAddresses) {
    txBuilder.addInputs(cellsWithAddress.inputs);
    for (var i = 0; i < cellsWithAddress.inputs.length; i++) {
      txBuilder.addWitness(i == 0 ? Witness(lock: Witness.SIGNATURE_PLACEHOLDER) : '0x');
    }
    scriptGroupWithPrivateKeysList.add(ScriptGroupWithPrivateKeys(ScriptGroup(regionToList(startIndex, cellsWithAddress.inputs.length)), [TestPrivateKey]));
  }

  var signBuilder = Secp256k1SighashAllBuilder(txBuilder.buildTx());

  for (ScriptGroupWithPrivateKeys scriptGroupWithPrivateKeys in scriptGroupWithPrivateKeysList) {
    signBuilder.sign(scriptGroupWithPrivateKeys.scriptGroup, scriptGroupWithPrivateKeys.privateKeys[0]);
  }
  return api.sendTransaction(signBuilder.buildTx());
}

Future<String> createUdt(BigInt capacity, {String data = '0x'}) async {
  var scriptGroupWithPrivateKeysList = [];

  var cellDep = CellDep(outPoint: OutPoint(txHash: duktapeTxHash, index: '0x0'), depType: CellDep.Code);

  var txBuilder = TransactionBuilder(api);
  var txUtils = CollectUtils(api);

  var cellOutputs = txUtils.generateOutputs([Receiver(TestAddress, capacity)], TestAddress);

  var udtTypeScript = Script(codeHash: duktapeDataHash, args: udtCode, hashType: Script.Data);
  cellOutputs[0].type = udtTypeScript;
  txBuilder.addOutputs(cellOutputs);

  txBuilder.setOutputsData([data, '0x']);
  txBuilder.addCellDep(cellDep);

  // You can get fee rate by rpc or set a simple number
  // BigInteger feeRate = Numeric.toBigInt(api.estimateFeeRate('5').feeRate);
  var feeRate = BigInt.from(1200);

  // initial_length = 2 * secp256k1_signature_byte.length
  var collectResult = await txUtils.collectInputs([TestAddress], txBuilder.buildTx(), feeRate, Sign.SIGN_LENGTH);

  // update change output capacity after collecting cells
  cellOutputs[cellOutputs.length - 1].capacity = collectResult.changeCapacity;

  txBuilder.setOutputs(cellOutputs);

  var startIndex = 0;
  for (var cellsWithAddress in collectResult.cellsWithAddresses) {
    txBuilder.addInputs(cellsWithAddress.inputs);
    for (var i = 0; i < cellsWithAddress.inputs.length; i++) {
      txBuilder.addWitness(i == 0 ? Witness(lock: Witness.SIGNATURE_PLACEHOLDER) : '0x');
    }
    scriptGroupWithPrivateKeysList.add(ScriptGroupWithPrivateKeys(ScriptGroup(regionToList(startIndex, cellsWithAddress.inputs.length)), [TestPrivateKey]));
  }
  var signBuilder = Secp256k1SighashAllBuilder(txBuilder.buildTx());

  for (ScriptGroupWithPrivateKeys scriptGroupWithPrivateKeys in scriptGroupWithPrivateKeysList) {
    signBuilder.sign(scriptGroupWithPrivateKeys.scriptGroup, scriptGroupWithPrivateKeys.privateKeys[0]);
  }
  return api.sendTransaction(signBuilder.buildTx(), outputsValidator: OutputsValidator.Passthrough);
}

Future<String> transaferUdt(BigInt capacity, BigInt remain) async {
  var scriptGroupWithPrivateKeysList = [];

  var cellDep = CellDep(outPoint: OutPoint(txHash: duktapeTxHash, index: '0x0'), depType: CellDep.Code);

  var txBuilder = TransactionBuilder(api);
  var txUtils = CollectUtils(api);

  var cellOutputs = txUtils.generateOutputs([Receiver(ReceiveAddress, capacity)], TestAddress);

  var udtTypeScript = Script(codeHash: duktapeDataHash, args: udtCode, hashType: Script.Data);
  cellOutputs[0].type = udtTypeScript;
  cellOutputs[1].type = udtTypeScript;
  txBuilder.addOutputs(cellOutputs);

  txBuilder.setOutputsData([bigIntToHex(capacity), bigIntToHex(remain)]);
  txBuilder.addCellDep(cellDep);

  // You can get fee rate by rpc or set a simple number
  // BigInteger feeRate = Numeric.toBigInt(api.estimateFeeRate('5').feeRate);
  var feeRate = BigInt.from(1024);

  // initial_length = 2 * secp256k1_signature_byte.length
  var collectResult = await txUtils.collectInputs([TestAddress], txBuilder.buildTx(), feeRate, Sign.SIGN_LENGTH);

  // update change output capacity after collecting cells
  cellOutputs[cellOutputs.length - 1].capacity = collectResult.changeCapacity;

  txBuilder.setOutputs(cellOutputs);

  var startIndex = 0;
  for (var cellsWithAddress in collectResult.cellsWithAddresses) {
    txBuilder.addInputs(cellsWithAddress.inputs);
    for (var i = 0; i < cellsWithAddress.inputs.length; i++) {
      txBuilder.addWitness(i == 0 ? Witness(lock: Witness.SIGNATURE_PLACEHOLDER) : '0x');
    }
    scriptGroupWithPrivateKeysList.add(ScriptGroupWithPrivateKeys(ScriptGroup(regionToList(startIndex, cellsWithAddress.inputs.length)), [TestPrivateKey]));
  }
  var signBuilder = Secp256k1SighashAllBuilder(txBuilder.buildTx());

  for (ScriptGroupWithPrivateKeys scriptGroupWithPrivateKeys in scriptGroupWithPrivateKeysList) {
    signBuilder.sign(scriptGroupWithPrivateKeys.scriptGroup, scriptGroupWithPrivateKeys.privateKeys[0]);
  }
  return api.sendTransaction(signBuilder.buildTx(), outputsValidator: OutputsValidator.Passthrough);
}
