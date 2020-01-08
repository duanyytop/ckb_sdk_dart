class Witness {
  static final String SIGNATURE_PLACEHOLDER = '0' * 130;

  String lock;
  String inputType;
  String outputType;

  Witness({this.lock, this.inputType, this.outputType});

  factory Witness.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Witness(
        lock: json['lock'],
        inputType: json['input_type'],
        outputType: json['output_type']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'lock': lock,
      'input_type': inputType,
      'output_type': outputType,
    };
  }
}
