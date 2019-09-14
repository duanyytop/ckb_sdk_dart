import 'cell_output.dart';
import 'transaction_point.dart';

class LiveCell {
  TransactionPoint createdBy;
  CellOutput cellOutput;

  LiveCell({this.createdBy, this.cellOutput});

  factory LiveCell.fromJson(Map<String, dynamic> json) {
    return LiveCell(
        createdBy: json['created_by'], cellOutput: json['cell_output']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'created_by': createdBy,
      'cell_output': cellOutput,
    };
  }
}
