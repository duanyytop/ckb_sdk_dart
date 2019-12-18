import 'dart:convert';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:test/test.dart';

void main() {
  dynamic _json;
  group('A group tests of transaction point', () {
    setUp(() {
      String transactionPoint = '''{
        "block_number": "0x1",
        "index": "0x0",
        "tx_hash": "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17"
      }''';
      _json = jsonDecode(transactionPoint);
    });

    test('fromJson', () async {
      TransactionPoint transactionPoint = TransactionPoint.fromJson(_json);
      expect(transactionPoint.blockNumber, '0x1');
      expect(transactionPoint.txHash,
          '0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17');
    });

    test('toJson', () async {
      TransactionPoint transactionPoint = TransactionPoint.fromJson(_json);
      var map = transactionPoint.toJson();
      expect(map['block_number'], '0x1');
      expect(map['tx_hash'],
          '0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17');
    });
  });
}
