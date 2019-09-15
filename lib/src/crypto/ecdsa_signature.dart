import 'dart:typed_data';

import '../utils/utils.dart';

class EcdaSignature {
  final Uint8List r;
  final Uint8List s;
  final int v;

  EcdaSignature(this.r, this.s, this.v);

  Uint8List getSignature() {
    var dest = Uint8List(65);
    List.copyRange(dest, 0, r);
    List.copyRange(dest, 32, s);
    dest[64] = v;
    return dest;
  }

  String getSignatureString() {
    return listToHex(getSignature());
  }
}
