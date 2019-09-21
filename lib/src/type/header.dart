class Header {
  String dao;
  String difficulty;
  String hash;
  String number;
  String epoch;
  String parentHash;
  String nonce;
  String timestamp;
  String transactionsRoot;
  String proposalsHash;
  String witnessesRoot;
  String unclesCount;
  String unclesHash;
  String version;

  Header(
      {this.dao,
      this.difficulty,
      this.hash,
      this.number,
      this.epoch,
      this.parentHash,
      this.nonce,
      this.timestamp,
      this.transactionsRoot,
      this.proposalsHash,
      this.witnessesRoot,
      this.unclesCount,
      this.unclesHash,
      this.version});

  factory Header.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Header(
        dao: json['dao'],
        difficulty: json['difficulty'],
        hash: json['hash'],
        number: json['number'],
        epoch: json['epoch'],
        parentHash: json['parent_hash'],
        nonce: json['nonce'],
        timestamp: json['timestamp'],
        transactionsRoot: json['transactions_root'],
        proposalsHash: json['proposals_hash'],
        witnessesRoot: json['witnesses_root'],
        unclesCount: json['uncles_count'],
        unclesHash: json['uncles_hash'],
        version: json['version']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'dao': dao,
      'difficulty': difficulty,
      'hash': hash,
      'number': number,
      'epoch': epoch,
      'parent_hash': parentHash,
      'nonce': nonce,
      'timestamp': timestamp,
      'transactions_root': transactionsRoot,
      'proposals_hash': proposalsHash,
      'witnesses_root': witnessesRoot,
      'uncles_count': unclesCount,
      'uncles_hash': unclesHash,
      'version': version
    };
  }
}
