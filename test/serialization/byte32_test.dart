import 'package:ckb_sdk_dart/src/serialization/fixed/byte32.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of Byte32 serialization', () {
    setUp(() {});

    test('Byte32', () {
      Byte32 byte32 = Byte32.fromHex('0x');
      expect(byte32.toBytes(), [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0
      ]);
    });

    test('Byte32', () {
      Byte32 byte32 = Byte32.fromHex(
          '68d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88');
      expect(
          byte32.toBytes(),
          hexToList(
              '68d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88'));
    });

    test('Byte32', () {
      Byte32 byte32 =
          Byte32.fromHex('f879527946a537e82c7f3c1cbf6d8ebf9767437d8e');
      expect(
          byte32.toBytes(),
          hexToList(
              'f879527946a537e82c7f3c1cbf6d8ebf9767437d8e0000000000000000000000'));
    });

    test('Byte32 length', () {
      Byte32 byte32 = Byte32.fromHex(
          '68d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88');
      expect(byte32.getLength(), 32);
    });

    test('Byte32 getValue', () {
      Byte32 byte32 = Byte32.fromHex(
          '68d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88');
      expect(byte32.getValue().runtimeType.toString(), 'Uint8List');
    });
  });
}
