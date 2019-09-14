import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/digests/blake2b.dart';

import './utils.dart';

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

  updateWithString(String hex) {
    blake2bDigest.update(utf8.encode(hex), 0, utf8.encode(hex).length);
  }

  Uint8List doFinal() {
    var out = Uint8List(blake2bDigest.digestSize);
    var len = blake2bDigest.doFinal(out, 0);
    return out.sublist(0, len);
  }

  String doFinalString() => listToHex(doFinal());
}
