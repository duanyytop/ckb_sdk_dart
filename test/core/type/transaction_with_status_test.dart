import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/transaction_with_status.dart';
import 'package:test/test.dart';

void main() {
  var _transactionWithStatus;
  group('A group tests of transaction with status', () {
    setUp(() {
      _transactionWithStatus = '''{
        "transaction": {
            "cell_deps": [
                {
                    "dep_type": "code",
                    "out_point": {
                        "index": "0x0",
                        "tx_hash": "0x29f94532fb6c7a17f13bcde5adb6e2921776ee6f357adf645e5393bd13442141"
                    }
                }
            ],
            "hash": "0xba86cc2cb21832bf4a84c032eb6e8dc422385cc8f8efb84eb0bc5fe0b0b9aece",
            "header_deps": [
                "0x8033e126475d197f2366bbc2f30b907d15af85c9d9533253c6f0787dcbbb509e"
            ],
            "inputs": [
                {
                    "previous_output": {
                        "index": "0x0",
                        "tx_hash": "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17"
                    },
                    "since": "0x0"
                }
            ],
            "outputs": [
                {
                    "capacity": "0x174876e800",
                    "lock": {
                        "args": "0x",
                        "code_hash": "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5",
                        "hash_type": "data"
                    },
                    "type": null
                }
            ],
            "outputs_data": [
                "0x"
            ],
            "version": "0x0",
            "witnesses": []
        },
        "tx_status": {
            "block_hash": null,
            "status": "pending"
        }
      }''';
    });

    test('fromJson', () async {
      var transactionWithStatus = TransactionWithStatus.fromJson(jsonDecode(_transactionWithStatus));
      expect(transactionWithStatus.transaction.inputs[0].previousOutput.txHash,
          '0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17');
      expect(transactionWithStatus.txStatus.status, 'pending');
    });

    test('toJson', () async {
      var transactionWithStatus = TransactionWithStatus.fromJson(jsonDecode(_transactionWithStatus));
      expect(transactionWithStatus.toJson(),
          '{"tx_status":"{\\"status\\":\\"pending\\",\\"block_hash\\":null}","transaction":"{\\"version\\":\\"0x0\\",\\"hash\\":\\"0xba86cc2cb21832bf4a84c032eb6e8dc422385cc8f8efb84eb0bc5fe0b0b9aece\\",\\"cell_deps\\":[\\"{\\\\\\"out_point\\\\\\":\\\\\\"{\\\\\\\\\\\\\\"tx_hash\\\\\\\\\\\\\\":\\\\\\\\\\\\\\"0x29f94532fb6c7a17f13bcde5adb6e2921776ee6f357adf645e5393bd13442141\\\\\\\\\\\\\\",\\\\\\\\\\\\\\"index\\\\\\\\\\\\\\":\\\\\\\\\\\\\\"0x0\\\\\\\\\\\\\\"}\\\\\\",\\\\\\"dep_type\\\\\\":\\\\\\"code\\\\\\"}\\"],\\"header_deps\\":[\\"0x8033e126475d197f2366bbc2f30b907d15af85c9d9533253c6f0787dcbbb509e\\"],\\"inputs\\":[\\"{\\\\\\"previous_output\\\\\\":\\\\\\"{\\\\\\\\\\\\\\"tx_hash\\\\\\\\\\\\\\":\\\\\\\\\\\\\\"0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17\\\\\\\\\\\\\\",\\\\\\\\\\\\\\"index\\\\\\\\\\\\\\":\\\\\\\\\\\\\\"0x0\\\\\\\\\\\\\\"}\\\\\\",\\\\\\"since\\\\\\":\\\\\\"0x0\\\\\\"}\\"],\\"outputs\\":[\\"{\\\\\\"capacity\\\\\\":\\\\\\"0x174876e800\\\\\\",\\\\\\"lock\\\\\\":\\\\\\"{\\\\\\\\\\\\\\"code_hash\\\\\\\\\\\\\\":\\\\\\\\\\\\\\"0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5\\\\\\\\\\\\\\",\\\\\\\\\\\\\\"args\\\\\\\\\\\\\\":\\\\\\\\\\\\\\"0x\\\\\\\\\\\\\\",\\\\\\\\\\\\\\"hash_type\\\\\\\\\\\\\\":\\\\\\\\\\\\\\"data\\\\\\\\\\\\\\"}\\\\\\",\\\\\\"type\\\\\\":null}\\"],\\"outputs_data\\":[\\"0x\\"],\\"witnesses\\":[]}"}');
    });
  });
}
