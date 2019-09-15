import 'dart:typed_data';

import '../base/fixed_type.dart';

class Empty extends FixedType {
  @override
  int getLength() {
    return 0;
  }

  @override
  Object getValue() {
    return null;
  }

  @override
  Uint8List toBytes() {
    return Uint8List.fromList(<int>[]);
  }
}
