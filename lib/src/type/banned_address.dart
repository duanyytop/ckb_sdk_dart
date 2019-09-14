class BannedAddress {
  String address;
  String banReason;
  String banUtil;
  String createAt;

  BannedAddress({this.address, this.banReason, this.banUtil, this.createAt});

  factory BannedAddress.fromJson(Map<String, dynamic> json) {
    return BannedAddress(
        address: json['address'],
        banReason: json['ban_reason'],
        banUtil: json['ban_util'],
        createAt: json['create_at']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'address': address,
      'ban_reason': banReason,
      'ban_util': banUtil,
      'create_at': createAt,
    };
  }
}
