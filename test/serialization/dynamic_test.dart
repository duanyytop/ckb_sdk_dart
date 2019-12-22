import 'package:ckb_sdk_dart/src/serialization/base/serialize_type.dart';
import 'package:ckb_sdk_dart/src/serialization/dynamic/bytes.dart';
import 'package:ckb_sdk_dart/src/serialization/dynamic/dynamic.dart';
import 'package:ckb_sdk_dart/src/serialization/dynamic/table.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/byte1.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/byte32.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/empty.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/uint64.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  group('A group tests of Struct serialization', () {
    Dynamic _dynamic;
    setUp(() {
      var types = <SerializeType>[]
        ..add(Byte32.fromHex(
            '68d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88'))
        ..add(Byte1.fromHex('01'))
        ..add(Dynamic(<Bytes>[]
          ..add(Bytes.fromHex('0xb2e61ff569acf041b3c2c17724e2379c581eeac3'))));

      var table = Table(<SerializeType>[]
        ..add(UInt64(BigInt.from(125000000000)))
        ..add(Table(types))
        ..add(Empty()));

      _dynamic = Dynamic(<SerializeType>[table]);
    });

    test('Dynamic', () {
      expect(
          _dynamic.toBytes(),
          hexToList(
              '71000000080000006900000010000000180000006900000000a2941a1d0000005100000010000000300000003100000068d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e8801200000000800000014000000b2e61ff569acf041b3c2c17724e2379c581eeac3'));
    });

    test('Dynamic length', () {
      expect(_dynamic.getLength(), 113);
    });

    test('Dynamic getValue', () {
      expect(_dynamic.getValue().runtimeType.toString(),
          'List<SerializeType<dynamic>>');
    });
  });
}
