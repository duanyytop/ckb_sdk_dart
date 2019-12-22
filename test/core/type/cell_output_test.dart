import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/cell_output.dart';
import 'package:test/test.dart';

void main() {
  dynamic _json;
  group('A group tests of cell output', () {
    setUp(() {
      var cellOuput = '''{
         "capacity": "0x174876e800",
          "lock": {
              "args": "0x",
              "code_hash": "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5",
              "hash_type": "data"
          },
          "type": null
      }''';
      _json = jsonDecode(cellOuput);
    });

    test('fromJson', () async {
      var cellOutput = CellOutput.fromJson(_json);
      expect(cellOutput.lock.codeHash,
          '0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5');
      expect(cellOutput.capacity, '0x174876e800');
    });

    test('toJson', () async {
      var cellOutput = CellOutput.fromJson(_json);
      var map = cellOutput.toJson();
      expect(map['capacity'], '0x174876e800');
      expect(map['lock']['code_hash'],
          '0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5');
    });

    test('calculateByteSize', () async {
      var cellOutput = CellOutput.fromJson(_json);
      expect(cellOutput.occupiedCapacity('0x'), 41);
    });
  });
}
