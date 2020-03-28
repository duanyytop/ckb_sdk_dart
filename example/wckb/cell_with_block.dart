import 'package:ckb_sdk_dart/ckb_core.dart';

class CellWithBlock {
  CellInput input;
  String height;
  String blockHash;
  String wckbAmount;

  CellWithBlock({this.input, this.height, this.blockHash, this.wckbAmount});
}
