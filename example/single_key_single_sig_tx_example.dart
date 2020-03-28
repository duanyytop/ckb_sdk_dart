import 'dart:io';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/core/transaction/script_group.dart';
import 'package:ckb_sdk_dart/src/core/transaction/secp256k1_sighash_all_builder.dart';
import 'package:ckb_sdk_dart/src/core/transaction/transaction_builder.dart';
import 'package:ckb_sdk_dart/src/core/type/witness.dart';
import 'package:ckb_sdk_dart/src/crypto/sign.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

import 'transaction/cell_collector.dart';
import 'transaction/collect_utils.dart';
import 'transaction/receiver.dart';
import 'transaction/script_group_with_private_keys.dart';

String NODE_URL = 'http://localhost:8114';
BigInt UnitCKB = BigInt.from(100000000);
Api api;
List<String> ReceiveAddresses = [
  'ckt1qyqxgp7za7dajm5wzjkye52asc8fxvvqy9eqlhp82g',
  'ckt1qyqtnz38fht9nvmrfdeunrhdtp29n0gagkps4duhek'
];

String TestPrivateKey = 'd00c06bfd800d27397002dca6fb0993d5ba6399b4238b2f29ee9deb97593d2bc';
String TestAddress = 'ckt1qyqvsv5240xeh85wvnau2eky8pwrhh4jr8ts8vyj37';
List<Receiver> receivers = [
  Receiver(ReceiveAddresses[0], ckbToShannon(number: 200000)),
  Receiver(ReceiveAddresses[1], ckbToShannon(number: 9000))
];
String changeAddress = 'ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83';

void main() async {
  api = Api(NODE_URL);

  print('Before transferring, sender\'s balance: ${await getBalance(TestAddress)} CKB');

  print('Before transferring, first receiver\'s balance: ${await getBalance(ReceiveAddresses[0])} CKB');

  print('Before transferring, change address\'s balance: ${await getBalance(changeAddress)} CKB');

  var hash = await sendCapacity(receivers, changeAddress);
  print('Transaction hash: $hash');

  // waiting transaction into block, sometimes you should wait more seconds
  sleep(Duration(seconds: 30));

  print('After transferring, sender\'s balance: ${await getBalance(TestAddress)} CKB');

  print('After transferring, receiver\'s balance: ${await getBalance(ReceiveAddresses[0])} CKB');

  print('After transferring, change address\'s balance: ${await getBalance(changeAddress)} CKB');
}

Future<String> getBalance(String address) async {
  var cellCollector = CellCollector(api);
  return ((await cellCollector.getCapacityWithAddress(address)) / UnitCKB).toString();
}

Future<String> sendCapacity(List<Receiver> receivers, String changeAddress) async {
  var needCapacity = BigInt.zero;
  var scriptGroupWithPrivateKeysList = [];
  for (var receiver in receivers) {
    needCapacity = needCapacity + receiver.capacity;
  }

  var txBuilder = TransactionBuilder(api);
  var txUtils = CollectUtils(api);

  var cellOutputs = txUtils.generateOutputs(receivers, changeAddress);
  txBuilder.addOutputs(cellOutputs);

  // You can get fee rate by rpc or set a simple number
  // BigInteger feeRate = Numeric.toBigInt(api.estimateFeeRate('5').feeRate);
  var feeRate = BigInt.from(1024);

  // initial_length = 2 * secp256k1_signature_byte.length
  var collectResult = await txUtils.collectInputs([TestAddress], txBuilder.buildTx(), feeRate, Sign.SIGN_LENGTH * 2);

  // update change output capacity after collecting cells
  cellOutputs[cellOutputs.length - 1].capacity = collectResult.changeCapacity;
  txBuilder.setOutputs(cellOutputs);

  var startIndex = 0;
  for (var cellsWithAddress in collectResult.cellsWithAddresses) {
    txBuilder.addInputs(cellsWithAddress.inputs);
    for (var i = 0; i < cellsWithAddress.inputs.length; i++) {
      txBuilder.addWitness(i == 0 ? Witness(lock: Witness.SIGNATURE_PLACEHOLDER) : '0x');
    }
    scriptGroupWithPrivateKeysList.add(ScriptGroupWithPrivateKeys(
        ScriptGroup(regionToList(startIndex, cellsWithAddress.inputs.length)), [TestPrivateKey]));
  }

  var signBuilder = Secp256k1SighashAllBuilder(txBuilder.buildTx());

  for (ScriptGroupWithPrivateKeys scriptGroupWithPrivateKeys in scriptGroupWithPrivateKeysList) {
    signBuilder.sign(scriptGroupWithPrivateKeys.scriptGroup, scriptGroupWithPrivateKeys.privateKeys[0]);
  }
  return api.sendTransaction(signBuilder.buildTx());
}
