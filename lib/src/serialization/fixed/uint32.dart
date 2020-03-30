import 'dart:typed_data';

import '../../utils/utils.dart';
import '../base/fixed_type.dart';

class UInt32 extends FixedType<int> {
  static final int byteSize = 4;

  int _value;

  UInt32(this._value);

  factory UInt32.fromHex(String hex) => UInt32(BigInt.parse(cleanHexPrefix(hex), radix: 16).toInt());

  // generate int value from little endian bytes
  factory UInt32.fromBytes(Uint8List bytes) {
    var result = 0;
    for (var i = 3; i >= 0; i--) {
      result += (bytes[i] & 0xff) << 8 * i;
    }
    return UInt32(result);
  }

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
    return Uint8List.fromList(<int>[_value, _value >> 8, _value >> 16, _value >> 24]);
  }
}
