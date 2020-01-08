import 'dart:core';
import 'dart:io';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/core/transaction/script_group.dart';
import 'package:ckb_sdk_dart/src/core/transaction/secp256k1_sighash_all_builder.dart';
import 'package:ckb_sdk_dart/src/core/transaction/transaction_builder.dart';
import 'package:ckb_sdk_dart/src/core/type/witness.dart';
import 'package:ckb_sdk_dart/src/crypto/sign.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

import 'transaction/cell_collect.dart';
import 'transaction/collect_utils.dart';
import 'transaction/receiver.dart';
import 'transaction/script_group_with_private_keys.dart';

const String NODE_URL = 'http://localhost:8114';
BigInt UnitCKB = BigInt.from(100000000);
const String TestAddress = 'ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83';
Api api;
List<String> PrivateKeys = [
  '08730a367dfabcadb805d69e0e613558d5160eb8bab9d6e326980c2c46a05db2',
  'a202386cb9e46cecff9bc14b748b714c713075dd964c2507c8a8900540164959',
  '89b773ec5cf97b8fd2cf280ab1e37cd658dc28d84bac8f8dda4a8646cc08d266',
  'fec27185a66dd21abb97eeaaeb6bf63fb9c5b7c7966550e6798a78fbaf4197f0',
  '2cee134faa03a158011dff33b7756e89a0c76ba64006640615be7b483b2935b4',
  '55b55c7bd177ed837dde45bbde12fc79c12fb8695be258064f40e6d5f65db96c',
  'e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3'];
List<String> Addresses = [
  'ckt1qyqxgp7za7dajm5wzjkye52asc8fxvvqy9eqlhp82g',
  'ckt1qyqtnz38fht9nvmrfdeunrhdtp29n0gagkps4duhek',
  'ckt1qyqxvnycu7tdtyuejn3mmcnl4y09muxz8c3s2ewjd4',
  'ckt1qyq8n3400g4lw7xs4denyjprpyzaa6z2z5wsl7e2gs',
  'ckt1qyqd4lgpt5auunu6s3wskkwxmdx548wksvcqyq44en',
  'ckt1qyqrlj6znd3uhvuln5z83epv54xu8pmphzgse5uylq',
  'ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83'];

List<Receiver> receivers1 = [
  Receiver(Addresses[0], ckbToShannon(number: 800)),
  Receiver(Addresses[1], ckbToShannon(number: 900)),
  Receiver(Addresses[2], ckbToShannon(number: 1000))];

String changeAddress = 'ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440a9qpq2m6m';

void main() async {
  api = Api(NODE_URL);

  print('Before transferring, sender\'s balance: ${await getBalance(TestAddress)} CKB');

  print('Before transferring, first receiver1\'s balance: ${await getBalance(Addresses[0])} CKB');

  print('Before transferring, change address\'s balance: ${await getBalance(changeAddress)} CKB');

  var hash = await sendCapacity([TestAddress], receivers1, changeAddress);
  print('First transaction hash: $hash');

  // waiting transaction into block, sometimes you should wait more seconds
  sleep(Duration(seconds: 30));

  print('After transferring, sender\'s balance: ${await getBalance(TestAddress)} CKB');

  print('After transferring, first receiver1\'s balance: ${await getBalance(Addresses[0])} CKB');

  print('After transferring, change address\'s balance: ${await getBalance(changeAddress)} CKB');

  // Second transaction
  var receivers2 =[
          Receiver(Addresses[3], ckbToShannon(number: 600)),
          Receiver(Addresses[4], ckbToShannon(number: 700)),
          Receiver(Addresses[5], ckbToShannon(number: 800))];

  print('Before transferring, first receiver1\'s balance: ${await getBalance(receivers1[0].address)} CKB');

  print('Before transferring, first receiver2\'s balance: ${await getBalance(receivers2[0].address)} CKB');

  print('Before transferring, change address\'s balance: ${await getBalance(changeAddress)} CKB');

  var hash2 = await sendCapacity(Addresses.sublist(0, 3), receivers2, changeAddress);
  print('Second transaction hash: ' + hash2);

  // waiting transaction into block, sometimes you should wait more seconds
  sleep(Duration(seconds: 30));

  print('After transferring, first receiver1\'s balance: ${await getBalance(receivers1[0].address)} CKB');

  print('After transferring, first receiver2\'s balance: ${await getBalance(receivers2[0].address)} CKB');

  print('After transferring, change address\'s balance: ${await getBalance(changeAddress)} CKB');
}

Future<String> getBalance(String address) async {
  var cellCollector = CellCollector(api);
  return ((await cellCollector.getCapacityWithAddress(address)) / UnitCKB).toString();
}

Future<String> sendCapacity(List<String> sendAddresses, List<Receiver> receivers, String changeAddress) async {
  var transaction = await generateTx(sendAddresses, receivers, changeAddress);
  return await api.sendTransaction(transaction);
}

Future<Transaction> generateTx(List<String> addresses, List<Receiver> receivers, String changeAddress) async {
  var scriptGroupWithPrivateKeysList = [];
  var txBuilder = TransactionBuilder(api);
  var txUtils = CollectUtils(api);

  var cellOutputs = txUtils.generateOutputs(receivers, changeAddress);
  txBuilder.addOutputs(cellOutputs);

  // You can get fee rate by rpc or set a simple number
  // BigInteger feeRate = Numeric.toBigInt(api.estimateFeeRate('5').feeRate);
  var feeRate = BigInt.from(1024);

  // initial_length = 2 * secp256k1_signature_byte.length
  var collectResult = await txUtils.collectInputs(addresses, txBuilder.buildTx(), feeRate, Sign.SIGN_LENGTH * 2);

  // update change output capacity after collecting cells
  cellOutputs[cellOutputs.length - 1].capacity = collectResult.changeCapacity;
  txBuilder.setOutputs(cellOutputs);

  var startIndex = 0;
  for (var cellsWithAddress in collectResult.cellsWithAddresses) {
    txBuilder.addInputs(cellsWithAddress.inputs);
    for (var i = 0; i < cellsWithAddress.inputs.length; i++) {
      txBuilder.addWitness(i == 0 ? Witness(lock: Witness.SIGNATURE_PLACEHOLDER) : '0x');
    }
    if (cellsWithAddress.inputs.isNotEmpty) {
      scriptGroupWithPrivateKeysList.add(
          ScriptGroupWithPrivateKeys(
              ScriptGroup(regionToList(startIndex, cellsWithAddress.inputs.length)),
              [PrivateKeys[Addresses.indexOf(cellsWithAddress.address)]]));
      startIndex += cellsWithAddress.inputs.length;
    }
  }

  var signBuilder = Secp256k1SighashAllBuilder(txBuilder.buildTx());

  for (ScriptGroupWithPrivateKeys scriptGroupWithPrivateKeys in scriptGroupWithPrivateKeysList) {
    signBuilder.sign(scriptGroupWithPrivateKeys.scriptGroup, scriptGroupWithPrivateKeys.privateKeys[0]);
  }

  return signBuilder.buildTx();
}
