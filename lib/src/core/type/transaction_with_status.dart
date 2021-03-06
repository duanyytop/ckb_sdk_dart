import 'dart:convert';

import 'transaction.dart';

class TransactionWithStatus {
  static String Committed = 'committed';

  TxStatus txStatus;
  Transaction transaction;

  TransactionWithStatus({this.txStatus, this.transaction});

  factory TransactionWithStatus.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return TransactionWithStatus(
        txStatus: TxStatus.fromJson(json['tx_status']), transaction: Transaction.fromJson(json['transaction']));
  }

  String toJson() {
    return jsonEncode({'tx_status': txStatus?.toJson(), 'transaction': transaction?.toJson()});
  }
}

class TxStatus {
  String status;
  String blockHash;

  TxStatus({this.status, this.blockHash});

  factory TxStatus.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return TxStatus(status: json['status'], blockHash: json['block_hash']);
  }

  String toJson() {
    return jsonEncode({'status': status, 'block_hash': blockHash});
  }
}
