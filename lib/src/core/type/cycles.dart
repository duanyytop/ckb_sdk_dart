import 'dart:convert';

class Cycles {
  String cycles;

  Cycles({this.cycles});

  factory Cycles.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Cycles(cycles: json['cycles']);
  }

  String toJson() {
    return jsonEncode({
      'cycles': cycles,
    });
  }
}
