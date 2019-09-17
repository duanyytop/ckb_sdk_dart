import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/digests/blake2b.dart';

import '../utils/utils.dart';

class Blake2b {
  final String ckbHashPersonalization = "ckb-default-hash";

  Blake2bDigest blake2bDigest;

  Blake2b({int digestSize = 32}) {
    blake2bDigest = Blake2bDigest(
        digestSize: digestSize,
        personalization: utf8.encode(ckbHashPersonalization));
  }

  update(Uint8List input) {
    blake2bDigest.update(input, 0, input.length);
  }

  updateWithUtf8(String utf8String) {
    update(utf8.encode(utf8String));
  }

  updateWithHex(String hex) {
    update(hexToList(hex));
  }

  Uint8List doFinal() {
    var out = Uint8List(blake2bDigest.digestSize);
    var len = blake2bDigest.doFinal(out, 0);
    return out.sublist(0, len);
  }

  String doFinalString() => listToHex(doFinal());

  static String blake160(String value) {
    Blake2b blake2b = Blake2b();
    blake2b.updateWithHex(value);
    return blake2b.doFinalString().substring(0, 40);
  }
}
