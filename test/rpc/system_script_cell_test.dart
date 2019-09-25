import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/rpc/api.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_script_cell.dart';
import 'package:ckb_sdk_dart/src/type/out_point.dart';
import 'package:test/test.dart';

void main() {
  Api _api;
  group('A group tests of system srcipt cell', () {
    setUp(() {
      _api = Api('http://localhost:8114');
    });

    test('getGenesisBlock', () async {
      Block block = await SystemContract.getGenesisBlock(api: _api);
      expect(block.toJson().isNotEmpty, true);
    }, skip: 'Skip rpc test');

    test('getSystemSecpCell', () async {
      SystemScriptCell _systemSecpCell =
          await SystemContract.getSystemSecpCell(api: _api);
      expect(_systemSecpCell.cellHash.isNotEmpty, true);
      expect(_systemSecpCell.outPoint.toJson().isNotEmpty, true);
    }, skip: 'Skip rpc test');

    test('getSystemDaoCell', () async {
      SystemScriptCell _systemDaoCell =
          await SystemContract.getSystemDaoCell(api: _api);
      expect(_systemDaoCell.cellHash.isNotEmpty, true);
      expect(_systemDaoCell.outPoint.toJson().isNotEmpty, true);
    }, skip: 'Skip rpc test');

    test('SystemScriptCell', () async {
      SystemScriptCell _systemScriptCell = SystemScriptCell(
          cellHash: '0x111111111111111111111111111111111111111111',
          outPoint: OutPoint(
              txHash: '0x222222222222222222222222222222222222', index: '0x0'));
      expect(_systemScriptCell.cellHash,
          '0x111111111111111111111111111111111111111111');
      expect(_systemScriptCell.outPoint.txHash,
          '0x222222222222222222222222222222222222');
    });
  });
}
