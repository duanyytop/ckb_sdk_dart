import 'package:ckb_sdk_dart/ckb_core.dart';

class CellWithBlock {
  CellInput input;
  BigInt height;
  String blockHash;
  BigInt wckbAmount;

  CellWithBlock({this.input, this.height, this.blockHash, this.wckbAmount});
}
