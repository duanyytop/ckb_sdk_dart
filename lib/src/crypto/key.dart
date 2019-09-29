import 'package:ckb_sdk_dart/src/rpc/api.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_contract.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';

import '../../ckb_crypto.dart';
import '../address/address_generator.dart';
import '../address/address_params.dart';
import '../type/script.dart';
import '../utils/utils.dart';

class Key {
  static String publicKeyFromPrivate(String privateKey,
      {bool compress = true}) {
    BigInt bigPrivateKey = hexToBigInt(privateKey);
    return listToHexNoPrefix((ECCurve_secp256k1().G * bigPrivateKey)
        .getEncoded(compress)
        .sublist(compress ? 0 : 1));
  }

  static Future<Script> generateLockScriptWithPrivateKey(
      {String privateKey, String codeHash, Api api}) async {
    if (codeHash == null && api == null) {
      throw ('Code hash or api must be not null at same time');
    }
    String publicKey = Key.publicKeyFromPrivate(privateKey);
    String blake160 = Blake2b.blake160(publicKey);
    if (codeHash == null) {
      codeHash = await SystemContract.getSecpCodeHash(api: api);
    }
    return Script(
        codeHash: codeHash,
        args: appendHexPrefix(blake160),
        hashType: Script.type);
  }

  static Future<Script> generateLockScriptWithAddress(
      {String address, String codeHash, Api api}) async {
    if (codeHash == null && api == null) {
      throw ('Code hash or api must be not null at same time');
    }
    AddressGenerator generator =
        AddressGenerator(network: AddressParams.parseNetwork(address));
    String publicKeyBlake160 = generator.blake160FromAddress(address);
    if (codeHash == null) {
      codeHash = await SystemContract.getSecpCodeHash(api: api);
    }
    return Script(
        codeHash: codeHash, args: publicKeyBlake160, hashType: Script.type);
  }
}
