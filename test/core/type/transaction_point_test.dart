import 'dart:convert';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:test/test.dart';

void main() {
  var _transactionPoint;
  group('A group tests of transaction point', () {
    setUp(() {
      _transactionPoint = '''{
        "block_number": "0x1",
        "index": "0x0",
        "tx_hash": "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17"
      }''';
    });

    test('fromJson', () async {
      var transactionPoint = TransactionPoint.fromJson(jsonDecode(_transactionPoint));
      expect(transactionPoint.blockNumber, '0x1');
      expect(transactionPoint.txHash, '0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17');
    });

    test('toJson', () async {
      var transactionPoint = TransactionPoint.fromJson(jsonDecode(_transactionPoint));
      expect(transactionPoint.toJson(),
          '{"block_number":"0x1","tx_hash":"0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17","index":"0x0"}');
    });
  });
}
