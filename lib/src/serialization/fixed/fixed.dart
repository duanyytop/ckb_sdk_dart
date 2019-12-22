import 'dart:typed_data';

import '../base/fixed_type.dart';
import '../base/serialize_type.dart';
import 'uint32.dart';

class Fixed<T extends FixedType> implements SerializeType<List<T>> {
  List<T> _value;

  Fixed(this._value);

  @override
  int getLength() {
    var length = UInt32.byteSize;
    for (SerializeType type in _value) {
      length += type.getLength();
    }
    return length;
  }

  @override
  List<T> getValue() {
    return _value;
  }

  @override
  Uint8List toBytes() {
    var dest = [...UInt32(_value.length).toBytes()];
    for (var type in _value) {
      dest.addAll(type.toBytes());
    }
    return Uint8List.fromList(dest);
  }
}
