import 'dart:convert';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:test/test.dart';

void main() {
  dynamic _json;
  group('A group tests of header', () {
    setUp(() {
      String header = '''{
        "dao": "0x0100000000000000005827f2ba13b000d77fa3d595aa00000061eb7ada030000",
        "compact_target": "0x7a1200",
        "epoch": "0x7080018000001",
        "hash": "0xc73a331428dd9ef69b8073c248bfae9dc7c27942bb1cb70581e880bd3020d7da",
        "nonce": "0x0",
        "number": "0x400",
        "parent_hash": "0x956315644ef52193db540709d3a34c7149cfb173e4eedcc64ee10aa366795439",
        "proposals_hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "timestamp": "0x5cd2b117",
        "transactions_root": "0x8ad0468383d0085e26d9c3b9b648623e4194efc53a03b7cd1a79e92700687f1e",
        "uncles_hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "version": "0x0"
      }''';
      _json = jsonDecode(header);
    });

    test('fromJson', () async {
      Header header = Header.fromJson(_json);
      expect(header.dao,
          '0x0100000000000000005827f2ba13b000d77fa3d595aa00000061eb7ada030000');
      expect(header.compactTarget, '0x7a1200');
    });

    test('toJson', () async {
      Header header = Header.fromJson(_json);
      var map = header.toJson();
      expect(map['dao'],
          '0x0100000000000000005827f2ba13b000d77fa3d595aa00000061eb7ada030000');
      expect(map['transactions_root'],
          '0x8ad0468383d0085e26d9c3b9b648623e4194efc53a03b7cd1a79e92700687f1e');
    });
  });
}
