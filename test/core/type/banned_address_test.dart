import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/banned_address.dart';
import 'package:test/test.dart';

void main() {
  dynamic _json;
  group('A group tests of banned address', () {
    setUp(() {
      String bannedAddress = '''{
        "address": "192.168.0.2/32",
        "ban_reason": "",
        "ban_until": "0x1ac89236180",
        "created_at": "0x16bde533338"
      }''';
      _json = jsonDecode(bannedAddress);
    });

    test('fromJson', () async {
      BannedAddress bannedAddress = BannedAddress.fromJson(_json);
      expect(bannedAddress.address, '192.168.0.2/32');
      expect(bannedAddress.banUntil, '0x1ac89236180');
    });

    test('toJson', () async {
      BannedAddress bannedAddress = BannedAddress.fromJson(_json);
      var map = bannedAddress.toJson();
      expect(map['address'], '192.168.0.2/32');
      expect(map['ban_until'], '0x1ac89236180');
    });
  });
}
