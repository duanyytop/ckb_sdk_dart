class Witness {
  List<String> data;

  Witness({this.data});

  factory Witness.fromJson(Map<String, dynamic> json) {
    return Witness(data: List<String>.from(json['data']));
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'data': data};
  }
}
