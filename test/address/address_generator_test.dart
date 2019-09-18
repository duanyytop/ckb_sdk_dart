import 'package:ckb_sdk_dart/src/address/address_generator.dart';
import 'package:ckb_sdk_dart/src/address/address_params.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of address generator', () {
    setUp(() {});

    test('Generate testnet address with any arg', () {
      AddressGenerator generator = AddressGenerator(network: Network.testnet);
      String expected =
          "ckt1qyqz6824th6pekd6858nru9p4j3u783fttl4k3r0cp2lt7uxhx00fxcxpzeq8";
      String arg =
          "2d1d555df41cd9ba3d0f31f0a1aca3cf1e295aff5b446fc055f5fb86b99ef49b";
      expect(generator.address(arg), expected);
    });

    test('Generate testnet address with public key blake160 hash', () {
      AddressGenerator generator = AddressGenerator(network: Network.testnet);
      String publicKey =
          "024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01";
      expect(generator.addressFromPublicKey(publicKey),
          'ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83');
    });

    test('Generate testnet address with public key ripemd160 hash', () {
      AddressGenerator generator = AddressGenerator(
          network: Network.testnet, codeHashIndex: CodeHashIndex.ripemd160);
      String publicKey =
          "024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01";
      expect(generator.addressFromPublicKey(publicKey),
          'ckt1qyquspzltz8xy75rsxqsjg7xr5rst5gtsmfsjh777d');
    });

    test('Generate mainnet address with public key blake160 hash', () {
      AddressGenerator generator = AddressGenerator(network: Network.mainnet);
      String publicKey =
          "024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01";
      expect(generator.addressFromPublicKey(publicKey),
          'ckb1qyqrdsefa43s6m882pcj53m4gdnj4k440axqdt9rtd');
    });

    test('Generate blake160 from mainnet address', () {
      AddressGenerator generator = AddressGenerator(network: Network.mainnet);
      String blake160 = generator.blake160FromAddress(
          'ckb1qyqrdsefa43s6m882pcj53m4gdnj4k440axqdt9rtd');
      expect(blake160, '0x36c329ed630d6ce750712a477543672adab57f4c');
    });
  });
}
