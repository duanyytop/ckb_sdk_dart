import 'transaction.dart';

class TransactionWithStatus {
  TxStatus txStatus;
  Transaction transaction;

  TransactionWithStatus({this.txStatus, this.transaction});

  factory TransactionWithStatus.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return TransactionWithStatus(
        txStatus: json['tx_status'], transaction: json['transaction']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'tx_status': txStatus, 'transaction': transaction};
  }
}

class TxStatus {
  String status;
  String blockHash;

  TxStatus({this.status, this.blockHash});

  factory TxStatus.fromJson(Map<String, dynamic> json) {
    return TxStatus(status: json['status'], blockHash: json['block_hash']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'status': status, 'block_hash': blockHash};
  }
}
