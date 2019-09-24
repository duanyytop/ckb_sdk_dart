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
      Api api = Api('http://localhost:8114');
      SystemScriptCell systemScriptCell =
          await SystemContract.getSystemSecpCell(api: api);
      Script script = await Key.generateLockScriptWithAddress(
          address: 'ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83',
          codeHash: systemScriptCell.cellHash);
      expect(script.toJson().isNotEmpty, true);
    }, skip: 'Skip rpc test');

    test('generateLockScriptWithAddress', () async {
      Script script = await Key.generateLockScriptWithAddress(
          address: 'ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83',
          codeHash:
              '0x00000000000000000000000000000000000000000000000000545950455f4944');
      expect(script.toJson().isNotEmpty, true);
    });

    test('generateLockScriptWithPrivateKey', () async {
      Api api = Api('http://localhost:8114');
      SystemScriptCell systemScriptCell =
          await SystemContract.getSystemSecpCell(api: api);
      String privateKey =
          'e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3';
      Script script = await Key.generateLockScriptWithPrivateKey(
          privateKey: privateKey, codeHash: systemScriptCell.cellHash);
      expect(script.toJson().isNotEmpty, true);
    }, skip: 'Skip rpc test');

    test('generateLockScriptWithPrivateKey', () async {
      String privateKey =
          'e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3';
      Script script = await Key.generateLockScriptWithPrivateKey(
          privateKey: privateKey,
          codeHash:
              '0x00000000000000000000000000000000000000000000000000545950455f4944');
      expect(script.toJson().isNotEmpty, true);
    });
  });
}
