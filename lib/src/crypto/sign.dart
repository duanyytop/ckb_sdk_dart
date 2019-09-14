import 'dart:typed_data';

import './ecdsa_signature.dart';
import './key.dart';
import './utils.dart';

import 'package:pointycastle/export.dart';
import 'package:pointycastle/impl.dart';

final ECDomainParameters params = ECCurve_secp256k1();
final BigInt _halfCurveOrder = params.n ~/ BigInt.two;

class Sign {
  static EcdaSignature signMessage(Uint8List messageHash, String privateKey) {
    var digest = SHA256Digest();
    var signer = ECDSASigner(null, HMac(digest, 64));
    var key = ECPrivateKey(BigInt.parse(privateKey, radix: 16), params);

    signer.init(true, PrivateKeyParameter(key));
    ECSignature sig = signer.generateSignature(messageHash);

    if (sig.s.compareTo(_halfCurveOrder) > 0) {
      var canonicalisedS = params.n - sig.s;
      sig = ECSignature(sig.r, canonicalisedS);
    }

    var publicKey = BigInt.parse(
        publicKeyFromPrivate(privateKey, compress: false),
        radix: 16);

    var recId = -1;
    for (var i = 0; i < 4; i++) {
      var k = _recoverFromSignature(i, sig, messageHash, params);
      if (k == publicKey) {
        recId = i;
        break;
      }
    }

    if (recId == -1) {
      throw Exception(
          "Could not construct a recoverable key. This should never happen");
    }

    return EcdaSignature(Uint8List.fromList(toBytesPadded(sig.r, 32)),
        Uint8List.fromList(toBytesPadded(sig.s, 32)), recId);
  }

  static BigInt _recoverFromSignature(int recId, ECSignature sig,
      Uint8List message, ECDomainParameters params) {
    var n = params.n;
    var i = BigInt.from(recId ~/ 2);
    var x = sig.r + (i * n);

    var prime = BigInt.parse(
        "fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f",
        radix: 16);
    if (x.compareTo(prime) >= 0) return null;

    var R = _decompressKey(x, (recId & 1) == 1, params.curve);
    if (!(R * n).isInfinity) return null;

    var e = listToBigInt(message);

    var eInv = (BigInt.zero - e) % n;
    var rInv = sig.r.modInverse(n);
    var srInv = (rInv * sig.s) % n;
    var eInvrInv = (rInv * eInv) % n;

    var q = (params.G * eInvrInv) + (R * srInv);

    var bytes = q.getEncoded(false);
    return listToBigInt(bytes.sublist(1));
  }

  static ECPoint _decompressKey(BigInt xBN, bool yBit, ECCurve c) {
    List<int> x9IntegerToBytes(BigInt s, int qLength) {
      var bytes = bigIntToList(s);

      if (qLength < bytes.length) {
        return bytes.sublist(0, bytes.length - qLength);
      } else if (qLength > bytes.length) {
        var tmp = List<int>.filled(qLength, 0);
        var offset = qLength - bytes.length;
        for (var i = 0; i < bytes.length; i++) {
          tmp[i + offset] = bytes[i];
        }
        return tmp;
      }
      return bytes;
    }

    var compEnc = x9IntegerToBytes(xBN, 1 + ((c.fieldSize + 7) ~/ 8));
    compEnc[0] = yBit ? 0x03 : 0x02;
    return c.decodePoint(compEnc);
  }
}
