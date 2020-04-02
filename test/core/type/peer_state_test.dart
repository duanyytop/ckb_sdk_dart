import 'dart:convert';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:test/test.dart';

void main() {
  var _peerState;
  group('A group tests of peer state', () {
    setUp(() {
      _peerState = '''{
        "blocks_in_flight": "0x56",
        "last_updated": "0x16a95af332d",
        "peer": "0x1"
      }''';
    });

    test('fromJson', () async {
      var peerState = PeerState.fromJson(jsonDecode(_peerState));
      expect(peerState.blocksInFlight, '0x56');
      expect(peerState.lastUpdate, '0x16a95af332d');
    });

    test('toJson', () async {
      var peerState = PeerState.fromJson(jsonDecode(_peerState));
      expect(peerState.toJson(), '{"last_updated":"0x16a95af332d","blocks_in_flight":"0x56","peer":"0x1"}');
    });
  });
}
