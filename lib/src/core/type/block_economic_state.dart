import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'block_economic_state.g.dart';

@JsonSerializable()
class BlockEconomicState {
  @JsonKey(name: 'finalized_at')
  String finalizedAt;
  Issuance issuance;
  @JsonKey(name: 'miner_reward')
  MinerReward minerReward;
  @JsonKey(name: 'txs_fee')
  String txsFee;

  BlockEconomicState({this.finalizedAt, this.issuance, this.minerReward, this.txsFee});

  factory BlockEconomicState.fromJson(Map<String, dynamic> json) => _$BlockEconomicStateFromJson(json);
  String toJson() => jsonEncode(_$BlockEconomicStateToJson(this));
}

@JsonSerializable()
class Issuance {
  String primary;
  String secondary;

  Issuance({this.primary, this.secondary});

  factory Issuance.fromJson(Map<String, dynamic> json) => _$IssuanceFromJson(json);
  String toJson() => jsonEncode(_$IssuanceToJson(this));
}

@JsonSerializable()
class MinerReward {
  String committed;
  String primary;
  String proposal;
  String secondary;

  MinerReward({this.committed = '0', this.primary = '0', this.proposal = '0', this.secondary = '0'});

  factory MinerReward.fromJson(Map<String, dynamic> json) => _$MinerRewardFromJson(json);
  String toJson() => jsonEncode(_$MinerRewardToJson(this));
}
