import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/address/address_generator.dart';
import 'package:ckb_sdk_dart/src/address/address_type.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of address generator', () {
    setUp(() {});

    test('Generate testnet address with any arg', () {
      var singleSigShortScript = Script(
          codeHash:
              '0x9bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8',
          args: '0x36c329ed630d6ce750712a477543672adab57f4c',
          hashType: Script.Type);
      var address =
          AddressGenerator.generate(Network.TESTNET, singleSigShortScript);
      expect(address, 'ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83');
    });
  });
}
