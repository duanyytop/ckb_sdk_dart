import 'dart:convert';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/core/rpc/api.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of Transaction', () {
    dynamic _json;
    setUp(() {
      String transaction = '''{
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
      _json = jsonDecode(transaction);
    });

    test('Transaction hash', () async {
      Api api = Api('http://localhost:8114');
      Block block = await api.getBlockByNumber("0x0");
      Transaction transaction = block.transactions[1];
      String txHash = await api.computeTransactionHash(transaction);
      expect(transaction.computeHash(), txHash);
    }, skip: 'Skip rpc test');

    test('Transaction signature', () async {
      List<CellInput> cellInputs = [
        CellInput(
            previousOutput: OutPoint(
                txHash:
                    "0x91fcfd61f420c1090aeded6b6d91d5920a279fe53ec34353afccc59264eeddd4",
                index: "0x0"),
            since: "113"),
        CellInput(
            previousOutput: OutPoint(
                txHash:
                    "0x00000000000000000000000000004e4552564f5344414f494e50555430303031",
                index: "0x0"),
            since: "0x0")
      ];

      List<CellOutput> cellOutputs = [
        CellOutput(
            capacity: "10000009045634",
            lock: Script(
                codeHash:
                    "0xf1951123466e4479842387a66fabfd6b65fc87fd84ae8e6cd3053edb27fff2fd",
                args: "0x36c329ed630d6ce750712a477543672adab57f4c"))
      ];

      List<String> witnesses = [
        "0x4107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb",
        "0x"
      ];

      Transaction tx = Transaction(
          version: "0x0",
          cellDeps: [
            CellDep(
                outPoint: OutPoint(
                    txHash:
                        "0xbffab7ee0a050e2cb882de066d3dbf3afdd8932d6a26eda44f06e4b23f0f4b5a",
                    index: "0x1"),
                depType: CellDep.depGroup)
          ],
          headerDeps: ["0x"],
          inputs: cellInputs,
          outputs: cellOutputs,
          outputsData: ["0x"],
          witnesses: witnesses);

      String privateKey =
          "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3";
      Transaction signedTx = tx.sign(privateKey);

      List<String> expectedData = [
        "0x8dbb53f6326240110e67c8f331140a615b37a67de5e6479fbdf4f9fb5789eaf946226a47a9c92c502b5f45b43717611a31f913f49b164846f510c92eeef69c76004107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb",
        "0x833210c0282ec82ce1064399547d536acaea28df17b691886c80701cb18230cf1d536aaaab6cc5e3faa5d949383cfd5c082fef37499e3d120d6144a9d5ad84d900"
      ];
      expect(signedTx.witnesses, expectedData);
    });

    test('fromJson', () async {
      Transaction transaction = Transaction.fromJson(_json);
      expect(transaction.cellDeps[0].outPoint.txHash,
          '0x29f94532fb6c7a17f13bcde5adb6e2921776ee6f357adf645e5393bd13442141');
      expect(transaction.outputs[0].lock.codeHash,
          '0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5');
    });

    test('toJson', () async {
      Transaction transaction = Transaction.fromJson(_json);
      var map = transaction.toJson();
      expect(map['cell_deps'][0]['out_point']['tx_hash'],
          '0x29f94532fb6c7a17f13bcde5adb6e2921776ee6f357adf645e5393bd13442141');
      expect(map['outputs'][0]['lock']['code_hash'],
          '0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5');
    });
  });
}
