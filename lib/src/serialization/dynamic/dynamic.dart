import 'dart:typed_data';

import '../base/serialize_type.dart';
import '../fixed/uint32.dart';

class Dynamic<T extends SerializeType> implements SerializeType<List<T>> {
  final List<T> _value;

  Dynamic(this._value);

  @override
  int getLength() {
    var length = (1 + _value?.length) * UInt32.byteSize;
    for (SerializeType type in _value) {
      length += type?.getLength();
    }
    return length;
  }

  @override
  List<T> getValue() {
    return _value;
  }

  @override
  Uint8List toBytes() {
   var dest = [...UInt32(getLength()).toBytes()];

    var typeOffset = UInt32.byteSize * (1 + _value.length);

    for (var type in _value) {
      dest.addAll(UInt32(typeOffset).toBytes());
      typeOffset += type.getLength();
    }

    for (var type in _value) {
      dest.addAll(type.toBytes());
    }

    return Uint8List.fromList(dest);
  }
}
