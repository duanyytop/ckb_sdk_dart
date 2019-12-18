import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/core/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/core/system/system_script_cell.dart';
import 'package:ckb_sdk_dart/src/crypto/blake2b.dart';
import 'package:ckb_sdk_dart/src/crypto/key.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

import 'cell_collect.dart';

const daoLockPeriodBlocks = 10;
const daoMaturityBlocks = 5;

class NervosDao {
  Api api;

  NervosDao({this.api});

  Future<OutPoint> depositToDao(String privateKey, BigInt capacity, {BigInt fee}) async {
    fee ??= BigInt.zero;

    String _blake160 = Blake2b.blake160(Key.publicKeyFromPrivate(privateKey));
    SystemScriptCell _daoCell = await SystemContract.getSystemDaoCell(api: api);
    SystemScriptCell _secpCell = await SystemContract.getSystemSecpCell(api: api);
    Script _lock = Script(
        codeHash: _secpCell.cellHash, args: _blake160, hashType: Script.type);

    CellOutput cellOutput = CellOutput(
        capacity: capacity.toString(),
        lock: _lock,
        type: Script(
            codeHash: _daoCell.cellHash, args: "0x", hashType: Script.type));
    String outputData = "0x";

    CellOutput changeOutput = CellOutput(capacity: '0', lock: _lock);

    CellCollect cellCollect =
        CellCollect(api: api, lockHash: _lock.computeHash());
    CellCollectResult collectResult = await cellCollect.gatherInputs(
        capacity: capacity,
        minCapacity: BigInt.from(cellOutput.calculateByteSize(outputData)),
        minChangeCapacity: BigInt.from(changeOutput.calculateByteSize("0x")),
        fee: fee);

    List<CellOutput> cellOutputs = [cellOutput];
    List<String> outputsData = [outputData];
    if (collectResult.capacity > (capacity + fee)) {
      changeOutput.capacity = (collectResult.capacity - capacity - fee).toString();
      cellOutputs.add(changeOutput);
      outputsData.add("0x");
    }

    Transaction transaction = Transaction(
        version: "0",
        cellDeps: [
          CellDep(outPoint: _secpCell.outPoint, depType: CellDep.DepGroup),
          CellDep(outPoint: _daoCell.outPoint)
        ],
        headerDeps: [],
        inputs: collectResult.inputs,
        outputs: cellOutputs,
        outputsData: outputsData,
        witnesses: collectResult.witnesses);

    String txHash = transaction.computeHash();
    await api.sendTransaction(transaction.sign(privateKey));

    return OutPoint(txHash: txHash, index: '0');
  }

  Future<Transaction> generateWithdrawFromDaoTx(String privateKey,
      OutPoint outPoint) async {

    String _blake160 = Blake2b.blake160(Key.publicKeyFromPrivate(privateKey));
    SystemScriptCell _daoCell = await SystemContract.getSystemDaoCell(api: api);
    SystemScriptCell _secpCell = await SystemContract.getSystemSecpCell(api: api);
    Script _lock = Script(
        codeHash: _secpCell.cellHash, args: _blake160, hashType: Script.type);

    CellWithStatus cellWithStatus = await api.getLiveCell(outPoint: outPoint);
    if (cellWithStatus.status != 'live') {
      throw ('Cell is not yet live!');
    }
    TransactionWithStatus tx = await api.getTransaction(outPoint.txHash);
    if (tx.txStatus.status != 'committed') {
      throw ('Transaction is not commtted yet!');
    }

    Header depositBlockHeader =
        (await api.getBlock(tx.txStatus.blockHash)).header;
    BigInt depositBlockNumber = hexToBigInt(depositBlockHeader.number);
    Header currentBlockHeader = await api.getTipHeader();
    BigInt currentBlockNumber = hexToBigInt(currentBlockHeader.number);

    if (depositBlockNumber == currentBlockNumber) {
      throw ('You need to at least wait for 1 block before generating DAO withdraw transaction!');
    }

    int windowLeft = daoLockPeriodBlocks -
        (currentBlockNumber - depositBlockNumber).toInt() % daoLockPeriodBlocks;
    if (windowLeft < daoMaturityBlocks) {
      windowLeft = daoMaturityBlocks;
    }
    int since = currentBlockNumber.toInt() + windowLeft + 1;

    String outputCapacity = await api.calculateDaoMaximumWithdraw(
        outPoint, currentBlockHeader.hash);
    OutPoint newOutPoint =
        OutPoint(txHash: outPoint.txHash, index: outPoint.index);

    List<CellOutput> cellOutputs = [
      CellOutput(capacity: outputCapacity, lock: _lock)
    ];
    List<String> outputsData = ["0x"];
    Transaction transaction = Transaction(
        version: '0',
        cellDeps: [
          CellDep(outPoint: _daoCell.outPoint),
          CellDep(outPoint: _secpCell.outPoint, depType: CellDep.DepGroup)
        ],
        headerDeps: [currentBlockHeader.hash, depositBlockHeader.hash],
        inputs: [
          CellInput(previousOutput: newOutPoint, since: intToHex(since))
        ],
        outputs: cellOutputs,
        outputsData: outputsData,
        witnesses: ['0x0000000000000000']);
    return transaction.sign(privateKey);
  }
}
