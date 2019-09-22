import 'package:ckb_sdk_dart/src/serialization/fixed/byte1.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of Byte1 serialization', () {
    setUp(() {});

    test('Byte1', () {
      Byte1 byte1 = Byte1.fromHex('1');
      expect(byte1.toBytes(), [0x01]);
    });

    test('Byte1', () {
      Byte1 byte1 = Byte1.fromHex('01');
      expect(byte1.toBytes(), [0x01]);
    });

    test('Byte1 length', () {
      Byte1 byte1 = Byte1.fromHex('01');
      expect(byte1.getLength(), 1);
    });

    test('Byte1 getValue', () {
      Byte1 byte1 = Byte1.fromHex('01');
      expect(byte1.getValue().runtimeType.toString(), 'Uint8List');
    });
  });
}
