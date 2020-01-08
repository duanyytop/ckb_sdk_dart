import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/core/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/crypto/key.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of key', () {
    setUp(() {});

    test('Compressed Public Key', () {
      var privateKey =
          'e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3';
      var publicKey = publicKeyFromPrivate(privateKey, compress: true);
      expect(publicKey,
          '024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01');
    });

    test('generateLockScriptWithAddress', () {
      var script = generateLockScriptWithAddress(
          'ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83');
      expect(script.toJson().isNotEmpty, true);
    });

    test('generateLockScriptWithAddress', () {
      var script = generateLockScriptWithAddress(
          'ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83');
      expect(script.toJson().isNotEmpty, true);
    });

    test('generateLockScriptWithPrivateKey', () async {
      var api = Api('http://localhost:8114');
      var systemScriptCell = await SystemContract.getSystemSecpCell(api: api);
      var privateKey =
          'e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3';
      var script = await generateLockScriptWithPrivateKey(
          privateKey: privateKey, codeHash: systemScriptCell.cellHash);
      expect(script.toJson().isNotEmpty, true);
    }, skip: 'Skip rpc test');

    test('generateLockScriptWithPrivateKey', () async {
      var privateKey =
          'e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3';
      var script = await generateLockScriptWithPrivateKey(
          privateKey: privateKey,
          codeHash:
              '0x00000000000000000000000000000000000000000000000000545950455f4944');
      expect(script.toJson().isNotEmpty, true);
    });
  });
}
