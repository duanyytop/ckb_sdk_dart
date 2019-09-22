import 'package:ckb_sdk_dart/src/type/cell_input.dart';

class Cells {
  List<CellInput> inputs;
  BigInt capacity;

  Cells({this.inputs, this.capacity});
}
