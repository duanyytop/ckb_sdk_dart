import 'dart:typed_data';

abstract class SerializeType<T> {
  Uint8List toBytes();
  T getValue();
  int getLength();
}
