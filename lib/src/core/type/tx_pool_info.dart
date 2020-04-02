import 'dart:convert';

class TxPoolInfo {
  String lastTxsUpdatedAt;
  String pending;
  String staging;
  String orphan;
  String proposed;
  String totalTxCycles;
  String totalTxSize;
  String minFeeRate;

  TxPoolInfo(
      {this.lastTxsUpdatedAt,
      this.pending,
      this.staging,
      this.orphan,
      this.proposed,
      this.totalTxCycles,
      this.totalTxSize,
      this.minFeeRate});

  factory TxPoolInfo.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return TxPoolInfo(
        lastTxsUpdatedAt: json['last_txs_updated_at'],
        pending: json['pending'],
        staging: json['staging'],
        orphan: json['orphan'],
        proposed: json['proposed'],
        totalTxCycles: json['total_tx_cycles'],
        totalTxSize: json['total_tx_size'],
        minFeeRate: json['min_fee_rate']);
  }

  String toJson() {
    return jsonEncode({
      'last_txs_updated_at': lastTxsUpdatedAt,
      'pending': pending,
      'staging': staging,
      'orphan': orphan,
      'proposed': proposed,
      'total_tx_cycles': totalTxCycles,
      'total_tx_size': totalTxSize,
      'min_fee_rate': minFeeRate
    });
  }
}
