import 'dart:typed_data';

import '../base/fixed_type.dart';

class Uint32 extends FixedType<int> {
  static final int byteSize = 4;

  int _value;

  Uint32(this._value);

  factory Uint32.fromHex(String hex) =>
      Uint32(BigInt.parse(hex, radix: 16).toInt());

  @override
  int getLength() {
    return byteSize;
  }

  @override
  int getValue() {
    return _value;
  }

  @override
  Uint8List toBytes() {
    return Uint8List.fromList(
        <int>[_value, _value >> 8, _value >> 16, _value >> 24]);
  }
}
