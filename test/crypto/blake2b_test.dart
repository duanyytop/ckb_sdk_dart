import 'package:ckb_sdk_dart/src/crypto/blake2b.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of blake2b', () {
    setUp(() {});

    test('Blake2b hash with ' ' ', () {
      Blake2b blake2b = Blake2b();
      blake2b.updateWithUtf8('');
      expect(blake2b.doFinalString(),
          '0x44f4c69744d5f8c55d642062949dcae49bc4e7ef43d388c5a12f42b5633d163e');
    });

    test('Blake2b hash with utf8 string', () {
      Blake2b blake2b = Blake2b();
      blake2b.updateWithUtf8('The quick brown fox jumps over the lazy dog');
      expect(blake2b.doFinalString(),
          '0xabfa2c08d62f6f567d088d6ba41d3bbbb9a45c241a8e3789ef39700060b5cee2');
    });

    test('Blake160 hash', () {
      String hash = Blake2b.blake160(
          '024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01');
      expect(hash, '0x36c329ed630d6ce750712a477543672adab57f4c');
    });
  });
}
