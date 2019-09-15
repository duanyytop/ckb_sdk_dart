import 'package:ckb_sdk_dart/src/type/out_point.dart';

class CellDep {
  static final String code = 'code';
  static final String depGroup = 'dep_group';

  OutPoint outPoint;
  String depType;

  CellDep({this.outPoint, this.depType});

  factory CellDep.fromJson(Map<String, dynamic> json) {
    return CellDep(outPoint: json['out_point'], depType: json['dep_type']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'out_point': outPoint,
      'dep_type': depType,
    };
  }
}
