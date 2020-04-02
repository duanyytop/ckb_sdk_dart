import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/cell_input.dart';
import 'package:test/test.dart';

void main() {
  var _cellInput;
  group('A group tests of cell input', () {
    setUp(() {
      _cellInput = '''{
         "previous_output": {
              "index": "0x0",
              "tx_hash": "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17"
          },
          "since": "0x0"
      }''';
    });

    test('fromJson', () async {
      var cellInput = CellInput.fromJson(jsonDecode(_cellInput));
      expect(cellInput.previousOutput.txHash, '0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17');
      expect(cellInput.since, '0x0');
    });

    test('toJson', () async {
      var cellInput = CellInput.fromJson(jsonDecode(_cellInput));
      var json = cellInput.toJson();
      expect(json,
          '{"previous_output":"{\\"tx_hash\\":\\"0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17\\",\\"index\\":\\"0x0\\"}","since":"0x0"}');
    });
  });
}
