import 'package:pointycastle/ecc/curves/secp256k1.dart';

import '../utils/utils.dart';

String publicKeyFromPrivate(String privateKey, {bool compress = true}) {
  BigInt bigPrivateKey = BigInt.parse(cleanHexPrefix(privateKey), radix: 16);
  return listToHex((ECCurve_secp256k1().G * bigPrivateKey)
      .getEncoded(compress)
      .sublist(compress ? 0 : 1));
}
