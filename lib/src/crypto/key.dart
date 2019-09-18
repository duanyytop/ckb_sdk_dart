import 'package:ckb_sdk_dart/ckb_crypto.dart';
import 'package:ckb_sdk_dart/src/address/address_generator.dart';
import 'package:ckb_sdk_dart/src/address/address_params.dart';
import 'package:ckb_sdk_dart/src/type/script.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';

import '../utils/utils.dart';

class Key {
  static String publicKeyFromPrivate(String privateKey,
      {bool compress = true}) {
    BigInt bigPrivateKey = hexToBigInt(privateKey);
    return listToHexNoPrefix((ECCurve_secp256k1().G * bigPrivateKey)
        .getEncoded(compress)
        .sublist(compress ? 0 : 1));
  }

  static Script generateLockScriptWithPrivateKey(
      String privateKey, String codeHash) {
    String publicKey = Key.publicKeyFromPrivate(privateKey);
    String blake160 = Blake2b.blake160(publicKey);
    return Script(
        codeHash: codeHash,
        args: [appendHexPrefix(blake160)],
        hashType: Script.type);
  }

  static Script generateLockScriptWithAddress(String address, String codeHash) {
    AddressGenerator generator =
        AddressGenerator(network: AddressParams.parseNetwork(address));
    String publicKeyBlake160 = generator.blake160FromAddress(address);
    return Script(
        codeHash: codeHash, args: [publicKeyBlake160], hashType: Script.type);
  }
}
