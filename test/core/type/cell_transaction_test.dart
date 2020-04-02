import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/cell_transaction.dart';
import 'package:test/test.dart';

void main() {
  var _cellTransaction;
  group('A group tests of cell transaction', () {
    setUp(() {
      _cellTransaction = '''{
        "consumed_by": null,
        "created_by": {
            "block_number": "0x1",
            "index": "0x0",
            "tx_hash": "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17"
        }
      }''';
    });

    test('fromJson', () async {
      var cellTransaction = CellTransaction.fromJson(jsonDecode(_cellTransaction));
      expect(cellTransaction.createdBy.txHash, '0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17');
      expect(cellTransaction.createdBy.blockNumber, '0x1');
    });

    test('toJson', () async {
      var cellTransaction = CellTransaction.fromJson(jsonDecode(_cellTransaction));
      expect(cellTransaction.toJson(),
          '{"created_by":"{\\"block_number\\":\\"0x1\\",\\"tx_hash\\":\\"0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17\\",\\"index\\":\\"0x0\\"}","consumed_by":null}');
    });
  });
}
