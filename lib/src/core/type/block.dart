import 'dart:convert';

import 'header.dart';
import 'transaction.dart';

class Block {
  Header header;
  List<Transaction> transactions;
  List<String> proposals;
  List<Uncle> uncles;

  Block({this.header, this.transactions, this.proposals, this.uncles});

  factory Block.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Block(
        header: Header.fromJson(json['header']),
        transactions: (json['transactions'] as List)?.map((transaction) => Transaction.fromJson(transaction))?.toList(),
        proposals: (json['proposals'] as List)?.map((proposal) => proposal?.toString())?.toList(),
        uncles: (json['uncles'] as List)?.map((uncle) => Uncle.fromJson(uncle))?.toList());
  }

  String toJson() {
    return jsonEncode({
      'header': header.toJson(),
      'uncles': uncles?.map((uncle) => uncle.toJson())?.toList(),
      'proposals': proposals,
      'transactions': transactions?.map((transaction) => transaction.toJson())?.toList()
    });
  }
}

class Uncle {
  Header header;
  List<String> proposals;

  Uncle({this.header, this.proposals});

  factory Uncle.fromJson(Map<String, dynamic> json) {
    return Uncle(header: Header.fromJson(json['header']), proposals: json['proposals']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'header': header?.toJson(), 'proposals': proposals};
  }
}
