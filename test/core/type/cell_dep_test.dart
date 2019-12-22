import 'dart:convert';
import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:test/test.dart';

void main() {
  dynamic _json;
  group('A group tests of cell dep', () {
    setUp(() {
      var cellDep = '''{
        "dep_type": "code",
        "out_point": {
            "index": "0x0",
            "tx_hash": "0x29f94532fb6c7a17f13bcde5adb6e2921776ee6f357adf645e5393bd13442141"
        }
      }''';
      _json = jsonDecode(cellDep);
    });

    test('fromJson', () async {
      var cellDep = CellDep.fromJson(_json);
      expect(cellDep.depType, 'code');
      expect(cellDep.outPoint.txHash,
          '0x29f94532fb6c7a17f13bcde5adb6e2921776ee6f357adf645e5393bd13442141');
    });

    test('toJson', () async {
      var cellDep = CellDep.fromJson(_json);
      var map = cellDep.toJson();
      expect(map['dep_type'], 'code');
      expect(map['out_point']['tx_hash'],
          '0x29f94532fb6c7a17f13bcde5adb6e2921776ee6f357adf645e5393bd13442141');
    });
  });
}
