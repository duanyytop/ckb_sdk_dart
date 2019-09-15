import 'dart:typed_data';

import '../fixed/uint32.dart';
import '../base/serialize_type.dart';

class Table extends SerializeType<List<SerializeType>> {
  List<SerializeType> _value;

  Table(this._value);

  @override
  int getLength() {
    return (1 + _value.length) * Uint32.byteSize +
        _value
            .map((type) => type.getLength())
            .reduce((value, element) => value + element);
  }

  @override
  List<SerializeType> getValue() {
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
