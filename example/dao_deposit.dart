import 'dart:io';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/ckb_utils.dart';
import 'package:ckb_sdk_dart/src/core/rpc/api.dart';
import 'package:ckb_sdk_dart/src/core/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/core/transaction/script_group.dart';
import 'package:ckb_sdk_dart/src/core/transaction/secp256k1_sighash_all_builder.dart';
import 'package:ckb_sdk_dart/src/core/transaction/transaction_builder.dart';
import 'package:ckb_sdk_dart/src/core/type/witness.dart';
import 'package:ckb_sdk_dart/src/crypto/sign.dart';

import 'transaction/cell_collect.dart';
import 'transaction/collect_utils.dart';
import 'transaction/receiver.dart';
import 'transaction/script_group_with_private_keys.dart';

const String NERVOS_DAO_DATA = '0x0000000000000000';
BigInt UnitCKB = BigInt.from(100000000);
const int DAO_LOCK_PERIOD_EPOCHS = 180;
const int DAO_MATURITY_BLOCKS = 5;

const String NODE_URL = "http://localhost:8114";
Api api;
const String DaoTestPrivateKey = '08730a367dfabcadb805d69e0e613558d5160eb8bab9d6e326980c2c46a05db2';
const String DaoTestAddress = 'ckt1qyqxgp7za7dajm5wzjkye52asc8fxvvqy9eqlhp82g';

void main() async {
  api = Api(NODE_URL, hasLogger: false);
  print('Before depositing, balance: ${await getBalance(DaoTestAddress)} CKB');
  var transaction = await generateDepositingToDaoTx(ckbToShannon(number: 1000));
  var txHash = await api.sendTransaction(transaction);
  print('Nervos DAO deposit tx hash: $txHash');
  // Waiting some time to make tx into blockchain
  sleep(Duration(seconds: 10));
  print('After depositing, balance: ${await getBalance(DaoTestAddress)} CKB');
}

Future<String> getBalance(String address) async {
  var balance = await CellCollector(api).getCapacityWithAddress(address);
  return (balance / UnitCKB).toString();
}

Future<Transaction> generateDepositingToDaoTx(BigInt capacity) async {
  var type = Script(codeHash: (await SystemContract.getDaoCodeHash(api: api)), args: '0x', hashType: Script.Type);

  var txUtils = CollectUtils(api);

  var cellOutputs = txUtils.generateOutputs([Receiver(DaoTestAddress, capacity)], DaoTestAddress);
  cellOutputs[0].type = type;

  var cellOutputsData = [NERVOS_DAO_DATA, '0x'];

  var scriptGroupWithPrivateKeysList = [];
  var txBuilder = TransactionBuilder(api);
  txBuilder.addOutputs(cellOutputs);
  txBuilder.setOutputsData(cellOutputsData);
  txBuilder.addCellDep(CellDep(outPoint: (await SystemContract.getSystemDaoCell(api: api)).outPoint, depType: CellDep.Code));

  // You can get fee rate by rpc or set a simple number
  // BigInteger feeRate = Numeric.toBigInt(api.estimateFeeRate("5").feeRate);
  var feeRate = BigInt.from(1024);
  var collectUtils = CollectUtils(api, skipDataAndType: true);
  var collectResult = await collectUtils.collectInputs([DaoTestAddress], txBuilder.buildTx(), feeRate, Sign.SIGN_LENGTH * 2);

  // update change output capacity after collecting cells
  cellOutputs[cellOutputs.length - 1].capacity = collectResult.changeCapacity;
  txBuilder.setOutputs(cellOutputs);

  var startIndex = 0;
  for (var cellsWithAddress in collectResult.cellsWithAddresses) {
    txBuilder.addInputs(cellsWithAddress.inputs);
    for (var i = 0; i < cellsWithAddress.inputs.length; i++) {
      txBuilder.addWitness(i == 0 ? Witness(lock: Witness.SIGNATURE_PLACEHOLDER) : '0x');
    }
    scriptGroupWithPrivateKeysList.add(ScriptGroupWithPrivateKeys(ScriptGroup(regionToList(startIndex, cellsWithAddress.inputs.length)), [DaoTestPrivateKey]));
    startIndex += cellsWithAddress.inputs.length;
  }

  var signBuilder = Secp256k1SighashAllBuilder(txBuilder.buildTx());

  for (var scriptGroupWithPrivateKeys in scriptGroupWithPrivateKeysList) {
    signBuilder.sign(scriptGroupWithPrivateKeys.scriptGroup, scriptGroupWithPrivateKeys.privateKeys[0]);
  }
  return signBuilder.buildTx();
}
