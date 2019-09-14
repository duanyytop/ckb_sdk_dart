class TxPoolInfo {
  String pending;
  String staging;
  String orphan;

  TxPoolInfo({this.pending, this.staging, this.orphan});

  factory TxPoolInfo.fromJson(Map<String, dynamic> json) {
    return TxPoolInfo(
        pending: json['pending'],
        staging: json['staging'],
        orphan: json['orphan']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pending': pending,
      'staging': staging,
      'orphan': orphan
    };
  }
}
