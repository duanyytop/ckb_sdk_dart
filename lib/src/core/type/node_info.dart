import 'dart:convert';

class NodeInfo {
  List<Address> addresses;
  String nodeId;
  String version;

  NodeInfo({this.addresses, this.nodeId, this.version});

  factory NodeInfo.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return NodeInfo(
        addresses: (json['addresses'] as List).map((address) => Address.fromJson(address)).toList(),
        nodeId: json['node_id'],
        version: json['version']);
  }

  String toJson() {
    return jsonEncode({'addresses': addresses, 'node_id': nodeId, 'version': version});
  }
}

class Address {
  String address;
  String score;

  Address({this.address, this.score});

  factory Address.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Address(address: json['address'], score: json['score']);
  }

  String toJson() {
    return jsonEncode({'address': address, 'score': score});
  }
}
