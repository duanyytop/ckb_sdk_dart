import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/cycles.dart';
import 'package:test/test.dart';

void main() {
  var _cycles;
  group('A group tests of cycles', () {
    setUp(() {
      _cycles = '''{
        "cycles": "0xc"
      }''';
    });

    test('fromJson', () async {
      var cycles = Cycles.fromJson(jsonDecode(_cycles));
      expect(cycles.cycles, '0xc');
    });

    test('toJson', () async {
      var cycles = Cycles.fromJson(jsonDecode(_cycles));
      expect(cycles.toJson(), '{"cycles":"0xc"}');
    });
  });
}
