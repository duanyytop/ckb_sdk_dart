import 'dart:typed_data';

import '../../utils/utils.dart';
import '../base/fixed_type.dart';

class UInt128 extends FixedType<BigInt> {
  final BigInt BYTE_BIGINT = BigInt.from(256);

  BigInt _value;

  UInt128(this._value);

  // generate int value from little endian bytes
  factory UInt128.fromBytes(Uint8List bytes) {
    var result = BigInt.zero;
    for (var i = 15; i >= 0; i--) {
      result += (BigInt.from(bytes[i] & 0xff) << 8 * i);
    }
    return UInt128(result);
  }

  factory UInt128.fromHex(String hex) {
    return UInt128.fromBytes(hexToList(hex));
  }

  @override
  int getLength() {
    return 16;
  }

  @override
  BigInt getValue() {
    return _value;
  }

  @override
  Uint8List toBytes() {
    return Uint8List.fromList([]
      ..add((_value & BYTE_BIGINT).toInt())
      ..add(((_value >> 8) % BYTE_BIGINT).toInt())
      ..add(((_value >> 16) % BYTE_BIGINT).toInt())
      ..add(((_value >> 24) % BYTE_BIGINT).toInt())
      ..add(((_value >> 32) % BYTE_BIGINT).toInt())
      ..add(((_value >> 40) % BYTE_BIGINT).toInt())
      ..add(((_value >> 48) % BYTE_BIGINT).toInt())
      ..add(((_value >> 56) % BYTE_BIGINT).toInt())
      ..add(((_value >> 64) % BYTE_BIGINT).toInt())
      ..add(((_value >> 72) % BYTE_BIGINT).toInt())
      ..add(((_value >> 80) % BYTE_BIGINT).toInt())
      ..add(((_value >> 88) % BYTE_BIGINT).toInt())
      ..add(((_value >> 96) % BYTE_BIGINT).toInt())
      ..add(((_value >> 104) % BYTE_BIGINT).toInt())
      ..add(((_value >> 112) % BYTE_BIGINT).toInt())
      ..add(((_value >> 120) % BYTE_BIGINT).toInt()));
  }
}
