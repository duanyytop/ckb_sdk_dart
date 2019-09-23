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

    test('getSystemScriptCell', () async {
      SystemScriptCell _systemScriptCell =
          await SystemContract.getSystemScriptCell(api: _api);
      expect(_systemScriptCell.cellHash.isNotEmpty, true);
      expect(_systemScriptCell.outPoint.toJson().isNotEmpty, true);
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
