import 'dart:convert';

class Epoch {
  String number;
  String startNumber;
  String length;
  String compactTarget;

  Epoch({this.number, this.startNumber, this.length, this.compactTarget});

  factory Epoch.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Epoch(
        number: json['number'],
        startNumber: json['start_number'],
        length: json['length'],
        compactTarget: json['compact_target']);
  }

  String toJson() {
    return jsonEncode({
      'number': number,
      'start_number': startNumber,
      'length': length,
      'compact_target': compactTarget,
    });
  }
}
