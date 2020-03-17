import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/core/rpc/api.dart';
import 'package:ckb_sdk_dart/src/core/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/core/transaction/script_group.dart';
import 'package:ckb_sdk_dart/src/core/transaction/secp256k1_sighash_all_builder.dart';
import 'package:ckb_sdk_dart/src/core/transaction/transaction_builder.dart';
import 'package:ckb_sdk_dart/src/core/type/witness.dart';
import 'package:ckb_sdk_dart/src/core/utils/epoch_parser.dart';
import 'package:ckb_sdk_dart/src/crypto/key.dart';
import 'package:ckb_sdk_dart/src/crypto/sign.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/uint64.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

import 'transaction/cell_collectOR.dart';
import 'transaction/collect_utils.dart';
import 'transaction/script_group_with_private_keys.dart';

const String NERVOS_DAO_DATA = '0x0000000000000000';
BigInt UnitCKB = BigInt.from(100000000);
const int DAO_LOCK_PERIOD_EPOCHS = 180;
const int DAO_MATURITY_BLOCKS = 5;

const String NODE_URL = "http://localhost:8114";
Api api;
const String DaoTestPrivateKey =
    '08730a367dfabcadb805d69e0e613558d5160eb8bab9d6e326980c2c46a05db2';
const String DaoTestAddress = 'ckt1qyqxgp7za7dajm5wzjkye52asc8fxvvqy9eqlhp82g';

void main() async {
  api = Api(NODE_URL, hasLogger: false);

  startWithdraw();

  withdraw();
}

void startWithdraw() async {
  // Nervos DAO withdraw phase1 must be after 4 epoch of depositing transaction
  var depositTxHash = 'Please input deposit tx hash';
  var depositOutPoint = OutPoint(txHash: depositTxHash, index: '0x0');
  var transaction = await generateWithdrawingFromDaoTx(depositOutPoint);
  var txHash = await api.sendTransaction(transaction);
  print('Nervos DAO withdraw phase1 tx hash: $txHash');
}

void withdraw() async {
  // Nervos DAO withdraw phase2 must be after 180 epoch of depositing transaction
  var withdrawTxHash = 'Please input withdraw tx hash';
  var withdrawTx = await api.getTransaction(withdrawTxHash);
  var depositOutPoint = withdrawTx.transaction.inputs[0].previousOutput;
  var withdrawOutPoint = OutPoint(txHash: withdrawTxHash, index: '0x0');
  var transaction = await generateClaimingFromDaoTx(
      depositOutPoint, withdrawOutPoint, ckbToShannon(number: 0.01));
  var txHash = await api.sendTransaction(transaction);
  print('Nervos DAO withdraw phase2 tx hash: $txHash');
  // Waiting some time to make tx into blockchain
  print('After withdrawing, balance: ${await getBalance(DaoTestAddress)} CKB');
}

Future<String> getBalance(String address) async {
  var balance = await CellCollector(api).getCapacityWithAddress(address);
  return (balance / UnitCKB).toString();
}

Future<Transaction> generateWithdrawingFromDaoTx(
    OutPoint depositOutPoint) async {
  var cellWithStatus =
      await api.getLiveCell(outPoint: depositOutPoint, withData: true);
  if (CellWithStatus.Live != cellWithStatus.status) {
    throw Exception('Cell is not yet live!');
  }
  var transactionWithStatus = await api.getTransaction(depositOutPoint.txHash);
  if (TransactionWithStatus.Committed !=
      transactionWithStatus.txStatus.status) {
    throw Exception('Transaction is not committed yet!');
  }
  var depositBlock =
      await api.getBlock(transactionWithStatus.txStatus.blockHash);
  var depositBlockNumber = hexToBigInt(depositBlock.header.number);
  var cellOutput = cellWithStatus.cell.output;

  var outputData = listToHex(UInt64(depositBlockNumber).toBytes());

  var lock = generateLockScriptWithAddress(DaoTestAddress);
  var changeOutput = CellOutput(capacity: '0x0', lock: lock);

  var cellOutputs = [cellOutput, changeOutput];
  var cellOutputsData = [outputData, '0x'];
  var headerDeps = [depositBlock.header.hash];

  var scriptGroupWithPrivateKeysList = [];
  var txBuilder = TransactionBuilder(api);
  txBuilder.addCellDep(CellDep(
      outPoint: (await SystemContract.getSystemDaoCell(api: api)).outPoint,
      depType: CellDep.Code));
  txBuilder.setOutputsData(cellOutputsData);
  txBuilder.setHeaderDeps(headerDeps);
  txBuilder.addOutputs(cellOutputs);
  txBuilder.addInput(CellInput(previousOutput: depositOutPoint, since: '0x0'));

  // You can get fee rate by rpc or set a simple number
  // BigInteger feeRate = Numeric.toBigInt(api.estimateFeeRate("5").feeRate);
  var feeRate = BigInt.from(1024);
  var collectUtils = CollectUtils(api, skipDataAndType: true);
  var collectResult = await collectUtils.collectInputs(
      [DaoTestAddress], txBuilder.buildTx(), feeRate, Sign.SIGN_LENGTH * 2);

  // update change output capacity after collecting cells
  cellOutputs[cellOutputs.length - 1].capacity = collectResult.changeCapacity;
  txBuilder.setOutputs(cellOutputs);

  var cellsWithAddress = collectResult.cellsWithAddresses[0];
  txBuilder.setInputs(cellsWithAddress.inputs);
  for (var i = 0; i < cellsWithAddress.inputs.length; i++) {
    if (i == 0) {
      txBuilder.addWitness(Witness(lock: Witness.SIGNATURE_PLACEHOLDER));
    } else {
      txBuilder.addWitness('0x');
    }
  }
  var scriptGroup =
      ScriptGroup(regionToList(0, cellsWithAddress.inputs.length));
  scriptGroupWithPrivateKeysList
      .add(ScriptGroupWithPrivateKeys(scriptGroup, [DaoTestPrivateKey]));

  var signBuilder = Secp256k1SighashAllBuilder(txBuilder.buildTx());

  for (var scriptGroupWithPrivateKeys in scriptGroupWithPrivateKeysList) {
    signBuilder.sign(scriptGroupWithPrivateKeys.scriptGroup,
        scriptGroupWithPrivateKeys.privateKeys[0]);
  }
  return signBuilder.buildTx();
}

