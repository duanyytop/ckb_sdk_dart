import 'dart:convert';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:test/test.dart';

void main() {
  dynamic _json;
  group('A group tests of peer state', () {
    setUp(() {
      String peerState = '''{
        "blocks_in_flight": "0x56",
        "last_updated": "0x16a95af332d",
        "peer": "0x1"
      }''';
      _json = jsonDecode(peerState);
    });

    test('fromJson', () async {
      PeerState peerState = PeerState.fromJson(_json);
      expect(peerState.blocksInFlight, '0x56');
      expect(peerState.lastUpdate, '0x16a95af332d');
    });

    test('toJson', () async {
      PeerState peerState = PeerState.fromJson(_json);
      var map = peerState.toJson();
      expect(map['blocks_in_flight'], '0x56');
      expect(map['last_updated'], '0x16a95af332d');
    });
  });
}
