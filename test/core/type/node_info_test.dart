import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/node_info.dart';
import 'package:test/test.dart';

void main() {
  var _nodeInfo;
  group('A group tests of node info', () {
    setUp(() {
      _nodeInfo = '''{
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
    });

    test('fromJson', () async {
      var nodeInfo = NodeInfo.fromJson(jsonDecode(_nodeInfo));
      expect(nodeInfo.nodeId, 'QmTRHCdrRtgUzYLNCin69zEvPvLYdxUZLLfLYyHVY3DZAS');
      expect(nodeInfo.addresses[0].address,
          '/ip4/192.168.0.2/tcp/8112/p2p/QmTRHCdrRtgUzYLNCin69zEvPvLYdxUZLLfLYyHVY3DZAS');
    });

    test('toJson', () async {
      var nodeInfo = NodeInfo.fromJson(jsonDecode(_nodeInfo));
      expect(nodeInfo.toJson(),
          '{"addresses":["{\\"address\\":\\"/ip4/192.168.0.2/tcp/8112/p2p/QmTRHCdrRtgUzYLNCin69zEvPvLYdxUZLLfLYyHVY3DZAS\\",\\"score\\":\\"0xff\\"}","{\\"address\\":\\"/ip4/0.0.0.0/tcp/8112/p2p/QmTRHCdrRtgUzYLNCin69zEvPvLYdxUZLLfLYyHVY3DZAS\\",\\"score\\":\\"0x1\\"}"],"node_id":"QmTRHCdrRtgUzYLNCin69zEvPvLYdxUZLLfLYyHVY3DZAS","version":"0.0.0"}');
    });
  });
}
