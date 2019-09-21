import 'package:ckb_sdk_dart/src/crypto/ripemd160.dart';
import 'package:ckb_sdk_dart/src/crypto/sha256.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of ripemd160', () {
    setUp(() {});

    test('Ripemd160 hash with ' ' ', () {
      Ripemd160 ripemd160 = Ripemd160();
      ripemd160.updateString('');
      expect(ripemd160.doFinalString(),
          '0x9c1185a5c5e9fc54612808977ee8f548b2258d31');
    });

    test('Ripemd160 hash with utf8 string', () {
      Ripemd160 ripemd160 = Ripemd160();
      ripemd160.updateString('The quick brown fox jumps over the lazy cog');
      expect(ripemd160.doFinalString(),
          '0x132072df690933835eb8b6ad0b77e7b6f14acad7');
    });

    test('Ripemd160 hash with hex', () {
      Ripemd160 ripemd160 = Ripemd160();
      ripemd160.updateString(
          '4a32663e9933dbbc1bb54cd3655ba47acdbe26dadab2fd5144e6bdf94e28ee34');
      expect(ripemd160.doFinalString(),
          '0xc8045f588e627a8381810923c61d0705d10b86d3');
    });

    test('Ripemd160 and Sha256 hash with hex ', () {
      Sha256 sha256 = Sha256();
      sha256.updateString(
          '024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01');
      String hash = sha256.doFinalString();

      Ripemd160 ripemd160 = Ripemd160();
      ripemd160.updateString(hash);
      expect(ripemd160.doFinalString(),
          '0xc8045f588e627a8381810923c61d0705d10b86d3');
    });
  });
}
