import 'dart:convert';

import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:test/test.dart';

void main() {
  dynamic _json;
  group('A group tests of witness', () {
    setUp(() {
      String witness = '''{
        "data": [
            "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a500"
        ]
      }''';
      _json = jsonDecode(witness);
    });

    test('fromJson', () async {
      Witness witness = Witness.fromJson(_json);
      expect(witness.data[0],
          '0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a500');
    });

    test('toJson', () async {
      Witness witness = Witness.fromJson(_json);
      var map = witness.toJson();
      expect(map['data'][0],
          '0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a500');
    });
  });
}
