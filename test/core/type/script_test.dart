import 'dart:convert';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/crypto/blake2b.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  dynamic _json;
  group('A group tests of script', () {
    setUp(() {
      String script = '''{
        "args": "0x",
        "code_hash": "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5",
        "hash_type": "data"
      }''';
      _json = jsonDecode(script);
    });

    test('Script hash', () async {
      Blake2b blake2b = Blake2b();
      blake2b.updateWithHex(
          '0x1400000000000e00100000000c000800000004000e0000000c00000014000000740100000000000000000600080004000600000004000000580100007f454c460201010000000000000000000200f3000100000078000100000000004000000000000000980000000000000005000000400038000100400003000200010000000500000000000000000000000000010000000000000001000000000082000000000000008200000000000000001000000000000001459308d00573000000002e7368737472746162002e74657874000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b000000010000000600000000000000780001000000000078000000000000000a000000000000000000000000000000020000000000000000000000000000000100000003000000000000000000000000000000000000008200000000000000110000000000000000000000000000000100000000000000000000000000000000000000');
      String codeHash = appendHexPrefix(blake2b.doFinalString());
      Script script =
          Script(codeHash: codeHash, args: "0x", hashType: Script.data);
      Api api = Api('http://localhost:8114');
      String scriptHash = await api.computeScriptHash(script);
      expect(script.computeHash(), scriptHash);
    }, skip: 'Skip rpc test');

    test('Script hash', () async {
      Script script = Script(
          codeHash:
              '0x00000000000000000000000000000000000000000000000000545950455f4944',
          args:
              '0x8536c9d5d908bd89fc70099e4284870708b6632356aad98734fcf43f6f71c304',
          hashType: Script.type);
      expect(script.computeHash(),
          '0x9bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8');
    });

    test('fromJson', () async {
      Script script = Script.fromJson(_json);
      expect(script.codeHash,
          '0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5');
    });

    test('toJson', () async {
      Script script = Script.fromJson(_json);
      var map = script.toJson();
      expect(map['hash_type'], 'data');
    });

    test('Script byte size', () async {
      Script script = Script(
          codeHash:
              '0x00000000000000000000000000000000000000000000000000545950455f4944',
          args:
              '0x8536c9d5d908bd89fc70099e4284870708b6632356aad98734fcf43f6f71c304',
          hashType: Script.type);
      expect(script.calculateByteSize(), 65);
    });
  });
}
