import 'dart:typed_data';

import '../base/fixed_type.dart';
import '../base/serialize_type.dart';
import 'uint32.dart';

class Fixed<T extends FixedType> implements SerializeType<List<T>> {
  List<T> _value;

  Fixed(this._value);

  @override
  int getLength() {
    return Uint32.byteSize +
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
    for (var type in _value) {
      dest.insertAll(offset, type.toBytes());
      offset += type.getLength();
    }
    return Uint8List.fromList(dest);
  }
}
