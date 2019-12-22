import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/core/rpc/api.dart';
import 'package:ckb_sdk_dart/src/core/type/block.dart';
import 'package:ckb_sdk_dart/src/crypto/key.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  Api _api;
  group('A group tests of api', () {
    setUp(() {
      _api = Api('http://localhost:8114');
    });

    test('getTipBlockNumber', () async {
      var number = await _api.getTipBlockNumber();
      expect(hexToBigInt(number).compareTo(BigInt.zero) > 0, true);
    });

    test('getBlockHash', () async {
      var hash = await _api.getBlockHash('2');
      expect(hash.isNotEmpty, true);
    });

    test('getBlock', () async {
      var hash = await _api.getBlockHash('2');
      var block = await _api.getBlock(hash);
      expect(block.toJson().isNotEmpty, true);
    });

    test('getBlockByNumber', () async {
      var block = await _api.getBlockByNumber('2');
      expect(block.toJson().isNotEmpty, true);
    });

    test('getTransaction', () async {
      var block = await _api.getBlockByNumber('2');
      var transaction =
          await _api.getTransaction(block.transactions[0].hash);
      expect(transaction.toJson().isNotEmpty, true);
    });

    test('getCellbaseOutputCapacityDetails', () async {
      var block = await _api.getBlockByNumber('2');
      var cellbaseOutputCapacity =
          await _api.getCellbaseOutputCapacityDetails(block.header.hash);
      expect(cellbaseOutputCapacity.toJson().isNotEmpty, true);
    });

    test('getTipHeader', () async {
      var header = await _api.getTipHeader();
      expect(header.toJson().isNotEmpty, true);
    });

    test('getCellsByLockHash', () async {
      var lockHash = (await generateLockScriptWithAddress('ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83'))
          .computeHash();
      var list = await _api.getCellsByLockHash(
          lockHash: lockHash, fromNumber: '0', toNumber: '100');
      expect(list.isNotEmpty, true);
    });

    test('getLiveCell', () async {
      var block = await _api.getBlockByNumber('2');
      var cellWithStatus = await _api.getLiveCell(
          outPoint: block.transactions[0].inputs[0].previousOutput,
          withData: true);
      expect(cellWithStatus.runtimeType.toString(), 'CellWithStatus');
    });

    test('getCurrentEpoch', () async {
      var epoch = await _api.getCurrentEpoch();
      expect(epoch.toJson().isNotEmpty, true);
    });

    test('getEpochByNumber', () async {
      var epoch = await _api.getEpochByNumber('0');
      expect(epoch.toJson().isNotEmpty, true);
    });

    test('getHeader', () async {
      var hash = await _api.getBlockHash('2');
      var header = await _api.getHeader(hash);
      expect(header.toJson().isNotEmpty, true);
    });

    test('getHeaderByNumber', () async {
      var header = await _api.getHeaderByNumber('0');
      expect(header.toJson().isNotEmpty, true);
    });

    test('getBlockchainInfo', () async {
      var blockchainInfo = await _api.getBlockchainInfo();
      expect(blockchainInfo.toJson().isNotEmpty, true);
    });

    test('getPeersState', () async {
      var list = await _api.getPeersState();
      expect(list.isNotEmpty, true);
    });

    test('localNodeInfo', () async {
      var nodeInfo = await _api.localNodeInfo();
      expect(nodeInfo.toJson().isNotEmpty, true);
    });

    test('getPeers', () async {
      var list = await _api.getPeers();
      expect(list.isNotEmpty, true);
    });

    test('txPoolInfo', () async {
      var txPoolInfo = await _api.txPoolInfo();
      expect(txPoolInfo.toJson().isNotEmpty, true);
    });

    test('dryRunTransaction', () async {
      var block = await _api.getBlockByNumber('2');
      var cycles = await _api.dryRunTransaction(block.transactions[0]);
      expect(cycles.toJson().isNotEmpty, true);
    });

    test('computeTransactionHash', () async {
      var block = await _api.getBlockByNumber('2');
      var hash = await _api.computeTransactionHash(block.transactions[0]);
      expect(hash.isNotEmpty, true);
    });

    test('computeScriptHash', () async {
      var block = await _api.getBlockByNumber('2');
      var hash =
          await _api.computeScriptHash(block.transactions[0].outputs[0].lock);
      expect(hash.isNotEmpty, true);
    });

    test('getTransactionsByLockHash', () async {
      var lockHash = (await generateLockScriptWithAddress('ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83'))
          .computeHash();
      var list = await _api.getTransactionsByLockHash(lockHash, '0', '100', true);
      expect(list.isNotEmpty, true);
    });
  }, skip: 'Skip rpc test');
}
