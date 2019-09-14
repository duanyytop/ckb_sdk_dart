class Epoch {
  String number;
  String startNumber;
  String length;
  String difficulty;

  Epoch({this.number, this.startNumber, this.length, this.difficulty});

  factory Epoch.fromJson(Map<String, dynamic> json) {
    return Epoch(
        number: json['number'],
        startNumber: json['start_number'],
        length: json['length'],
        difficulty: json['difficulty']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'number': number,
      'start_number': startNumber,
      'length': length,
      'difficulty': difficulty,
    };
  }
}
