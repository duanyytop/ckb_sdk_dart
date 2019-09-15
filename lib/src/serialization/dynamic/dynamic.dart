import 'dart:typed_data';

import '../fixed/uint32.dart';
import '../base/serialize_type.dart';
import '../base/dyn_type.dart';

class Dynamic<T extends DynType> implements SerializeType<List<T>> {
  List<T> _value;

  Dynamic(this._value);

  @override
  int getLength() {
    return (1 + _value.length) * Uint32.byteSize +
        _value
            .map((type) => type.getLength())
            .reduce((value, element) => value + element);
  }

  @override
  List<T> getValue() {
    return _value;
  }

  @override
  Uint8List toBytes() {
    List<int> dest = <int>[]..addAll(Uint32(getLength()).toBytes());

    int offset = Uint32.byteSize;
    int typeOffset = Uint32.byteSize * (1 + _value.length);

    for (var type in _value) {
      dest.insertAll(offset, Uint32(typeOffset).toBytes());
      offset += Uint32.byteSize;
      typeOffset += type.getLength();
    }

    typeOffset = Uint32.byteSize * (1 + _value.length);
    for (var type in _value) {
      dest.insertAll(typeOffset, type.toBytes());
      typeOffset += type.getLength();
    }

    return Uint8List.fromList(dest);
  }
}
