import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/core/type/transaction.dart';
import 'package:ckb_sdk_dart/src/core/utils/convert.dart';
import 'package:test/test.dart';

void main() {
  Transaction tx;
  group('A group tests of calculator', () {
    setUp(() {
      var cellInputs = [
        CellInput(
            previousOutput: OutPoint(
                txHash:
                    '0x91fcfd61f420c1090aeded6b6d91d5920a279fe53ec34353afccc59264eeddd4',
                index: '0'),
            since: '113'),
        CellInput(
            previousOutput: OutPoint(
                txHash:
                    '0x00000000000000000000000000004e4552564f5344414f494e50555430303031',
                index: '0'),
            since: '0')
      ];

      var cellOutputs = [
        CellOutput(
            capacity: '10000009045634',
            lock: Script(
                codeHash:
                    '0xf1951123466e4479842387a66fabfd6b65fc87fd84ae8e6cd3053edb27fff2fd',
                args: '0x36c329ed630d6ce750712a477543672adab57f4c'))
      ];

      var witnesses = [
        '0x4107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb',
        '0x'
      ];

      tx = Transaction(
          version: '0',
          cellDeps: [
            CellDep(
                outPoint: OutPoint(
                    txHash:
                        '0xbffab7ee0a050e2cb882de066d3dbf3afdd8932d6a26eda44f06e4b23f0f4b5a',
                    index: '1'),
                depType: CellDep.DepGroup)
          ],
          headerDeps: ['0x'],
          inputs: cellInputs,
          outputs: cellOutputs,
          outputsData: ['0x'],
          witnesses: witnesses);
    });

    test('calculateSerializedSizeInBlock', () async {
      expect(Convert.parseOutPoint(tx.inputs[0].previousOutput).index, '0x0');
    });

    test('calculateTransactionFee', () async {
      var transaction = Convert.parseTransaction(tx);
      expect(transaction.cellDeps[0].outPoint.index, '0x1');
      expect(transaction.inputs[0].since, '0x71');
      expect(transaction.outputs[0].capacity, '0x9184efca682');
    });
  });
}
