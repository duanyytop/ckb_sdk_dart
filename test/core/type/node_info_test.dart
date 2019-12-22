import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/node_info.dart';
import 'package:test/test.dart';

void main() {
  dynamic _json;
  group('A group tests of node info', () {
    setUp(() {
      var nodeInfo = '''{
        "addresses": [
            {
                "address": "/ip4/192.168.0.2/tcp/8112/p2p/QmTRHCdrRtgUzYLNCin69zEvPvLYdxUZLLfLYyHVY3DZAS",
                "score": "0xff"
            },
            {
                "address": "/ip4/0.0.0.0/tcp/8112/p2p/QmTRHCdrRtgUzYLNCin69zEvPvLYdxUZLLfLYyHVY3DZAS",
                "score": "0x1"
            }
        ],
        "is_outbound": null,
        "node_id": "QmTRHCdrRtgUzYLNCin69zEvPvLYdxUZLLfLYyHVY3DZAS",
        "version": "0.0.0"
      }''';
      _json = jsonDecode(nodeInfo);
    });

    test('fromJson', () async {
      var nodeInfo = NodeInfo.fromJson(_json);
      expect(nodeInfo.nodeId, 'QmTRHCdrRtgUzYLNCin69zEvPvLYdxUZLLfLYyHVY3DZAS');
      expect(nodeInfo.addresses[0].address,
          '/ip4/192.168.0.2/tcp/8112/p2p/QmTRHCdrRtgUzYLNCin69zEvPvLYdxUZLLfLYyHVY3DZAS');
    });

    test('toJson', () async {
      var nodeInfo = NodeInfo.fromJson(_json);
      var map = nodeInfo.toJson();
      expect(map['node_id'], 'QmTRHCdrRtgUzYLNCin69zEvPvLYdxUZLLfLYyHVY3DZAS');
      expect((map['addresses'][0] as Address).address,
          '/ip4/192.168.0.2/tcp/8112/p2p/QmTRHCdrRtgUzYLNCin69zEvPvLYdxUZLLfLYyHVY3DZAS');
    });
  });
}
