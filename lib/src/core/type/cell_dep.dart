import 'out_point.dart';

class CellDep {
  static const String code = 'code';
  static const String depGroup = 'dep_group';

  OutPoint outPoint;
  String depType;

  CellDep({this.outPoint, this.depType = code});

  factory CellDep.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return CellDep(
        outPoint: OutPoint.fromJson(json['out_point']),
        depType: json['dep_type']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'out_point': outPoint?.toJson(),
      'dep_type': depType,
    };
  }
}