Future<Transaction> generateClaimingFromDaoTx(
    OutPoint depositOutPoint, OutPoint withdrawingOutPoint, BigInt fee) async {
  var lock = generateLockScriptWithAddress(DaoTestAddress);
  var cellWithStatus =
      await api.getLiveCell(outPoint: withdrawingOutPoint, withData: true);
  if (CellWithStatus.Live != cellWithStatus.status) {
    throw Exception('Cell is not yet live!');
  }
  var transactionWithStatus =
      await api.getTransaction(withdrawingOutPoint.txHash);
  if (TransactionWithStatus.Committed !=
      transactionWithStatus.txStatus.status) {
    throw Exception('Transaction is not committed yet!');
  }

  var depositBlockNumber =
      UInt64(hexToBigInt(cellWithStatus.cell.data.content)).getValue();
  var depositBlock =
      await api.getBlockByNumber(bigIntToHex(depositBlockNumber));
  var depositEpoch = parseEpoch(depositBlock.header.epoch);

  var withdrawBlock =
      await api.getBlock(transactionWithStatus.txStatus.blockHash);
  var withdrawEpoch = parseEpoch(withdrawBlock.header.epoch);

  var withdrawFraction = withdrawEpoch.index * depositEpoch.length;
  var depositFraction = depositEpoch.index * withdrawEpoch.length;
  var depositedEpochs = withdrawEpoch.number - depositEpoch.number;
  if (withdrawFraction > depositFraction) {
    depositedEpochs += 1;
  }
  var lockEpochs = ((depositedEpochs + (DAO_LOCK_PERIOD_EPOCHS - 1)) /
          DAO_LOCK_PERIOD_EPOCHS *
          DAO_LOCK_PERIOD_EPOCHS)
      .toInt();
  var minimalSinceEpochNumber = depositEpoch.number + lockEpochs;
  var minimalSinceEpochIndex = depositEpoch.index;
  var minimalSinceEpochLength = depositEpoch.length;

  var minimalSince = epochSince(
      minimalSinceEpochLength, minimalSinceEpochIndex, minimalSinceEpochNumber);
  var outputCapacity = await api.calculateDaoMaximumWithdraw(
      depositOutPoint, withdrawBlock.header.hash);

  var cellOutput = CellOutput(
      capacity: bigIntToHex(hexToBigInt(outputCapacity) - fee), lock: lock);

  var secpCell = await SystemContract.getSystemSecpCell(api: api);
  var nervosDaoCell = await SystemContract.getSystemDaoCell(api: api);

  var tx = Transaction(version: '0x0', cellDeps: [
    CellDep(outPoint: secpCell.outPoint, depType: CellDep.DepGroup),
    CellDep(outPoint: nervosDaoCell.outPoint)
  ], headerDeps: [
    depositBlock.header.hash,
    withdrawBlock.header.hash
  ], inputs: [
    CellInput(previousOutput: withdrawingOutPoint, since: minimalSince)
  ], outputs: [
    cellOutput
  ], outputsData: [
    '0x'
  ], witnesses: [
    Witness(lock: '', inputType: NERVOS_DAO_DATA, outputType: '')
  ]);

  return tx.sign(DaoTestPrivateKey);
}
