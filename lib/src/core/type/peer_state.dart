import 'dart:convert';

class PeerState {
  String lastUpdate;
  String blocksInFlight;
  String peer;

  PeerState({this.lastUpdate, this.blocksInFlight, this.peer});

  factory PeerState.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return PeerState(lastUpdate: json['last_updated'], blocksInFlight: json['blocks_in_flight'], peer: json['peer']);
  }

  String toJson() {
    return jsonEncode({
      'last_updated': lastUpdate,
      'blocks_in_flight': blocksInFlight,
      'peer': peer,
    });
  }
}
