import 'package:ckb_sdk_dart/src/crypto/sha256.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of sha256', () {
    setUp(() {});

    test('Sha256 hash with ' ' ', () {
      var sha256 = Sha256();
      sha256.updateString('');
      expect(sha256.doFinalString(),
          '0xe3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855');
    });

    test('Sha256 hash with utf8 string', () {
      var sha256 = Sha256();
      sha256.updateString('The quick brown fox jumps over the lazy cog');
      expect(sha256.doFinalString(),
          '0xe4c4d8f3bf76b692de791a173e05321150f7a345b46484fe427f6acc7ecc81be');
    });

    test('Sha256 hash with hex ', () {
      var sha256 = Sha256();
      sha256.updateString(
          '0x024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01');
      expect(sha256.doFinalString(),
          '0x4a32663e9933dbbc1bb54cd3655ba47acdbe26dadab2fd5144e6bdf94e28ee34');
    });
  });
}
