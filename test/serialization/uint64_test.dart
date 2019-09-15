import 'package:ckb_sdk_dart/src/serialization/fixed/uint64.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of Uint64 serialization', () {
    setUp(() {});

    test('Uint64', () {
      expect(Uint64(BigInt.from(25689834934789)).toBytes(),
          [0x05, 0x52, 0x7c, 0x61, 0x5d, 0x17, 0x00, 0x00]);
    });

    test('Uint64 length', () {
      expect(Uint64(BigInt.from(25689834934789)).getLength(), 8);
    });
  });
}
