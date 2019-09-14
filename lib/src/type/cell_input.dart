import 'out_point.dart';

class CellInput {
  OutPoint previousOutput;
  String since;

  CellInput({this.previousOutput, this.since});

  factory CellInput.fromJson(Map<String, dynamic> json) {
    return CellInput(
        previousOutput: json['previous_ouput'], since: json['since']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'previous_ouput': previousOutput,
      'since': since,
    };
  }
}
