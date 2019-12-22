import 'package:ckb_sdk_dart/src/serialization/dynamic/bytes.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of Bytes serialization', () {
    setUp(() {});

    test('Bytes', () {
      var bytes = Bytes.fromHex('3954acece65096bfa81258983ddb83915fc56bd8');
      expect(bytes.toBytes(),
          hexToList('140000003954acece65096bfa81258983ddb83915fc56bd8'));
    });

    test('Bytes length', () {
      var bytes = Bytes.fromHex('3954acece65096bfa81258983ddb83915fc56bd8');
      expect(bytes.getLength(), 24);
    });

    test('Bytes getValue', () {
      var bytes = Bytes.fromHex('3954acece65096bfa81258983ddb83915fc56bd8');
      expect(bytes.getValue().runtimeType.toString(), 'Uint8List');
    });
  });
}
