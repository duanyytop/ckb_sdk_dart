import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/blockchain_info.dart';
import 'package:test/test.dart';

void main() {
  String _blockchainInfo;
  group('A group tests of blockchain info', () {
    setUp(() {
      _blockchainInfo = '''{
        "alerts": [
            {
                "id": "0x2a",
                "message": "An example alert message!",
                "notice_until": "0x24bcca57c00",
                "priority": "0x1"
            }
        ],
        "chain": "main",
        "difficulty": "0x7a1200",
        "epoch": "0x7080018000001",
        "is_initial_block_download": true,
        "median_time": "0x5cd2b105"
      }''';
    });

    test('fromJson', () async {
      var blockchainInfo = BlockchainInfo.fromJson(jsonDecode(_blockchainInfo));
      expect(blockchainInfo.difficulty, '0x7a1200');
      expect(blockchainInfo.alerts[0].message, 'An example alert message!');
    });

    test('toJson', () async {
      var blockchainInfo = BlockchainInfo.fromJson(jsonDecode(_blockchainInfo));
      var json = blockchainInfo.toJson();
      expect(json,
          '{"is_initial_block_download":true,"epoch":"0x7080018000001","difficulty":"0x7a1200","median_time":"0x5cd2b105","chain":"main","alerts":["{\\"id\\":\\"0x2a\\",\\"priority\\":\\"0x1\\",\\"notice_until\\":\\"0x24bcca57c00\\",\\"message\\":\\"An example alert message!\\"}"]}');
    });
  });
}
