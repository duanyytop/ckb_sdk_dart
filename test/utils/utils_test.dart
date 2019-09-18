import 'dart:typed_data';

import 'package:ckb_sdk_dart/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of Utils', () {
    setUp(() {});

    test('toWholeHex', () async {
      expect(toWholeHex('0x1234'), equals('0x1234'));
      expect(toWholeHex('0x234'), equals('0x0234'));
    });

    test('bigIntToList', () async {
      expect(bigIntToList(BigInt.from(1234)), equals([4, 0xd2]));
      expect(bigIntToList(BigInt.from(234)), equals([0xea]));
    });

    test('listToBigInt', () async {
      expect(listToBigInt(Uint8List.fromList([4, 0xd2])),
          equals(BigInt.from(1234)));
      expect(
          listToBigInt(Uint8List.fromList([0xea])), equals(BigInt.from(234)));
    });

    test('hexToList', () async {
      expect(hexToList('1ab23cd4'), [0x1a, 0xb2, 0x3c, 0xd4]);
      expect(hexToList('0001feff'), [0x00, 0x01, 0xfe, 0xff]);
    });

    test('listToHex', () async {
      expect(listToHex(Uint8List.fromList([0x1a, 0xb2, 0x3c, 0xd4])),
          equals("0x1ab23cd4"));
      expect(listToHex(Uint8List.fromList([0x00, 0x01, 0xfe, 0xff])),
          equals("0x0001feff"));
    });

    test('listToHexNoPrefix', () async {
      expect(listToHexNoPrefix(Uint8List.fromList([0x1a, 0xb2, 0x3c, 0xd4])),
          equals("1ab23cd4"));
      expect(listToHexNoPrefix(Uint8List.fromList([0x00, 0x01, 0xfe, 0xff])),
          equals("0001feff"));
    });

    test('cleanHexPrefix', () async {
      expect(cleanHexPrefix('0x1232'), equals('1232'));
      expect(cleanHexPrefix('1232'), equals('1232'));
    });

    test('appendHexPrefix', () async {
      expect(appendHexPrefix('0x232'), equals('0x232'));
      expect(appendHexPrefix('1232'), equals('0x1232'));
    });

    test('toHexString', () async {
      expect(toHexString('0x232'), equals('0x232'));
      expect(toHexString('1232'), equals('0x4d0'));
    });

    test('hexToBigInt', () async {
      expect(hexToBigInt('0x232'), equals(BigInt.from(562)));
      expect(hexToBigInt('1232'), equals(BigInt.from(4658)));
    });

    test('toBytesPadded', () async {
      expect(toBytesPadded(BigInt.two, 1), equals([0x2]));
      expect(toBytesPadded(BigInt.from(260), 2), equals([1, 4]));
      expect(toBytesPadded(BigInt.from(30000000), 4),
          equals([0x1, 0xc9, 0xc3, 0x80]));
    });
  });
}
