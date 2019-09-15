import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/rpc/api.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of Transaction', () {
    setUp(() {});

    test('Transaction hash', () async {
      Api api = Api('http://localhost:8114');
      Block block = await api.getBlockByNumber("0x0");
      Transaction transaction = block.transactions[0];
      String txHash = await api.computeTransactionHash(transaction);
      expect(transaction.computeHash(), txHash);
    });

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
                args: ["0x36c329ed630d6ce750712a477543672adab57f4c"]))
      ];

      List<Witness> witnesses = [
        Witness(data: [
          "0x4107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb"
        ]),
        Witness(data: [])
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
        "0x68a57373f4e98aecfb9501ec1cc4a78c048361332e4b6706bdc1469d30bd52ea42feca657dd1de1eff384e6ed24a6910b011d49d855bd1ed209f5ce77d8116ac01",
        "0x4107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb"
      ];
      expect(signedTx.witnesses[0].data, expectedData);

      expectedData = [
        "0x3b13c362f254e7becb0e731e4756e742bfddbf2f5d7c16cd609ba127d2b7e07f1d588c3a7132fc20c478e2de14f6370fbb9e4402d240e4b32c8d671177e1f31101"
      ];
      expect(signedTx.witnesses[1].data, expectedData);
    });
  });
}
