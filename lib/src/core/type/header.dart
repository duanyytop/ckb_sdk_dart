class Header {
  String dao;
  String compactTarget;
  String hash;
  String number;
  String epoch;
  String parentHash;
  String nonce;
  String timestamp;
  String transactionsRoot;
  String proposalsHash;
  String unclesHash;
  String version;

  Header(
      {this.dao,
      this.compactTarget,
      this.hash,
      this.number,
      this.epoch,
      this.parentHash,
      this.nonce,
      this.timestamp,
      this.transactionsRoot,
      this.proposalsHash,
      this.unclesHash,
      this.version});

  factory Header.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Header(
        dao: json['dao'],
        compactTarget: json['compact_target'].toString(),
        hash: json['hash'],
        number: json['number'],
        epoch: json['epoch'],
        parentHash: json['parent_hash'],
        nonce: json['nonce'],
        timestamp: json['timestamp'],
        transactionsRoot: json['transactions_root'],
        proposalsHash: json['proposals_hash'],
        unclesHash: json['uncles_hash'],
        version: json['version']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'dao': dao,
      'compact_target': compactTarget,
      'hash': hash,
      'number': number,
      'epoch': epoch,
      'parent_hash': parentHash,
      'nonce': nonce,
      'timestamp': timestamp,
      'transactions_root': transactionsRoot,
      'proposals_hash': proposalsHash,
      'uncles_hash': unclesHash,
      'version': version
    };
  }
}
