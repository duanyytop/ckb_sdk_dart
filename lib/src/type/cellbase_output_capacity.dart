class CellbaseOutputCapacity {
  String primary;
  String proposalReward;
  String secondary;
  String total;
  String txFee;

  CellbaseOutputCapacity(
      {this.primary,
      this.proposalReward,
      this.secondary,
      this.total,
      this.txFee});

  factory CellbaseOutputCapacity.fromJson(Map<String, dynamic> json) {
    return CellbaseOutputCapacity(
        primary: json['primary'],
        proposalReward: json['proposal_reward'],
        secondary: json['secondary'],
        total: json['total'],
        txFee: json['tx_fee']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'primary': primary,
      'proposal_reward': proposalReward,
      'secondary': secondary,
      'total': total,
      'tx_fee': txFee,
    };
  }
}
