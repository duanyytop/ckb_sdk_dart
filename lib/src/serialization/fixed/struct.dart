import 'dart:typed_data';

import 'package:ckb_sdk_dart/src/serialization/base/fixed_type.dart';

import '../base/serialize_type.dart';

class Struct extends FixedType<List<SerializeType>> {
  List<SerializeType> _value;

  Struct(this._value);

  @override
  int getLength() {
    return _value
        .map((type) => type.getLength())
        .reduce((value, element) => value + element);
  }

  @override
  List<SerializeType> getValue() {
    return _value;
  }

  @override
  Uint8List toBytes() {
    List<int> dest = [];
    for (var type in _value) {
      dest.addAll(type.toBytes());
    }
    return Uint8List.fromList(dest);
  }
}
