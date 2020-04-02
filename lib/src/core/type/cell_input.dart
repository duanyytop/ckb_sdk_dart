import 'dart:convert';

import 'out_point.dart';

class CellInput {
  OutPoint previousOutput;
  String since;

  CellInput({this.previousOutput, this.since});

  factory CellInput.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return CellInput(previousOutput: OutPoint.fromJson(json['previous_output']), since: json['since']);
  }

  String toJson() {
    return jsonEncode({
      'previous_output': previousOutput?.toJson(),
      'since': since,
    });
  }
}
