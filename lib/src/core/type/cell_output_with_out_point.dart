import 'dart:convert';

import 'out_point.dart';
import 'script.dart';

class CellOutputWithOutPoint {
  String blockHash;
  String capacity;
  Script lock;
  OutPoint outPoint;

  CellOutputWithOutPoint({this.blockHash, this.capacity, this.lock, this.outPoint});

  factory CellOutputWithOutPoint.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return CellOutputWithOutPoint(
        blockHash: json['block_hash'],
        capacity: json['capacity'],
        lock: Script.fromJson(json['lock']),
        outPoint: OutPoint.fromJson(json['out_point']));
  }

  String toJson() {
    return jsonEncode(
        {'block_hash': blockHash, 'capacity': capacity, 'lock': lock.toJson(), 'out_point': outPoint.toJson()});
  }
}
