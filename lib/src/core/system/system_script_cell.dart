import 'package:ckb_sdk_dart/src/core/type/out_point.dart';

class SystemScriptCell {
  String cellHash;
  OutPoint outPoint;

  SystemScriptCell({this.cellHash, this.outPoint});
}
