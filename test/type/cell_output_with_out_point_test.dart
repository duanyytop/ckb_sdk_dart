import 'dart:convert';

import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:test/test.dart';

void main() {
  dynamic _json;
  group('A group tests of cell output with out point', () {
    setUp(() {
      String cellOuput = '''{
        "block_hash": "0x03935a4b5e3c03a9c1deb93a39183a9a116c16cff3dc9ab129e847487da0e2b8",
        "capacity": "0x1d1a94a200",
        "lock": {
            "args": "0x",
            "code_hash": "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5",
            "hash_type": "data"
        },
        "out_point": {
            "index": "0x0",
            "tx_hash": "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17"
        }
      }''';
      _json = jsonDecode(cellOuput);
    });

    test('fromJson', () async {
      CellOutputWithOutPoint cellOutput =
          CellOutputWithOutPoint.fromJson(_json);
      expect(cellOutput.lock.codeHash,
          '0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5');
      expect(cellOutput.blockHash,
          '0x03935a4b5e3c03a9c1deb93a39183a9a116c16cff3dc9ab129e847487da0e2b8');
      expect(cellOutput.outPoint.txHash,
          '0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17');
    });

    test('toJson', () async {
      CellOutputWithOutPoint cellOutput =
          CellOutputWithOutPoint.fromJson(_json);
      var map = cellOutput.toJson();
      expect(map['capacity'], '0x1d1a94a200');
      expect(map['lock']['code_hash'],
          '0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5');
      expect(map['out_point']['tx_hash'],
          '0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17');
    });
  });
}
