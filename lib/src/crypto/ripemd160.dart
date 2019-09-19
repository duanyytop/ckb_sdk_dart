import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

import '../utils/utils.dart';

class Ripemd160 {
  RIPEMD160Digest _ripemd160digest;

  Ripemd160() {
    _ripemd160digest = RIPEMD160Digest();
  }

  update(Uint8List input) {
    _ripemd160digest.update(input, 0, input.length);
  }

  updateString(String utf8String) {
    update(utf8.encode(cleanHexPrefix(utf8String)));
  }

  Uint8List doFinal() {
    var out = Uint8List(_ripemd160digest.digestSize);
    int len = _ripemd160digest.doFinal(out, 0);
    return out.sublist(0, len);
  }

  String doFinalString() => listToHex(doFinal());

  static String hash(String input) {
    Ripemd160 ripemd160 = Ripemd160();
    ripemd160.updateString(input);
    return ripemd160.doFinalString();
  }
}
