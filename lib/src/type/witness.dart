class Witness {
  List<String> data;

  Witness({this.data});

  factory Witness.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Witness(
        data: (json['data'] as List)?.map((d) => d?.toString())?.toList());
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'data': data};
  }
}
