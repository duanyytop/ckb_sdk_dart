import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/digests/blake2b.dart';

import '../utils/utils.dart';

class Blake2b {
  String CkbHashPersonalization = 'ckb-default-hash';

  Blake2bDigest _blake2bDigest;

  Blake2b({int digestSize = 32}) {
    _blake2bDigest = Blake2bDigest(digestSize: digestSize, personalization: utf8.encode(CkbHashPersonalization));
  }

  void update(Uint8List input) {
    _blake2bDigest.update(input, 0, input.length);
  }

  void updateWithUtf8(String utf8String) {
    update(utf8.encode(utf8String));
  }

  void updateWithHex(String hex) {
    update(hexToList(hex));
  }

  Uint8List doFinal() {
    var out = Uint8List(_blake2bDigest.digestSize);
    var len = _blake2bDigest.doFinal(out, 0);
    return out.sublist(0, len);
  }

  String doFinalString() => listToHex(doFinal());

  static String blake160(String value) {
    var blake2b = Blake2b();
    blake2b.updateWithHex(value);
    return appendHexPrefix(
        listToHexNoPrefix(blake2b.doFinal()).substring(0, 40));
  }

  static String hash(String value) {
    var blake2b = Blake2b();
    blake2b.updateWithHex(value);
    return blake2b.doFinalString();
  }
}
