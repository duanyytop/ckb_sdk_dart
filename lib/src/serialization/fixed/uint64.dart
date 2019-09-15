import 'dart:typed_data';

import '../base/fixed_type.dart';

class Uint64 extends FixedType<BigInt> {
  BigInt _value;

  Uint64(this._value);

  factory Uint64.fromHex(String hex) => Uint64(BigInt.parse(hex, radix: 16));

  @override
  int getLength() {
    return 8;
  }

  @override
  BigInt getValue() {
    return _value;
  }

  @override
  Uint8List toBytes() {
    return Uint8List.fromList([]
      ..add(_value.toInt())
      ..add((_value >> 8).toInt())
      ..add((_value >> 16).toInt())
      ..add((_value >> 24).toInt())
      ..add((_value >> 32).toInt())
      ..add((_value >> 40).toInt())
      ..add((_value >> 48).toInt())
      ..add((_value >> 56).toInt()));
  }
}
