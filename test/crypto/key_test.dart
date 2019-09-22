import 'package:ckb_sdk_dart/src/crypto/key.dart';
import 'package:ckb_sdk_dart/src/rpc/api.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_script_cell.dart';
import 'package:ckb_sdk_dart/src/type/script.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of key', () {
    setUp(() {});

    test('Compressed Public Key', () {
      String privateKey =
          'e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3';
      String publicKey = Key.publicKeyFromPrivate(privateKey, compress: true);
      expect(publicKey,
          '024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01');
    });

    test('generateLockScriptWithAddress', () async {
      Api _api = Api('http://localhost:8114');
      SystemScriptCell _systemScriptCell =
          await SystemContract.getSystemScriptCell(_api);
      Script script = Key.generateLockScriptWithAddress(
          'ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83',
          _systemScriptCell.cellHash);
      expect(script.toJson().isNotEmpty, true);
    }, skip: 'Skip rpc test');

    test('generateLockScriptWithPrivateKey', () async {
      Api _api = Api('http://localhost:8114');
      SystemScriptCell _systemScriptCell =
          await SystemContract.getSystemScriptCell(_api);
      String privateKey =
          'e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3';
      Script script = Key.generateLockScriptWithPrivateKey(
          privateKey, _systemScriptCell.cellHash);
      expect(script.toJson().isNotEmpty, true);
    }, skip: 'Skip rpc test');
  });
}
