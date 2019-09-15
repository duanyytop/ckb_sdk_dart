import 'package:ckb_sdk_dart/src/serialization/fixed/uint32.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of Uint32 serialization', () {
    setUp(() {});

    test('Uint32', () {
      expect(Uint32(256).toBytes(), [0, 1, 0, 0]);
    });

    test('Uint32 length', () {
      expect(Uint32(256).getLength(), 4);
    });
  });
}
