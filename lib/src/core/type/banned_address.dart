import 'dart:convert';

class BannedAddress {
  String address;
  String banReason;
  String banUntil;
  String createAt;

  BannedAddress({this.address, this.banReason, this.banUntil, this.createAt});

  factory BannedAddress.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return BannedAddress(
        address: json['address'],
        banReason: json['ban_reason'],
        banUntil: json['ban_until'],
        createAt: json['create_at']);
  }

  String toJson() {
    return jsonEncode({
      'address': address,
      'ban_reason': banReason,
      'ban_until': banUntil,
      'create_at': createAt,
    });
  }
}
