import 'dart:convert';
import 'dart:typed_data';

import 'package:pinenacl/public.dart' as crypto;

import '../utils/utils.dart';

class Blake2b {
  String CkbHashPersonalization = 'ckb-default-hash';

  var state;

  Blake2b({int digestSize = 32}) {
    state = crypto.Blake2b.init(digestSize, null, null, utf8.encode(CkbHashPersonalization));
  }

  void update(Uint8List input) {
    crypto.Blake2b.update(state, input);
  }

  void updateWithUtf8(String utf8String) {
    update(utf8.encode(utf8String));
  }

  void updateWithHex(String hex) {
    update(hexToList(hex));
  }

  Uint8List doFinal() {
    return crypto.Blake2b.finalise(state);
  }

  String doFinalString() => listToHex(doFinal());

  static String blake160(String value) {
    var blake2b = Blake2b();
    blake2b.updateWithHex(value);
    return appendHexPrefix(listToHexNoPrefix(blake2b.doFinal()).substring(0, 40));
  }

  static String hash(String value) {
    var blake2b = Blake2b();
    blake2b.updateWithHex(value);
    return blake2b.doFinalString();
  }
}
