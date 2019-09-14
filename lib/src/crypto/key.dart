import './utils.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';

String publicKeyFromPrivate(String privateKey, {bool compress = true}) {
  BigInt bigPrivateKey = BigInt.parse(privateKey, radix: 16);
  return listToHex((ECCurve_secp256k1().G * bigPrivateKey)
      .getEncoded(compress)
      .sublist(compress ? 0 : 1));
}
