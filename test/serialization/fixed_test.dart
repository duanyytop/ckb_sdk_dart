import 'package:ckb_sdk_dart/src/serialization/base/fixed_type.dart';
import 'package:ckb_sdk_dart/src/serialization/base/serialize_type.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/byte32.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/fixed.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/struct.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/uint32.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/uint64.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of Fixed serialization', () {
    Fixed _fixed;

    setUp(() {
      var byte32 = Byte32.fromHex(
          '0x0000000000000000000000000000000000000000000000000000000000000000');
      var index = UInt32(4294967295);
      var since = UInt64(BigInt.from(1));
      var input = Struct(<SerializeType>[
        since,
        Struct(<SerializeType>[byte32, index])
      ]);
      _fixed = Fixed(<FixedType>[input]);
    });

    test('Fixed', () {
      expect(
          _fixed.toBytes(),
          hexToList(
              '0100000001000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff'));
    });

    test('Fixed length', () {
      expect(_fixed.getLength(), 48);
    });

    test('Fixed getValue', () {
      expect(
          _fixed.getValue().runtimeType.toString(), 'List<FixedType<dynamic>>');
    });
  });
}
