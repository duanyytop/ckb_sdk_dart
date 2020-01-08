import 'dart:typed_data';

import 'package:ckb_sdk_dart/src/serialization/base/serialize_type.dart';

import '../base/dyn_type.dart';

class Option extends DynType<SerializeType> {
  final SerializeType _value;

  Option(this._value);

  @override
  int getLength() {
    return _value != null ? _value.getLength() : 0;
  }

  @override
  Option getValue() {
    return _value;
  }

  @override
  Uint8List toBytes() {
    return _value != null ? _value.toBytes() : Uint8List.fromList(<int>[]);
  }
}
