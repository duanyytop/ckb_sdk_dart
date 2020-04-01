import 'dart:convert';
import 'dart:math';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/ckb_crypto.dart';
import 'package:ckb_sdk_dart/ckb_serialization.dart';
import 'package:ckb_sdk_dart/ckb_utils.dart';
import 'package:ckb_sdk_dart/src/core/rpc/api.dart';
import 'package:ckb_sdk_dart/src/core/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/core/transaction/script_group.dart';
import 'package:ckb_sdk_dart/src/core/transaction/secp256k1_sighash_all_builder.dart';
import 'package:ckb_sdk_dart/src/core/transaction/transaction_builder.dart';
import 'package:ckb_sdk_dart/src/core/type/witness.dart';
import 'package:ckb_sdk_dart/src/crypto/sign.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/uint128.dart';

import 'transaction/collect_utils.dart';
import 'transaction/receiver.dart';
import 'transaction/script_group_with_private_keys.dart';
import 'wckb//wckb_cell_collector.dart';

const String NERVOS_DAO_DATA = '0x0000000000000000';
const String WCKB_DATA_PLACEHOLDER = '0x000000000000000000000000000000000000000000000000';
BigInt UnitCKB = BigInt.from(100000000);
const int DAO_LOCK_PERIOD_EPOCHS = 180;
const int DAO_MATURITY_BLOCKS = 5;

final String ALWAYS_SUCCESS_CODE_HASH = '0x56806108025878f143d767a5e642f83b3043b185ed891a41eb71a7873b3f7284';
final String ALWAYS_SUCCESS_OUT_POINT_TX_HASH = '0x85728ac46bb61963bcb80bca6fc200bdd4e4330dee89478de4c8df5a915eee37';
final BigInt DAO_OCCUPIED_CAPACITY = ckbToShannon(number: 102);
final BigInt WCKB_MIN_CELL_CAPACITY = ckbToShannon(number: 300);
final BigInt WCKB_TRANSFER_CAPACITY = ckbToShannon(number: 280);
final String WCKB_CODE_HASH = '0x90de6515262517d972127ca94ff6eb9bf94ac4d79dde01abcecbf56305fc5965';
final String WCKB_OUT_POINT_TX_HASH = '0x0d4d8ab43cdbc6ed649cd25070373103ca990c3a3b003f8e7650aa66592da5f9';

const String NODE_URL = 'http://localhost:8114';
Api api;
const String DaoTestPrivateKey = '2cee134faa03a158011dff33b7756e89a0c76ba64006640615be7b483b2935b4';
const String DaoTestAddress = 'ckt1qyqd4lgpt5auunu6s3wskkwxmdx548wksvcqyq44en';

const String DaoTestPrivateKey1 = '55b55c7bd177ed837dde45bbde12fc79c12fb8695be258064f40e6d5f65db96c';
const String DaoTestAddress1 = 'ckt1qyqrlj6znd3uhvuln5z83epv54xu8pmphzgse5uylq';

void main() async {
  api = Api(NODE_URL, hasLogger: false);
//  var transaction = await generateWckbTx(ckbToShannon(number: 600), DaoTestPrivateKey, DaoTestAddress);
//  print(transaction.toJson());
//  var txHash = await api.sendTransaction(transaction);
//  print('Generate $DaoTestAddress wckb tx hash: $txHash');
//
//  transaction = await generateWckbTx(ckbToShannon(number: 600), DaoTestPrivateKey1, DaoTestAddress1);
//  txHash = await api.sendTransaction(transaction);
//  print('Generate $DaoTestAddress1 wckb tx hash: $txHash');

  var tx = await swapWckbTx(BigInt.from(30));
  print(json.encode(tx.toJson()));
  var hash = await api.sendTransaction(tx);
  print('Swap wckb tx hash: $hash');
}

