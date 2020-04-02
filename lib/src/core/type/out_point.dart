import 'dart:convert';

class OutPoint {
  String txHash;
  String index;

  OutPoint({this.txHash, this.index});

  factory OutPoint.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return OutPoint(txHash: json['tx_hash'], index: json['index']);
  }

  String toJson() {
    return jsonEncode({
      'tx_hash': txHash,
      'index': index,
    });
  }
}
