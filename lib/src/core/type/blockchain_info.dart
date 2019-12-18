import 'alert_message.dart';

class BlockchainInfo {
  bool isInitialBlockDownload;
  String epoch;
  String difficulty;
  String medianTime;
  String chain;
  List<AlertMessage> alerts;

  BlockchainInfo(
      {this.isInitialBlockDownload,
      this.epoch,
      this.difficulty,
      this.medianTime,
      this.chain,
      this.alerts});

  factory BlockchainInfo.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return BlockchainInfo(
        isInitialBlockDownload: json['is_initial_block_download'],
        epoch: json['epoch'],
        difficulty: json['difficulty'],
        medianTime: json['median_time'],
        chain: json['chain'],
        alerts: (json['alerts'] as List)
            ?.map((alert) => AlertMessage.fromJson(alert))
            ?.toList());
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'is_initial_block_download': isInitialBlockDownload,
      'epoch': epoch,
      'difficulty': difficulty,
      'median_time': medianTime,
      'chain': chain,
      'alerts': alerts,
    };
  }
}
