import 'dart:convert';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:test/test.dart';

void main() {
  dynamic _json;
  group('A group tests of live cell', () {
    setUp(() {
      String liveCell = '''{
        "cell_output": {
            "capacity": "0x1d1a94a200",
            "lock": {
                "args": "0x",
                "code_hash": "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5",
                "hash_type": "data"
            },
            "type": null
        },
        "created_by": {
            "block_number": "0x1",
            "index": "0x0",
            "tx_hash": "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17"
        }
      }''';
      _json = jsonDecode(liveCell);
    });

    test('fromJson', () async {
      LiveCell liveCell = LiveCell.fromJson(_json);
      expect(liveCell.cellOutput.lock.codeHash,
          '0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5');
      expect(liveCell.createdBy.txHash,
          '0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17');
    });

    test('toJson', () async {
      LiveCell liveCell = LiveCell.fromJson(_json);
      var map = liveCell.toJson();
      expect(map['cell_output']['lock']['code_hash'],
          '0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5');
      expect(map['created_by']['tx_hash'],
          '0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17');
    });
  });
}
