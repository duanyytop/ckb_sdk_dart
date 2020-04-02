import 'dart:convert';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/core/rpc/api.dart';
import 'package:ckb_sdk_dart/src/core/type/witness.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of Transaction', () {
    var _transaction;
    setUp(() {
      _transaction = '''{
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
      }''';
    });

    test('Transaction hash', () async {
      var api = Api('http://localhost:8114');
      var block = await api.getBlockByNumber('0x0');
      var transaction = block.transactions[1];
      var txHash = await api.computeTransactionHash(transaction);
      expect(transaction.computeHash(), txHash);
    }, skip: 'Skip rpc test');

    test('Transaction signature', () async {
      var cellInputs = [
        CellInput(
            previousOutput:
                OutPoint(txHash: '0x91fcfd61f420c1090aeded6b6d91d5920a279fe53ec34353afccc59264eeddd4', index: '0x0'),
            since: '113'),
        CellInput(
            previousOutput:
                OutPoint(txHash: '0x00000000000000000000000000004e4552564f5344414f494e50555430303031', index: '0x0'),
            since: '0x0')
      ];

      var cellOutputs = [
        CellOutput(
            capacity: '10000009045634',
            lock: Script(
                codeHash: '0xf1951123466e4479842387a66fabfd6b65fc87fd84ae8e6cd3053edb27fff2fd',
                args: '0x36c329ed630d6ce750712a477543672adab57f4c'))
      ];

      var witnesses = [
        Witness(lock: '0x4107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb'),
      ];

      var tx = Transaction(
          version: '0x0',
          cellDeps: [
            CellDep(
                outPoint: OutPoint(
                    txHash: '0xbffab7ee0a050e2cb882de066d3dbf3afdd8932d6a26eda44f06e4b23f0f4b5a', index: '0x1'),
                depType: CellDep.DepGroup)
          ],
          headerDeps: ['0x'],
          inputs: cellInputs,
          outputs: cellOutputs,
          outputsData: ['0x'],
          witnesses: witnesses);

      var privateKey = '0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3';
      var signedTx = tx.sign(privateKey);

      var expectedData = [
        '0x55000000100000005500000055000000410000008fa85765b9cc4233f4103f6fcc59204f6d90f5caea770e5d75d3ce15446b6b164001f73c86420ee22f8d0d8c5020f53330add722894464b5ba5a2b708d18633d00',
      ];
      expect(signedTx.witnesses, expectedData);
    });

    test('fromJson', () async {
      var transaction = Transaction.fromJson(jsonDecode(_transaction));
      expect(transaction.cellDeps[0].outPoint.txHash,
          '0x29f94532fb6c7a17f13bcde5adb6e2921776ee6f357adf645e5393bd13442141');
      expect(
          transaction.outputs[0].lock.codeHash, '0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5');
    });

    test('toJson', () async {
      var transaction = Transaction.fromJson(jsonDecode(_transaction));
      expect(transaction.toJson(),
          '{"version":"0x0","hash":"0xba86cc2cb21832bf4a84c032eb6e8dc422385cc8f8efb84eb0bc5fe0b0b9aece","cell_deps":["{\\"out_point\\":\\"{\\\\\\"tx_hash\\\\\\":\\\\\\"0x29f94532fb6c7a17f13bcde5adb6e2921776ee6f357adf645e5393bd13442141\\\\\\",\\\\\\"index\\\\\\":\\\\\\"0x0\\\\\\"}\\",\\"dep_type\\":\\"code\\"}"],"header_deps":["0x8033e126475d197f2366bbc2f30b907d15af85c9d9533253c6f0787dcbbb509e"],"inputs":["{\\"previous_output\\":\\"{\\\\\\"tx_hash\\\\\\":\\\\\\"0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17\\\\\\",\\\\\\"index\\\\\\":\\\\\\"0x0\\\\\\"}\\",\\"since\\":\\"0x0\\"}"],"outputs":["{\\"capacity\\":\\"0x174876e800\\",\\"lock\\":\\"{\\\\\\"code_hash\\\\\\":\\\\\\"0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5\\\\\\",\\\\\\"args\\\\\\":\\\\\\"0x\\\\\\",\\\\\\"hash_type\\\\\\":\\\\\\"data\\\\\\"}\\",\\"type\\":null}"],"outputs_data":["0x"],"witnesses":[]}');
    });
  });
}
