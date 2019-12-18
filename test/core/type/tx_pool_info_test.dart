import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/tx_pool_info.dart';
import 'package:test/test.dart';

void main() {
  dynamic _json;
  group('A group tests of tx pool info', () {
    setUp(() {
      String txPoolInfo = '''{
        "last_txs_updated_at": "0x0",
        "orphan": "0x0",
        "pending": "0x1",
        "proposed": "0x0",
        "total_tx_cycles": "0xc",
        "total_tx_size": "0x112"
      }''';
      _json = jsonDecode(txPoolInfo);
    });

    test('fromJson', () async {
      TxPoolInfo txPoolInfo = TxPoolInfo.fromJson(_json);
      expect(txPoolInfo.lastTxsUpdatedAt, '0x0');
      expect(txPoolInfo.totalTxCycles, '0xc');
    });

    test('toJson', () async {
      TxPoolInfo txPoolInfo = TxPoolInfo.fromJson(_json);
      var map = txPoolInfo.toJson();
      expect(map['last_txs_updated_at'], '0x0');
      expect(map['total_tx_cycles'], '0xc');
    });
  });
}
