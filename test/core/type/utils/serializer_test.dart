import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/core/type/utils/serializer.dart';
import 'package:test/test.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

void main() {
  Transaction tx;
  group('A group tests of calculator', () {
    setUp(() {
      List<CellInput> cellInputs = [
        CellInput(
            previousOutput: OutPoint(
                txHash:
                    "0x91fcfd61f420c1090aeded6b6d91d5920a279fe53ec34353afccc59264eeddd4",
                index: "0"),
            since: "113"),
        CellInput(
            previousOutput: OutPoint(
                txHash:
                    "0x00000000000000000000000000004e4552564f5344414f494e50555430303031",
                index: "0"),
            since: "0")
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
          version: "0",
          cellDeps: [
            CellDep(
                outPoint: OutPoint(
                    txHash:
                        "0xbffab7ee0a050e2cb882de066d3dbf3afdd8932d6a26eda44f06e4b23f0f4b5a",
                    index: "1"),
                depType: CellDep.depGroup)
          ],
          headerDeps: ["0x"],
          inputs: cellInputs,
          outputs: cellOutputs,
          outputsData: ["0x", "0x"],
          witnesses: witnesses);
    });

    test('serializeOutPoint', () async {
      expect(listToHex(Serializer.serializeOutPoint(tx.inputs[0].previousOutput).toBytes()), '0x91fcfd61f420c1090aeded6b6d91d5920a279fe53ec34353afccc59264eeddd400000000');
    });

    test('serializeScript', () async {
      expect(listToHex(Serializer.serializeScript(tx.outputs[0].lock).toBytes()), '0x49000000100000003000000031000000f1951123466e4479842387a66fabfd6b65fc87fd84ae8e6cd3053edb27fff2fd001400000036c329ed630d6ce750712a477543672adab57f4c');
    });

    test('serializeCellInput', () async {
      expect(listToHex(Serializer.serializeCellInput(tx.inputs[0]).toBytes()), '0x130100000000000091fcfd61f420c1090aeded6b6d91d5920a279fe53ec34353afccc59264eeddd400000000');
    });

    test('serializeCellOutput', () async {
      expect(listToHex(Serializer.serializeCellOutput(tx.outputs[0]).toBytes()), '0x61000000100000001800000061000000345604090000100049000000100000003000000031000000f1951123466e4479842387a66fabfd6b65fc87fd84ae8e6cd3053edb27fff2fd001400000036c329ed630d6ce750712a477543672adab57f4c');
    });

    test('serializeCellDep', () async {
      expect(listToHex(Serializer.serializeCellDep(tx.cellDeps[0]).toBytes()), '0xbffab7ee0a050e2cb882de066d3dbf3afdd8932d6a26eda44f06e4b23f0f4b5a0100000001');
    });

    test('serializeCellDeps', () async {
      expect(listToHex(Serializer.serializeCellDeps(tx.cellDeps).toBytes()), '0x01000000bffab7ee0a050e2cb882de066d3dbf3afdd8932d6a26eda44f06e4b23f0f4b5a0100000001');
    });

    test('serializeCellInputs', () async {
      expect(listToHex(Serializer.serializeCellInputs(tx.inputs).toBytes()), '0x02000000130100000000000091fcfd61f420c1090aeded6b6d91d5920a279fe53ec34353afccc59264eeddd400000000000000000000000000000000000000000000000000004e4552564f5344414f494e5055543030303100000000');
    });

    test('serializeCellDeps', () async {
      expect(listToHex(Serializer.serializeCellDeps(tx.cellDeps).toBytes()), '0x01000000bffab7ee0a050e2cb882de066d3dbf3afdd8932d6a26eda44f06e4b23f0f4b5a0100000001');
    });

    test('serializeCellOutputs', () async {
      expect(listToHex(Serializer.serializeCellOutputs(tx.outputs).toBytes()), '0x690000000800000061000000100000001800000061000000345604090000100049000000100000003000000031000000f1951123466e4479842387a66fabfd6b65fc87fd84ae8e6cd3053edb27fff2fd001400000036c329ed630d6ce750712a477543672adab57f4c');
    });

    test('serializeBytes', () async {
      expect(listToHex(Serializer.serializeBytes(tx.outputsData).toBytes()), '0x140000000c000000100000000000000000000000');
    });

    test('serializeByte32', () async {
      expect(listToHex(Serializer.serializeByte32(tx.headerDeps).toBytes()), '0x010000000000000000000000000000000000000000000000000000000000000000000000');
    });

    test('serializeRawTransaction', () async {
      expect(listToHex(Serializer.serializeRawTransaction(tx).toBytes()), '0x460100001c00000020000000490000006d000000c9000000320100000000000001000000bffab7ee0a050e2cb882de066d3dbf3afdd8932d6a26eda44f06e4b23f0f4b5a010000000101000000000000000000000000000000000000000000000000000000000000000000000002000000710000000000000091fcfd61f420c1090aeded6b6d91d5920a279fe53ec34353afccc59264eeddd400000000000000000000000000000000000000000000000000004e4552564f5344414f494e505554303030310000000069000000080000006100000010000000180000006100000082a6fc4e1809000049000000100000003000000031000000f1951123466e4479842387a66fabfd6b65fc87fd84ae8e6cd3053edb27fff2fd001400000036c329ed630d6ce750712a477543672adab57f4c140000000c000000100000000000000000000000');
    });

    test('serializeTransaction', () async {
      expect(listToHex(Serializer.serializeTransaction(tx).toBytes()), '0x860100000c00000052010000460100001c00000020000000490000006d000000c9000000320100000000000001000000bffab7ee0a050e2cb882de066d3dbf3afdd8932d6a26eda44f06e4b23f0f4b5a010000000101000000000000000000000000000000000000000000000000000000000000000000000002000000710000000000000091fcfd61f420c1090aeded6b6d91d5920a279fe53ec34353afccc59264eeddd400000000000000000000000000000000000000000000000000004e4552564f5344414f494e505554303030310000000069000000080000006100000010000000180000006100000082a6fc4e1809000049000000100000003000000031000000f1951123466e4479842387a66fabfd6b65fc87fd84ae8e6cd3053edb27fff2fd001400000036c329ed630d6ce750712a477543672adab57f4c140000000c000000100000000000000000000000340000000c00000030000000200000004107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb00000000');
    });
  });
}
