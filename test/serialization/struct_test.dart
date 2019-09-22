import 'package:ckb_sdk_dart/src/serialization/fixed/byte1.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/byte32.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/struct.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of Struct serialization', () {
    Struct _struct;
    setUp(() {
      Byte1 byte1 = Byte1.fromHex("ab");
      Byte32 byte32 = Byte32.fromHex(
          "0102030405060708090001020304050607080900010203040506070809000102");
      _struct = Struct([]..add(byte1)..add(byte32));
    });

    test('Struct', () {
      expect(
          _struct.toBytes(),
          hexToList(
              '0xab0102030405060708090001020304050607080900010203040506070809000102'));
    });

    test('Struct length', () {
      expect(_struct.getLength(), 33);
    });

    test('Struct getValue', () {
      expect(_struct.getValue().runtimeType.toString(),
          'List<SerializeType<dynamic>>');
    });
  });
}
