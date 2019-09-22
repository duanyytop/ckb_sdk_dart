import 'package:ckb_sdk_dart/src/serialization/base/serialize_type.dart';
import 'package:ckb_sdk_dart/src/serialization/dynamic/bytes.dart';
import 'package:ckb_sdk_dart/src/serialization/dynamic/dynamic.dart';
import 'package:ckb_sdk_dart/src/serialization/dynamic/table.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/byte1.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/byte32.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of Struct serialization', () {
    Table _table;
    setUp(() {
      List<SerializeType> types = <SerializeType>[]
        ..add(Byte32.fromHex(
            '68d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88'))
        ..add(Byte1.fromHex('01'))
        ..add(Dynamic(<Bytes>[]
          ..add(Bytes.fromHex('3954acece65096bfa81258983ddb83915fc56bd8'))));

      _table = Table(types);
    });

    test('Table', () {
      expect(
          _table.toBytes(),
          hexToList(
              '5100000010000000300000003100000068d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88012000000008000000140000003954acece65096bfa81258983ddb83915fc56bd8'));
    });

    test('Table length', () {
      expect(_table.getLength(), 81);
    });

    test('Table getValue', () {
      expect(_table.getValue().runtimeType.toString(),
          'List<SerializeType<dynamic>>');
    });
  });
}
