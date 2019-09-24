import 'package:ckb_sdk_dart/ckb_rpc.dart';
import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/crypto/blake2b.dart';
import 'package:ckb_sdk_dart/src/crypto/key.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_script_cell.dart';
import 'package:ckb_sdk_dart/src/type/out_point.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

import 'cell_collect.dart';

const daoLockPeriodBlocks = 10;
const daoMaturityBlocks = 5;

class NervosDao {
  String privateKey;
  Api api;

  SystemScriptCell _secpCell;
  SystemScriptCell _daoCell;
  Script _lock;
  String _blake160;

  NervosDao({this.api, this.privateKey});

  void _initParams() async {
    _blake160 = Blake2b.blake160(Key.publicKeyFromPrivate(privateKey));
    _secpCell = await SystemContract.getSystemSecpCell(api: api);
    _daoCell = await SystemContract.getSystemDaoCell(api: api);
    _lock = Script(
        codeHash: _secpCell.cellHash, args: [_blake160], hashType: Script.type);
  }

  Future<OutPoint> depositToDao(BigInt capacity) async {
    await _initParams();

    CellOutput cellOutput = CellOutput(
        capacity: capacity.toRadixString(16),
        lock: _lock,
        type: Script(codeHash: _daoCell.cellHash));
    String outputData = '0x';

    CellOutput changeOutput = CellOutput(capacity: '0', lock: _lock);

    CellCollect cellCollect =
        CellCollect(api: api, lockHash: _lock.computeHash());
    CellCollectResult collectResult = await cellCollect.gatherInputs(
        capacity: capacity,
        minCapacity: cellOutput.calculateByteSizeWithBigInt(outputData),
        minChangeCapacity: changeOutput.calculateByteSizeWithBigInt('0x'));

    List<CellOutput> cellOutputs = [cellOutput];
    List<String> outputsData = [outputData];
    if (collectResult.capacity > capacity) {
      cellOutputs.add(changeOutput);
      outputsData.add('0x');
    }

    Transaction transaction = Transaction(
        version: "0",
        cellDeps: [
          CellDep(outPoint: _secpCell.outPoint, depType: CellDep.depGroup),
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

  Future<Transaction> generateWithdrawFromDaoTransaction(
      OutPoint outPoint, String privateKey) async {
    await _initParams();

    CellWithStatus cellWithStatus = await api.getLiveCell(outPoint: outPoint);
    if (cellWithStatus.status != 'live') {
      throw ('Cell is not yet live!');
    }
    TransactionWithStatus tx = await api.getTransaction(outPoint.txHash);
    if (tx.txStatus.status == 'committed') {
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
    List<String> outputsData = ['0x'];
    Transaction transaction = Transaction(
        version: '0',
        cellDeps: [
          CellDep(outPoint: _daoCell.outPoint),
          CellDep(outPoint: _secpCell.outPoint, depType: CellDep.depGroup)
        ],
        headerDeps: [currentBlockHeader.hash, depositBlockHeader.hash],
        inputs: [
          CellInput(previousOutput: newOutPoint, since: since.toRadixString(16))
        ],
        outputs: cellOutputs,
        outputsData: outputsData,
        witnesses: [
          Witness(data: ['0x0000000000000000'])
        ]);
    return transaction.sign(privateKey);
  }
}
