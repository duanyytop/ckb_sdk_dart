import 'dart:convert';

import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:test/test.dart';

void main() {
  dynamic _json;
  group('A group tests of cycles', () {
    setUp(() {
      String cycles = '''{
        "cycles": "0xc"
      }''';
      _json = jsonDecode(cycles);
    });

    test('fromJson', () async {
      Cycles cycles = Cycles.fromJson(_json);
      expect(cycles.cycles, '0xc');
    });

    test('toJson', () async {
      Cycles cycles = Cycles.fromJson(_json);
      var map = cycles.toJson();
      expect(map['cycles'], '0xc');
    });
  });
}
