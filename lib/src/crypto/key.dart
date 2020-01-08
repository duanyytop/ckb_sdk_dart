import 'package:ckb_sdk_dart/src/address/address_parser.dart';
import 'package:ckb_sdk_dart/src/core/rpc/api.dart';
import 'package:ckb_sdk_dart/src/core/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/core/type/script.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';

import '../../ckb_crypto.dart';
import '../utils/utils.dart';

String publicKeyFromPrivate(String privateKey, {bool compress = true}) {
  var bigPrivateKey = hexToBigInt(privateKey);
  return listToHexNoPrefix((ECCurve_secp256k1().G * bigPrivateKey)
      .getEncoded(compress)
      .sublist(compress ? 0 : 1));
}

Future<Script> generateLockScriptWithPrivateKey(
    {String privateKey, String codeHash, Api api}) async {
  if (codeHash == null && api == null) {
    throw ('Code hash or api must be not null at same time');
  }
  var publicKey = publicKeyFromPrivate(privateKey);
  var blake160 = Blake2b.blake160(publicKey);
  codeHash ??= await SystemContract.getSecpCodeHash(api: api);
  return Script(
      codeHash: codeHash,
      args: appendHexPrefix(blake160),
      hashType: Script.Type);
}

Script generateLockScriptWithAddress(String address) {
  return AddressParser.parse(address).script;
}
