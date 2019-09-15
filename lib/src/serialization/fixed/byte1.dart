import 'dart:typed_data';

import '../../utils/utils.dart';
import '../base/fixed_type.dart';

class Byte1 extends FixedType<Uint8List> {
  Uint8List _value;

  Byte1(this._value);

  factory Byte1.fromHex(String hex) => Byte1(hexToList(hex));

  @override
  int getLength() {
    return 1;
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
