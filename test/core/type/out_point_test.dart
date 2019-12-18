import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/out_point.dart';
import 'package:test/test.dart';

void main() {
  dynamic _json;
  group('A group tests of out point', () {
    setUp(() {
      String outPoint = '''{
        "index": "0x0",
        "tx_hash": "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17"
      }''';
      _json = jsonDecode(outPoint);
    });

    test('fromJson', () async {
      OutPoint outPoint = OutPoint.fromJson(_json);
      expect(outPoint.index, '0x0');
      expect(outPoint.txHash,
          '0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17');
    });

    test('toJson', () async {
      OutPoint outPoint = OutPoint.fromJson(_json);
      var map = outPoint.toJson();
      expect(map['index'], '0x0');
      expect(map['tx_hash'],
          '0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17');
    });
  });
}
