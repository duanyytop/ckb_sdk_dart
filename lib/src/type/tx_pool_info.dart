class TxPoolInfo {
  String lastTxsUpdatedAt;
  String pending;
  String staging;
  String orphan;
  String proposed;
  String totalTxCycles;
  String totalTxSize;

  TxPoolInfo(
      {this.lastTxsUpdatedAt,
      this.pending,
      this.staging,
      this.orphan,
      this.proposed,
      this.totalTxCycles,
      this.totalTxSize});

  factory TxPoolInfo.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return TxPoolInfo(
        lastTxsUpdatedAt: json['last_txs_updated_at'],
        pending: json['pending'],
        staging: json['staging'],
        orphan: json['orphan'],
        proposed: json['proposed'],
        totalTxCycles: json['total_tx_cycles'],
        totalTxSize: json['total_tx_size']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'last_txs_updated_at': lastTxsUpdatedAt,
      'pending': pending,
      'staging': staging,
      'orphan': orphan,
      'proposed': proposed,
      'total_tx_cycles': totalTxCycles,
      'total_tx_size': totalTxSize
    };
  }
}
