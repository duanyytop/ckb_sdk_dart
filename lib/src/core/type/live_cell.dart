import 'cell_output.dart';
import 'transaction_point.dart';

class LiveCell {
  TransactionPoint createdBy;
  CellOutput cellOutput;

  LiveCell({this.createdBy, this.cellOutput});

  factory LiveCell.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return LiveCell(
        createdBy: TransactionPoint.fromJson(json['created_by']),
        cellOutput: CellOutput.fromJson(json['cell_output']));
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'created_by': createdBy?.toJson(),
      'cell_output': cellOutput?.toJson(),
    };
  }
}
