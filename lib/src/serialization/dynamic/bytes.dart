import 'dart:typed_data';

import '../../utils/utils.dart';
import '../base/dyn_type.dart';
import '../fixed/uint32.dart';

class Bytes extends DynType<Uint8List> {
  Uint8List _value;

  Bytes(this._value);

  factory Bytes.fromHex(String hex) => Bytes(hexToList(hex));

  @override
  int getLength() {
    return _value.length + UInt32.byteSize;
  }

  @override
  Uint8List getValue() {
    return _value;
  }

  @override
  Uint8List toBytes() {
    return Uint8List.fromList([...UInt32(_value.length).toBytes(), ..._value]);
  }
}
