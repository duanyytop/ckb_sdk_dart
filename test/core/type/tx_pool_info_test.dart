import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/tx_pool_info.dart';
import 'package:test/test.dart';

void main() {
  var _txPoolInfo;
  group('A group tests of tx pool info', () {
    setUp(() {
      _txPoolInfo = '''{
        "last_txs_updated_at": "0x0",
        "orphan": "0x0",
        "pending": "0x1",
        "proposed": "0x0",
        "total_tx_cycles": "0xc",
        "total_tx_size": "0x112"
      }''';
    });

    test('fromJson', () async {
      var txPoolInfo = TxPoolInfo.fromJson(jsonDecode(_txPoolInfo));
      expect(txPoolInfo.lastTxsUpdatedAt, '0x0');
      expect(txPoolInfo.totalTxCycles, '0xc');
    });

    test('toJson', () async {
      var txPoolInfo = TxPoolInfo.fromJson(jsonDecode(_txPoolInfo));
      expect(txPoolInfo.toJson(),
          '{"last_txs_updated_at":"0x0","pending":"0x1","staging":null,"orphan":"0x0","proposed":"0x0","total_tx_cycles":"0xc","total_tx_size":"0x112","min_fee_rate":null}');
    });
  });
}
