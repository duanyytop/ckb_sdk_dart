import 'package:ckb_sdk_dart/src/utils/utils.dart';

import 'script.dart';

class CellOutput {
  String capacity;
  Script lock;
  Script type;

  CellOutput({this.capacity, this.lock, this.type});

  factory CellOutput.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return CellOutput(
        capacity: json['capacity'],
        lock: Script.fromJson(json['lock']),
        type: Script.fromJson(json['type']));
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'capacity': capacity,
      'lock': lock?.toJson(),
      'type': type?.toJson()
    };
  }

  int calculateByteSize(String data) {
    if (data == null) {
      throw ('Please provide a valid data');
    }
    int byteSize = 8 + hexToList(data).length + lock.calculateByteSize();
    byteSize += type == null ? 0 : type.calculateByteSize();
    return byteSize;
  }

}