Future<Transaction> generateWckbTx(BigInt daoCapacity, String privateKey, String address) async {
  var daoCodeHash = await SystemContract.getDaoCodeHash(api: api);
  var daoType = Script(codeHash: daoCodeHash, args: '0x', hashType: Script.Type);
  var wckbType = Script(codeHash: WCKB_CODE_HASH, args: daoCodeHash, hashType: Script.Data);
  var txUtils = CollectUtils(api);

  var cellOutputs = txUtils.generateOutputs(
      [Receiver(address, daoCapacity - WCKB_MIN_CELL_CAPACITY), Receiver(address, WCKB_MIN_CELL_CAPACITY)], address);

  cellOutputs[0].type = daoType;
  cellOutputs[0].lock = Script(
      codeHash: ALWAYS_SUCCESS_CODE_HASH, args: generateLockScriptWithAddress(address).args, hashType: Script.Data);

  cellOutputs[1].type = wckbType;
  cellOutputs[1].lock = Script(
      codeHash: ALWAYS_SUCCESS_CODE_HASH, args: generateLockScriptWithAddress(address).args, hashType: Script.Data);

  var cellOutputsData = [
    NERVOS_DAO_DATA,
    '${listToHex(UInt128(daoCapacity - WCKB_MIN_CELL_CAPACITY).toBytes())}${cleanHexPrefix(NERVOS_DAO_DATA)}',
    '0x'
  ];

  var scriptGroupWithPrivateKeysList = [];
  var txBuilder = TransactionBuilder(api);
  txBuilder.addOutputs(cellOutputs);
  txBuilder.setOutputsData(cellOutputsData);
  txBuilder
      .addCellDep(CellDep(outPoint: (await SystemContract.getSystemDaoCell(api: api)).outPoint, depType: CellDep.Code));
  txBuilder.addCellDep(
      CellDep(outPoint: OutPoint(txHash: ALWAYS_SUCCESS_OUT_POINT_TX_HASH, index: '0x0'), depType: CellDep.Code));
  txBuilder
      .addCellDep(CellDep(outPoint: OutPoint(txHash: WCKB_OUT_POINT_TX_HASH, index: '0x1'), depType: CellDep.Code));

  // You can get fee rate by rpc or set a simple number
  // BigInteger feeRate = Numeric.toBigInt(api.estimateFeeRate("5").feeRate);
  var feeRate = BigInt.from(1024);
  var collectUtils = CollectUtils(api, skipDataAndType: true);
  var collectResult = await collectUtils.collectInputs([address], txBuilder.buildTx(), feeRate, Sign.SIGN_LENGTH * 2);

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
        ScriptGroup(regionToList(startIndex, cellsWithAddress.inputs.length)), [privateKey]));
    startIndex += cellsWithAddress.inputs.length;
  }

  var signBuilder = Secp256k1SighashAllBuilder(txBuilder.buildTx());

  for (var scriptGroupWithPrivateKeys in scriptGroupWithPrivateKeysList) {
    signBuilder.sign(scriptGroupWithPrivateKeys.scriptGroup, scriptGroupWithPrivateKeys.privateKeys[0]);
  }
  return signBuilder.buildTx();
}

