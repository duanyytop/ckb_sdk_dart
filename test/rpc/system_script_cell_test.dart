import 'package:ckb_sdk_dart/src/rpc/api.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_script_cell.dart';
import 'package:test/test.dart';

void main() {
  Api _api;
  group('A group tests of system srcipt cell', () {
    setUp(() {
      _api = Api('http://localhost:8114');
    });

    test('getSystemScriptCell', () async {
      SystemScriptCell _systemScriptCell =
          await SystemContract.getSystemScriptCell(_api);
      expect(_systemScriptCell.cellHash.isNotEmpty, true);
      expect(_systemScriptCell.outPoint.toJson().isNotEmpty, true);
    }, skip: 'Skip rpc test');
  });
}
