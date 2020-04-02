import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/cell_output_with_out_point.dart';
import 'package:test/test.dart';

void main() {
  var _cellOutput;
  group('A group tests of cell output with out point', () {
    setUp(() {
      _cellOutput = '''{
        "block_hash": "0x03935a4b5e3c03a9c1deb93a39183a9a116c16cff3dc9ab129e847487da0e2b8",
        "capacity": "0x1d1a94a200",
        "lock": {
            "args": "0x",
            "code_hash": "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5",
            "hash_type": "data"
        },
        "out_point": {
            "index": "0x0",
            "tx_hash": "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17"
        }
      }''';
    });

    test('fromJson', () async {
      var cellOutput = CellOutputWithOutPoint.fromJson(jsonDecode(_cellOutput));
      expect(cellOutput.lock.codeHash, '0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5');
      expect(cellOutput.blockHash, '0x03935a4b5e3c03a9c1deb93a39183a9a116c16cff3dc9ab129e847487da0e2b8');
      expect(cellOutput.outPoint.txHash, '0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17');
    });

    test('toJson', () async {
      var cellOutput = CellOutputWithOutPoint.fromJson(jsonDecode(_cellOutput));
      expect(cellOutput.toJson(),
          '{"block_hash":"0x03935a4b5e3c03a9c1deb93a39183a9a116c16cff3dc9ab129e847487da0e2b8","capacity":"0x1d1a94a200","lock":"{\\"code_hash\\":\\"0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5\\",\\"args\\":\\"0x\\",\\"hash_type\\":\\"data\\"}","out_point":"{\\"tx_hash\\":\\"0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17\\",\\"index\\":\\"0x0\\"}"}');
    });
  });
}
