import 'package:ckb_sdk_dart/src/core/utils/epoch_parser.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of epoch parse', () {
    setUp(() {});

    test('parseEpoch', () {
      var epochParams = parseEpoch('0x70800fd000058');
      expect(epochParams.number, 88);
      expect(epochParams.index, 253);
      expect(epochParams.length, 1800);
    });

    test('combineEpoch', () {
      var epoch = combineEpoch(1800, 253, 88);
      expect(epoch, '0x70800fd000058');
    });

    test('epochSince', () {
      var epoch = epochSince(1800, 253, 88);
      expect(epoch, '0x20070800fd000058');
    });
  });
}
