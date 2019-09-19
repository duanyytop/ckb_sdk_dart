import 'transaction_point.dart';

class CellTransaction {
  TransactionPoint createBy;
  TransactionPoint consumedBy;

  CellTransaction({this.createBy, this.consumedBy});

  factory CellTransaction.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return CellTransaction(
        createBy: TransactionPoint.fromJson(json['create_by']),
        consumedBy: TransactionPoint.fromJson(json['consumed_by']));
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'create_by': createBy,
      'consumed_by': consumedBy,
    };
  }
}
