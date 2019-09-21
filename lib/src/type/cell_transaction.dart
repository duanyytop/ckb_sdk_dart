import 'transaction_point.dart';

class CellTransaction {
  TransactionPoint createdBy;
  TransactionPoint consumedBy;

  CellTransaction({this.createdBy, this.consumedBy});

  factory CellTransaction.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return CellTransaction(
        createdBy: TransactionPoint.fromJson(json['created_by']),
        consumedBy: TransactionPoint.fromJson(json['consumed_by']));
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'created_by': createdBy?.toJson(),
      'consumed_by': consumedBy?.toJson(),
    };
  }
}
