import 'package:ckb_sdk_dart/src/crypto/key.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of key', () {
    setUp(() {});

    test('Compressed Public Key', () {
      String privateKey =
          'e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3';
      String publicKey = Key.publicKeyFromPrivate(privateKey, compress: true);
      expect(publicKey,
          '24a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01');
    });
  });
}
