import 'package:ckb_sdk_dart/ckb_rpc.dart';
import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/crypto/key.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_script_cell.dart';
import 'package:ckb_sdk_dart/src/type/block.dart';
import 'package:ckb_sdk_dart/src/type/cellbase_output_capacity.dart';
import 'package:ckb_sdk_dart/src/type/transaction_with_status.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  Api _api;
  group('A group tests of api', () {
    setUp(() {
      _api = Api('http://localhost:8114');
    });

    test('getTipBlockNumber', () async {
      String number = await _api.getTipBlockNumber();
      expect(hexToBigInt(number).compareTo(BigInt.zero) > 0, true);
    });

    test('getBlockHash', () async {
      String hash = await _api.getBlockHash("2");
      expect(hash.isNotEmpty, true);
    });

    test('getBlock', () async {
      String hash = await _api.getBlockHash("2");
      Block block = await _api.getBlock(hash);
      expect(block.toJson().isNotEmpty, true);
    });

    test('getBlockByNumber', () async {
      Block block = await _api.getBlockByNumber("2");
      expect(block.toJson().isNotEmpty, true);
    });

    test('getTransaction', () async {
      Block block = await _api.getBlockByNumber("2");
      TransactionWithStatus transaction =
          await _api.getTransaction(block.transactions[0].hash);
      expect(transaction.toJson().isNotEmpty, true);
    });

    test('getCellbaseOutputCapacityDetails', () async {
      Block block = await _api.getBlockByNumber("2");
      CellbaseOutputCapacity cellbaseOutputCapacity =
          await _api.getCellbaseOutputCapacityDetails(block.header.hash);
      expect(cellbaseOutputCapacity.toJson().isNotEmpty, true);
    });

    test('getTipHeader', () async {
      Header header = await _api.getTipHeader();
      expect(header.toJson().isNotEmpty, true);
    });

    test('getCellsByLockHash', () async {
      SystemScriptCell _systemScriptCell =
          await SystemContract.getSystemScriptCell(api: _api);
      String lockHash = (await Key.generateLockScriptWithAddress(
              address: 'ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83',
              codeHash: _systemScriptCell.cellHash))
          .computeHash();
      List<CellOutputWithOutPoint> list = await _api.getCellsByLockHash(
          lockHash: lockHash, fromNumber: '0', toNumber: '100');
      expect(list.isNotEmpty, true);
    });

    test('getLiveCell', () async {
      Block block = await _api.getBlockByNumber("2");
      CellWithStatus cellWithStatus = await _api.getLiveCell(
          outPoint: block.transactions[0].inputs[0].previousOutput,
          withData: true);
      expect(cellWithStatus.runtimeType.toString(), 'CellWithStatus');
    });

    test('getCurrentEpoch', () async {
      Epoch epoch = await _api.getCurrentEpoch();
      expect(epoch.toJson().isNotEmpty, true);
    });

    test('getEpochByNumber', () async {
      Epoch epoch = await _api.getEpochByNumber("0");
      expect(epoch.toJson().isNotEmpty, true);
    });

    test('getHeader', () async {
      String hash = await _api.getBlockHash('2');
      Header header = await _api.getHeader(hash);
      expect(header.toJson().isNotEmpty, true);
    });

    test('getHeaderByNumber', () async {
      Header header = await _api.getHeaderByNumber("0");
      expect(header.toJson().isNotEmpty, true);
    });

    test('getBlockchainInfo', () async {
      BlockchainInfo blockchainInfo = await _api.getBlockchainInfo();
      expect(blockchainInfo.toJson().isNotEmpty, true);
    });

    test('getPeersState', () async {
      List<PeerState> list = await _api.getPeersState();
      expect(list.isNotEmpty, true);
    });

    test('localNodeInfo', () async {
      NodeInfo nodeInfo = await _api.localNodeInfo();
      expect(nodeInfo.toJson().isNotEmpty, true);
    });

    test('getPeers', () async {
      List<NodeInfo> list = await _api.getPeers();
      expect(list.isNotEmpty, true);
    });

    test('txPoolInfo', () async {
      TxPoolInfo txPoolInfo = await _api.txPoolInfo();
      expect(txPoolInfo.toJson().isNotEmpty, true);
    });

    test('dryRunTransaction', () async {
      Block block = await _api.getBlockByNumber('2');
      Cycles cycles = await _api.dryRunTransaction(block.transactions[0]);
      expect(cycles.toJson().isNotEmpty, true);
    });

    test('computeTransactionHash', () async {
      Block block = await _api.getBlockByNumber('2');
      String hash = await _api.computeTransactionHash(block.transactions[0]);
      expect(hash.isNotEmpty, true);
    });

    test('computeScriptHash', () async {
      Block block = await _api.getBlockByNumber('2');
      String hash =
          await _api.computeScriptHash(block.transactions[0].outputs[0].lock);
      expect(hash.isNotEmpty, true);
    });

    test('getTransactionsByLockHash', () async {
      SystemScriptCell systemScriptCell =
          await SystemContract.getSystemScriptCell(api: _api);
      String lockHash = (await Key.generateLockScriptWithAddress(
              address: 'ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83',
              codeHash: systemScriptCell.cellHash))
          .computeHash();
      List<CellTransaction> list =
          await _api.getTransactionsByLockHash(lockHash, "0", "100", true);
      expect(list.isNotEmpty, true);
    });
  }, skip: 'Skip rpc test');
}
