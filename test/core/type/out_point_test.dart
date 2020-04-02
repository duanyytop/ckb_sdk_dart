import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/out_point.dart';
import 'package:test/test.dart';

void main() {
  var _outPoint;
  group('A group tests of out point', () {
    setUp(() {
      _outPoint = '''{
        "index": "0x0",
        "tx_hash": "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17"
      }''';
    });

    test('fromJson', () async {
      var outPoint = OutPoint.fromJson(jsonDecode(_outPoint));
      expect(outPoint.index, '0x0');
      expect(outPoint.txHash, '0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17');
    });

    test('toJson', () async {
      var outPoint = OutPoint.fromJson(jsonDecode(_outPoint));
      expect(outPoint.toJson(),
          '{"tx_hash":"0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17","index":"0x0"}');
    });
  });
}