Future<Transaction> swapWckbTx(BigInt transferWckbAmount) async {
  var daoCodeHash = await SystemContract.getDaoCodeHash(api: api);
  var wckbType = Script(codeHash: WCKB_CODE_HASH, args: daoCodeHash, hashType: Script.Data);
  var txUtils = CollectUtils(api);

  var cellOutputs = txUtils.generateOutputsNoChange(
      [Receiver(DaoTestAddress, WCKB_TRANSFER_CAPACITY), Receiver(DaoTestAddress1, WCKB_TRANSFER_CAPACITY)]);

  cellOutputs[0].type = wckbType;
  cellOutputs[0].lock = Script(
      codeHash: ALWAYS_SUCCESS_CODE_HASH,
      args: generateLockScriptWithAddress(DaoTestAddress).args,
      hashType: Script.Data);

  cellOutputs[1].type = wckbType;
  cellOutputs[1].lock = Script(
      codeHash: ALWAYS_SUCCESS_CODE_HASH,
      args: generateLockScriptWithAddress(DaoTestAddress1).args,
      hashType: Script.Data);

  var txBuilder = TransactionBuilder(api);
  txBuilder.addOutputs(cellOutputs);
  txBuilder.addCellDep(
      CellDep(outPoint: OutPoint(txHash: ALWAYS_SUCCESS_OUT_POINT_TX_HASH, index: '0x0'), depType: CellDep.Code));
  txBuilder
      .addCellDep(CellDep(outPoint: OutPoint(txHash: WCKB_OUT_POINT_TX_HASH, index: '0x1'), depType: CellDep.Code));

  var collectResult1 =
      await WCKBCellCollector(api).collectInputs(DaoTestAddress, wckbType.computeHash(), WCKB_TRANSFER_CAPACITY);
  var collectResult2 =
      await WCKBCellCollector(api).collectInputs(DaoTestAddress1, wckbType.computeHash(), WCKB_TRANSFER_CAPACITY);

  var cellHeight1 = hexToInt((await api.getHeader(collectResult1[0].blockHash)).number);
  var cellHeight2 = hexToInt((await api.getHeader(collectResult2[0].blockHash)).number);

  var maxHeight = max(cellHeight1, cellHeight2);
  var minHeight = min(cellHeight1, cellHeight2);
  var maxAR = cleanHexPrefix((await api.getBlockByNumber(intToHex(maxHeight))).header.dao).substring(16, 32);
  var minAR = cleanHexPrefix((await api.getBlockByNumber(intToHex(minHeight))).header.dao).substring(16, 32);

  var amount1 = cellHeight1 == maxHeight
      ? collectResult1[0].wckbAmount
      : BigInt.from((collectResult1[0].wckbAmount - DAO_OCCUPIED_CAPACITY) *
              UInt64.fromBytes(hexToList(maxAR)).getValue() /
              UInt64.fromBytes(hexToList(minAR)).getValue()) +
          DAO_OCCUPIED_CAPACITY;
  var amount2 = cellHeight2 == maxHeight
      ? collectResult2[0].wckbAmount
      : BigInt.from((collectResult2[0].wckbAmount - DAO_OCCUPIED_CAPACITY) *
              UInt64.fromBytes(hexToList(maxAR)).getValue() /
              UInt64.fromBytes(hexToList(minAR)).getValue()) +
          DAO_OCCUPIED_CAPACITY;

  var outputsData1 =
      '${listToHex(UInt128(amount1 - transferWckbAmount).toBytes())}${listToHexNoPrefix(UInt64.fromInt(maxHeight).toBytes())}';
  var outputsData2 =
      '${listToHex(UInt128(amount2 + transferWckbAmount).toBytes())}${listToHexNoPrefix(UInt64.fromInt(maxHeight).toBytes())}';

  txBuilder.setOutputsData([outputsData1, outputsData2]);

  if (collectResult1[0].blockHash == collectResult2[0].blockHash) {
    txBuilder.setHeaderDeps([collectResult1[0].blockHash]);
  } else if (cellHeight1 > cellHeight2) {
    txBuilder.setHeaderDeps([collectResult1[0].blockHash, collectResult2[0].blockHash]);
  } else {
    txBuilder.setHeaderDeps([collectResult2[0].blockHash, collectResult1[0].blockHash]);
  }

  txBuilder.addInput(collectResult1[0].input);
  txBuilder
      .addWitness(Witness(lock: Witness.SIGNATURE_PLACEHOLDER, inputType: listToHex(UInt64.fromHex('0x0').toBytes())));
  txBuilder.addInput(collectResult2[0].input);
  txBuilder.addWitness('0x');

  var signBuilder = Secp256k1SighashAllBuilder(txBuilder.buildTx());

  signBuilder.sign(ScriptGroup([0]), DaoTestPrivateKey);
  return signBuilder.buildTx();
}
