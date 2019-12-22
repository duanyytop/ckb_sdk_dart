import 'dart:typed_data';

import '../base/fixed_type.dart';
import '../base/serialize_type.dart';

class Struct extends FixedType<List<SerializeType>> {
  final List<SerializeType> _value;

  Struct(this._value);

  @override
  int getLength() {
    var length = 0;
    for (var type in _value) {
      length += type.getLength();
    }
    return length;
  }

  @override
  List<SerializeType> getValue() {
    return _value;
  }

  @override
  Uint8List toBytes() {
    var dest = <int>[];
    for (var type in _value) {
      dest.addAll(type.toBytes());
    }
    return Uint8List.fromList(dest);
  }
}
