import 'dart:typed_data';

import '../../utils/utils.dart';
import '../base/fixed_type.dart';

class Byte32 extends FixedType<Uint8List> {
  Uint8List _value;

  Byte32(Uint8List value) {
    if (value.length != 32) {
      throw ('Byte32 length error');
    }
    _value = value;
  }

  factory Byte32.fromHex(String hex) {
    var list = hexToList(hex);
    if (list.length > 32) {
      throw ('Byte32 length error');
    } else if (list.length < 32) {
      var bytes = Uint8List(32);
      for (var i = 0; i < list.length; i++) {
        bytes[i] = list[i];
      }
      return Byte32(bytes);
    }
    return Byte32(list);
  }

  @override
  int getLength() {
    return 32;
  }

  @override
  Uint8List getValue() {
    return _value;
  }

  @override
  Uint8List toBytes() {
    return _value;
  }
}
