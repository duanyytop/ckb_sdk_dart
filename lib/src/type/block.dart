import 'package:ckb_sdk_dart/src/type/header.dart';
import 'package:ckb_sdk_dart/src/type/transaction.dart';

class Block {
  Header header;
  List<Transaction> transactions;
  List<String> proposals;
  List<Uncle> uncles;

  Block({this.header, this.transactions, this.proposals, this.uncles});

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
        header: Header.fromJson(json['header']),
        transactions: List.from(json['transactions'])
            .map((transaction) => Transaction.fromJson(transaction))
            .toList(),
        proposals: List<String>.from(json['proposals']),
        uncles: List.from(json['uncles'])
            .map((uncle) => Uncle.fromJson(uncle))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'header': header,
      'uncles': uncles,
      'proposals': proposals,
      'transactions': transactions
    };
  }
}

class Uncle {
  Header header;
  List<String> proposals;

  Uncle({this.header, this.proposals});

  factory Uncle.fromJson(Map<String, dynamic> json) {
    return Uncle(header: json['header'], proposals: json['proposals']);
  }
}
