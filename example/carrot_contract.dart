import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/ckb_crypto.dart';
import 'package:ckb_sdk_dart/ckb_utils.dart';
import 'package:ckb_sdk_dart/src/core/transaction/script_group.dart';
import 'package:ckb_sdk_dart/src/core/transaction/secp256k1_sighash_all_builder.dart';
import 'package:ckb_sdk_dart/src/core/transaction/transaction_builder.dart';
import 'package:ckb_sdk_dart/src/core/type/witness.dart';
import 'package:ckb_sdk_dart/src/crypto/sign.dart';

import 'transaction/collect_utils.dart';
import 'transaction/receiver.dart';
import 'transaction/script_group_with_private_keys.dart';

const String NODE_URL = 'http://localhost:8114';
const String TestPrivateKey =
    'e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3';
const String TestAddress = 'ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83';
const String ReceiveAddress = 'ckt1qyqxgp7za7dajm5wzjkye52asc8fxvvqy9eqlhp82g';
var api = Api(NODE_URL, hasLogger: false);
var UnitCkb = pow(10, 8);

void main() async {
  var carrot = File('./example/contract/carrot/carrot');
  var data = listToHex(carrot.readAsBytesSync());
  var txHash = await uploadDepBinary(BigInt.from(8000 * UnitCkb), data);
  print('Upload carrot binary to ckb and tx hash: $txHash');
  
  var carrotDataHash = Blake2b.hash(data);
  var carrotTypeScript = Script(codeHash: carrotDataHash, args: '0x');
  var cellDep = CellDep(
      outPoint: OutPoint(txHash: txHash, index: '0'), depType: CellDep.Code);

  sleep(Duration(seconds: 20));
  // data does not contain 'carrot', so type script executing response 0(success)
  txHash = await callContractWithData(
      BigInt.from(1000 * UnitCkb), carrotTypeScript, cellDep,
      data: listToHex(utf8.encode('carro123')));
  print('Call binary without data and tx hash: $txHash');

  // data contains 'carrot', so type script executing response -1(fail)
  // rpc response will be [{code: -3, message: Script: ValidationFailure(-1)}]
  sleep(Duration(seconds: 5));
  txHash = await callContractWithData(
      BigInt.from(1000 * UnitCkb), carrotTypeScript, cellDep,
      data: listToHex(utf8.encode('carrot123')));
  print('Call binary with data(carrot) and tx hash: $txHash');
}

Future<String> uploadDepBinary(BigInt capacity, String data) async {
  var scriptGroupWithPrivateKeysList = [];

  var txBuilder = TransactionBuilder(api);
  var txUtils = CollectUtils(api);

  var cellOutputs =
      txUtils.generateOutputs([Receiver(TestAddress, capacity)], TestAddress);
  txBuilder.addOutputs(cellOutputs);
  txBuilder.setOutputsData([data, '0x']);

  // You can get fee rate by rpc or set a simple number
  // BigInteger feeRate = Numeric.toBigInt(api.estimateFeeRate('5').feeRate);
  var feeRate = BigInt.from(1024);

  // initial_length = 2 * secp256k1_signature_byte.length
  var collectResult = await txUtils.collectInputs(
      [TestAddress], txBuilder.buildTx(), feeRate, Sign.SIGN_LENGTH);

  // update change output capacity after collecting cells
  cellOutputs[cellOutputs.length - 1].capacity = collectResult.changeCapacity;
  txBuilder.setOutputs(cellOutputs);

  var startIndex = 0;
  for (var cellsWithAddress in collectResult.cellsWithAddresses) {
    txBuilder.addInputs(cellsWithAddress.inputs);
    for (var i = 0; i < cellsWithAddress.inputs.length; i++) {
      txBuilder.addWitness(
          i == 0 ? Witness(lock: Witness.SIGNATURE_PLACEHOLDER) : '0x');
    }
    scriptGroupWithPrivateKeysList.add(ScriptGroupWithPrivateKeys(
        ScriptGroup(regionToList(startIndex, cellsWithAddress.inputs.length)),
        [TestPrivateKey]));
  }

  var signBuilder = Secp256k1SighashAllBuilder(txBuilder.buildTx());

  for (ScriptGroupWithPrivateKeys scriptGroupWithPrivateKeys
      in scriptGroupWithPrivateKeysList) {
    signBuilder.sign(scriptGroupWithPrivateKeys.scriptGroup,
        scriptGroupWithPrivateKeys.privateKeys[0]);
  }
  return api.sendTransaction(signBuilder.buildTx());
}

Future<String> callContractWithData(BigInt capacity, Script type, CellDep cellDep,
    {String data = '0x'}) async {
  var scriptGroupWithPrivateKeysList = [];

  var txBuilder = TransactionBuilder(api);
  var txUtils = CollectUtils(api);

  var cellOutputs = txUtils
      .generateOutputs([Receiver(ReceiveAddress, capacity)], TestAddress);
  cellOutputs[0].type = type;
  txBuilder.addOutputs(cellOutputs);
  txBuilder.setOutputsData([data, '0x']);
  txBuilder.addCellDep(cellDep);

  // You can get fee rate by rpc or set a simple number
  // BigInteger feeRate = Numeric.toBigInt(api.estimateFeeRate('5').feeRate);
  var feeRate = BigInt.from(1200);

  // initial_length = 2 * secp256k1_signature_byte.length
  var collectResult = await txUtils.collectInputs(
      [TestAddress], txBuilder.buildTx(), feeRate, Sign.SIGN_LENGTH);

  // update change output capacity after collecting cells
  cellOutputs[cellOutputs.length - 1].capacity = collectResult.changeCapacity;
  txBuilder.setOutputs(cellOutputs);

  var startIndex = 0;
  for (var cellsWithAddress in collectResult.cellsWithAddresses) {
    txBuilder.addInputs(cellsWithAddress.inputs);
    for (var i = 0; i < cellsWithAddress.inputs.length; i++) {
      txBuilder.addWitness(
          i == 0 ? Witness(lock: Witness.SIGNATURE_PLACEHOLDER) : '0x');
    }
    scriptGroupWithPrivateKeysList.add(ScriptGroupWithPrivateKeys(
        ScriptGroup(regionToList(startIndex, cellsWithAddress.inputs.length)),
        [TestPrivateKey]));
  }
  var signBuilder = Secp256k1SighashAllBuilder(txBuilder.buildTx());

  for (ScriptGroupWithPrivateKeys scriptGroupWithPrivateKeys
      in scriptGroupWithPrivateKeysList) {
    signBuilder.sign(scriptGroupWithPrivateKeys.scriptGroup,
        scriptGroupWithPrivateKeys.privateKeys[0]);
  }
  return api.sendTransaction(signBuilder.buildTx());
}
