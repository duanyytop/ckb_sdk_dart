import 'dart:convert';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:test/test.dart';

void main() {
  var _cellbaseWithCapacity;
  group('A group tests of cellbase with capacity', () {
    setUp(() {
      _cellbaseWithCapacity = '''{
        "primary": "0x102b36211d",
        "proposal_reward": "0x0",
        "secondary": "0x2ca110a5",
        "total": "0x1057d731c2",
        "tx_fee": "0x0"
      }''';
    });

    test('fromJson', () async {
      var cellbaseWithCapacity = CellbaseOutputCapacity.fromJson(jsonDecode(_cellbaseWithCapacity));
      expect(cellbaseWithCapacity.primary, '0x102b36211d');
      expect(cellbaseWithCapacity.total, '0x1057d731c2');
    });

    test('toJson', () async {
      var cellbaseWithCapacity = CellbaseOutputCapacity.fromJson(jsonDecode(_cellbaseWithCapacity));
      expect(cellbaseWithCapacity.toJson(),
          '{"primary":"0x102b36211d","proposal_reward":"0x0","secondary":"0x2ca110a5","total":"0x1057d731c2","tx_fee":"0x0"}');
    });
  });
}
