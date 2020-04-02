import 'dart:convert';

import 'out_point.dart';

class CellDep {
  static const String Code = 'code';
  static const String DepGroup = 'dep_group';

  OutPoint outPoint;
  String depType;

  CellDep({this.outPoint, this.depType = Code});

  factory CellDep.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return CellDep(outPoint: OutPoint.fromJson(json['out_point']), depType: json['dep_type']);
  }

  String toJson() {
    return jsonEncode({
      'out_point': outPoint?.toJson(),
      'dep_type': depType,
    });
  }
}
