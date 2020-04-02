import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/banned_address.dart';
import 'package:test/test.dart';

void main() {
  var _bannedAddress;
  group('A group tests of banned address', () {
    setUp(() {
      _bannedAddress = '''{
        "address": "192.168.0.2/32",
        "ban_reason": "",
        "ban_until": "0x1ac89236180",
        "created_at": "0x16bde533338"
      }''';
    });

    test('fromJson', () async {
      var bannedAddress = BannedAddress.fromJson(jsonDecode(_bannedAddress));
      expect(bannedAddress.address, '192.168.0.2/32');
      expect(bannedAddress.banUntil, '0x1ac89236180');
    });

    test('toJson', () async {
      var bannedAddress = BannedAddress.fromJson(jsonDecode(_bannedAddress));
      expect(bannedAddress.toJson(),
          '{"address":"192.168.0.2/32","ban_reason":"","ban_until":"0x1ac89236180","create_at":null}');
    });
  });
}
