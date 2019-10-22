import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/type/transaction.dart';
import 'package:ckb_sdk_dart/src/type/utils/calculator.dart';
import 'package:test/test.dart';

void main() {
  Transaction tx;
  group('A group tests of calculator', () {
    setUp(() {
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

      tx = Transaction(
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
    });

    test('calculateSerializedSizeInBlock', () async {
      expect(calculateSerializedSizeInBlock(tx), 386);
    });

    test('calculateTransactionFee', () async {
      expect(calculateTransactionFee(BigInt.from(1035), BigInt.from(900)), BigInt.from(932));
      expect(calculateTransactionFee(BigInt.from(900), BigInt.from(900)), BigInt.from(810));
    });
  });
}
