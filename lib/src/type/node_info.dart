class NodeInfo {
  List<Address> addresses;
  String nodeId;
  String version;

  NodeInfo({this.addresses, this.nodeId, this.version});

  factory NodeInfo.fromJson(Map<String, dynamic> json) {
    return NodeInfo(
        addresses: List.from(json['addresses'])
            .map((address) => Address.fromJson(address))
            .toList(),
        nodeId: json['node_id'],
        version: json['version']);
  }

  Map<String, dynamic> toJson() {
    return {'addresses': addresses, 'node_id': nodeId, 'version': version};
  }
}

class Address {
  String address;
  String score;

  Address({this.address, this.score});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(address: json['address'], score: json['score']);
  }

  Map<String, dynamic> toJson() {
    return {'address': address, 'score': score};
  }
}
