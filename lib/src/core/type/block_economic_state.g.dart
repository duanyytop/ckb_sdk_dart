// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_economic_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockEconomicState _$BlockEconomicStateFromJson(Map<String, dynamic> json) {
  return BlockEconomicState(
    finalizedAt: json['finalized_at'] as String,
    issuance: json['issuance'] == null
        ? null
        : Issuance.fromJson(json['issuance'] as Map<String, dynamic>),
    minerReward: json['miner_reward'] == null
        ? null
        : MinerReward.fromJson(json['miner_reward'] as Map<String, dynamic>),
    txsFee: json['txs_fee'] as String,
  );
}

Map<String, dynamic> _$BlockEconomicStateToJson(BlockEconomicState instance) =>
    <String, dynamic>{
      'finalized_at': instance.finalizedAt,
      'issuance': instance.issuance,
      'miner_reward': instance.minerReward,
      'txs_fee': instance.txsFee,
    };

Issuance _$IssuanceFromJson(Map<String, dynamic> json) {
  return Issuance(
    primary: json['primary'] as String,
    secondary: json['secondary'] as String,
  );
}

Map<String, dynamic> _$IssuanceToJson(Issuance instance) => <String, dynamic>{
      'primary': instance.primary,
      'secondary': instance.secondary,
    };

MinerReward _$MinerRewardFromJson(Map<String, dynamic> json) {
  return MinerReward(
    committed: json['committed'] as String,
    primary: json['primary'] as String,
    proposal: json['proposal'] as String,
    secondary: json['secondary'] as String,
  );
}

Map<String, dynamic> _$MinerRewardToJson(MinerReward instance) =>
    <String, dynamic>{
      'committed': instance.committed,
      'primary': instance.primary,
      'proposal': instance.proposal,
      'secondary': instance.secondary,
    };
