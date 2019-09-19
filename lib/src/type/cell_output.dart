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
}
