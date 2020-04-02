import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/epoch.dart';
import 'package:test/test.dart';

void main() {
  var _epoch;
  group('A group tests of epoch', () {
    setUp(() {
      _epoch = '''{
        "compact_target": "0x3e8",
        "length": "0x3e8",
        "number": "0x0",
        "start_number": "0x0"
      }''';
    });

    test('fromJson', () async {
      var epoch = Epoch.fromJson(jsonDecode(_epoch));
      expect(epoch.compactTarget, '0x3e8');
      expect(epoch.startNumber, '0x0');
    });

    test('toJson', () async {
      var epoch = Epoch.fromJson(jsonDecode(_epoch));
      expect(epoch.toJson(), '{"number":"0x0","start_number":"0x0","length":"0x3e8","compact_target":"0x3e8"}');
    });
  });
}
