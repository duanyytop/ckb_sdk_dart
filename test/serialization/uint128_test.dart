import 'package:ckb_sdk_dart/src/serialization/fixed/uint128.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of UInt128 serialization', () {
    setUp(() {});

    test('UInt128', () {
      expect(listToHex(UInt128(BigInt.from(10).pow(30)).toBytes()),
          '0x00000040eaed7446d09c2c9f0c000000');
    });

    test('UInt128 from bytes', () {
      expect(
          UInt128.fromBytes(hexToList('0x00000040eaed7446d09c2c9f0c000000'))
              .getValue(),
          BigInt.from(10).pow(30));
    });

    test('UInt128 from bytes', () {
      expect(UInt128.fromHex('0x00000040eaed7446d09c2c9f0c000000').getValue(),
          BigInt.from(10).pow(30));
    });

    test('UInt128 length', () {
      expect(UInt128(BigInt.from(10).pow(30)).getLength(), 16);
    });
  });
}
