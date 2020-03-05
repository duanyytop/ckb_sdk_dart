import 'package:ckb_sdk_dart/src/serialization/fixed/uint64.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of Uint64 serialization', () {
    setUp(() {});

    test('Uint64', () {
      expect(UInt64(BigInt.from(25689834934789)).toBytes(), [0x05, 0x52, 0x7c, 0x61, 0x5d, 0x17, 0x00, 0x00]);
    });

    test('Uint64 from bytes', () {
      expect(UInt64.fromBytes(hexToList('0x9abd020000000000')).getValue(), BigInt.from(179610));
    });

    test('Uint64 length', () {
      expect(UInt64(BigInt.from(25689834934789)).getLength(), 8);
    });

    test('Uint64 getValue', () {
      expect(UInt64(BigInt.from(25689834934789)).getValue(), BigInt.from(25689834934789));
    });
  });
}
