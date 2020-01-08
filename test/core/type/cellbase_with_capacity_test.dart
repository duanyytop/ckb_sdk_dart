import 'dart:convert';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:test/test.dart';

void main() {
  dynamic _json;
  group('A group tests of cellbase with capacity', () {
    setUp(() {
      var cellbaseWithCapacity = '''{
        "primary": "0x102b36211d",
        "proposal_reward": "0x0",
        "secondary": "0x2ca110a5",
        "total": "0x1057d731c2",
        "tx_fee": "0x0"
      }''';
      _json = jsonDecode(cellbaseWithCapacity);
    });

    test('fromJson', () async {
      var cellbaseWithCapacity = CellbaseOutputCapacity.fromJson(_json);
      expect(cellbaseWithCapacity.primary, '0x102b36211d');
      expect(cellbaseWithCapacity.total, '0x1057d731c2');
    });

    test('toJson', () async {
      var cellbaseWithCapacity = CellbaseOutputCapacity.fromJson(_json);
      var map = cellbaseWithCapacity.toJson();
      expect(map['primary'], '0x102b36211d');
      expect(map['total'], '0x1057d731c2');
    });
  });
}
