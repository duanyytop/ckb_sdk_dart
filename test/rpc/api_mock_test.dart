import 'package:ckb_sdk_dart/ckb_rpc.dart';
import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/type/block.dart';
import 'package:ckb_sdk_dart/src/type/cellbase_output_capacity.dart';
import 'package:ckb_sdk_dart/src/type/transaction_with_status.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';
import 'package:test/test.dart';

import 'http_adapt.dart';

void main() {
  Api _api;
  group('A group tests of api mock', () {
    setUp(() {
      _api = Api('http://localhost:8114', adapter: MockAdapter());
    });

    test('getTipBlockNumber', () async {
      var number = await _api.getTipBlockNumber();
      expect(hexToBigInt(number).compareTo(BigInt.zero) > 0, true);
    });

    test('getBlockHash', () async {
      String hash = await _api.getBlockHash("2");
      expect(hash.isNotEmpty, true);
    });

    test('getBlock', () async {
      Block block = await _api.getBlock('hash');
      expect(block.toJson().isNotEmpty, true);
    });

    test('getBlockByNumber', () async {
      Block block = await _api.getBlockByNumber("2");
      expect(block.toJson().isNotEmpty, true);
    });

    test('getTransaction', () async {
      TransactionWithStatus transaction = await _api.getTransaction('hash');
      expect(transaction.toJson().isNotEmpty, true);
    });

    test('getCellbaseOutputCapacityDetails', () async {
      CellbaseOutputCapacity cellbaseOutputCapacity =
          await _api.getCellbaseOutputCapacityDetails('hash');
      expect(cellbaseOutputCapacity.toJson().isNotEmpty, true);
    });

    test('getTipHeader', () async {
      Header header = await _api.getTipHeader();
      expect(header.toJson().isNotEmpty, true);
    });

    test('getCellsByLockHash', () async {
      List<CellOutputWithOutPoint> list = await _api.getCellsByLockHash(
          lockHash: 'lockHash', fromNumber: '0', toNumber: '100');
      expect(list.isNotEmpty, true);
    });

    test('getLiveCell', () async {
      CellWithStatus cellWithStatus = await _api.getLiveCell(
          outPoint: OutPoint(txHash: '0x11111111111111111111111', index: '0x0'),
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
      Header header = await _api.getHeader('hash');
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

    test('getEpochByNumber', () async {
      Epoch epoch = await _api.getEpochByNumber("0");
      expect(epoch.toJson().isNotEmpty, true);
    });

    test('localNodeInfo', () async {
      NodeInfo nodeInfo = await _api.localNodeInfo();
      expect(nodeInfo.toJson().isNotEmpty, true);
    });

    test('getPeers', () async {
      List<NodeInfo> list = await _api.getPeers();
      expect(list.isNotEmpty, true);
    });

    test('localNodeInfo', () async {
      NodeInfo nodeInfo = await _api.localNodeInfo();
      expect(nodeInfo.toJson().isNotEmpty, true);
    });

    test('txPoolInfo', () async {
      TxPoolInfo txPoolInfo = await _api.txPoolInfo();
      expect(txPoolInfo.toJson().isNotEmpty, true);
    });

    test('dryRunTransaction', () async {
      Cycles cycles =
          await _api.dryRunTransaction(Transaction(version: '0x0', cellDeps: [
        CellDep(
            outPoint: OutPoint(txHash: '0x0000', index: '0x0'), depType: 'code')
      ], headerDeps: [], inputs: [
        CellInput(
            previousOutput: OutPoint(txHash: '0x00000', index: '0x0'),
            since: '0x0')
      ], outputs: [
        CellOutput(
            capacity: '0x233',
            lock:
                Script(codeHash: '0x0000', args: '0x000222', hashType: 'data'),
            type: null)
      ], outputsData: [], witnesses: [
        '0x00000'
      ]));
      expect(cycles.toJson().isNotEmpty, true);
    });

    test('computeTransactionHash', () async {
      String hash = await _api
          .computeTransactionHash(Transaction(version: '0x0', cellDeps: [
        CellDep(
            outPoint: OutPoint(txHash: '0x0000', index: '0x0'), depType: 'code')
      ], headerDeps: [], inputs: [
        CellInput(
            previousOutput: OutPoint(txHash: '0x00000', index: '0x0'),
            since: '0x0')
      ], outputs: [
        CellOutput(
            capacity: '0x233',
            lock:
                Script(codeHash: '0x0000', args: '0x000222', hashType: 'data'),
            type: null)
      ], outputsData: [], witnesses: [
        '0x00000'
      ]));
      expect(hash.isNotEmpty, true);
    });

    test('computeScriptHash', () async {
      String hash = await _api.computeScriptHash(
          Script(codeHash: '0x000022222', args: '0x2222222', hashType: 'data'));
      expect(hash.isNotEmpty, true);
    });

    test('getTransactionsByLockHash', () async {
      List<CellTransaction> list =
          await _api.getTransactionsByLockHash('lockHash', "0", "100", true);
      expect(list.isNotEmpty, true);
    });
  });
}
