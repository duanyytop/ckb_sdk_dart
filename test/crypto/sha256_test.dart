import 'package:ckb_sdk_dart/src/crypto/ripemd160.dart';
import 'package:ckb_sdk_dart/src/crypto/sha256.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of sha256', () {
    setUp(() {});

    test('Sha256 hash with ' ' ', () {
      Sha256 sha256 = Sha256();
      sha256.updateWithUtf8('');
      expect(sha256.doFinalString(),
          'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855');
    });

    test('Sha256 hash with utf8 string', () {
      Sha256 sha256 = Sha256();
      sha256.updateWithUtf8('The quick brown fox jumps over the lazy cog');
      expect(sha256.doFinalString(),
          'e4c4d8f3bf76b692de791a173e05321150f7a345b46484fe427f6acc7ecc81be');
    });

    test('Sha256 hash with hex ', () {
      Sha256 sha256 = Sha256();
      sha256.updateWithUtf8(
          '0x024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01');
      expect(sha256.doFinalString(),
          '2e93c3993f4fb2a5fd646ae7eeeeb44ddb7de1daa004ed9563ae5ea58a026342');
    });
  });
}
