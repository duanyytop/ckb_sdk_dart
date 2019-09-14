import 'script.dart';
import 'out_point.dart';

class CellOutputWithOutPoint {
  String capacity;
  Script lock;
  OutPoint outPoint;

  CellOutputWithOutPoint({this.capacity, this.lock, this.outPoint});

  factory CellOutputWithOutPoint.fromJson(Map<String, dynamic> json) {
    return CellOutputWithOutPoint(
        capacity: json['capacity'],
        lock: Script.fromJson(json['lock']),
        outPoint: OutPoint.fromJson(json['out_point']));
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'capacity': capacity,
      'lock': lock,
      'out_point': outPoint
    };
  }
}
