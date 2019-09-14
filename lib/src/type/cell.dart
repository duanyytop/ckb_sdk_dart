import 'cell_output.dart';

class Cell {
  CellOutput cell;
  String status;

  Cell({this.cell, this.status});

  factory Cell.fromJson(Map<String, dynamic> json) {
    return Cell(
        cell: CellOutput.fromJson(json['Cell']), status: json['status']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'cell': cell,
      'status': status,
    };
  }
}
