class Cycles {
  String cycles;

  Cycles({this.cycles});

  factory Cycles.fromJson(Map<String, dynamic> json) {
    return Cycles(cycles: json['cycles']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'cycles': cycles,
    };
  }
}
