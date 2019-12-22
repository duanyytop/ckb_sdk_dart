import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/alert_message.dart';
import 'package:test/test.dart';

void main() {
  dynamic _json;
  group('A group tests of alert message', () {
    setUp(() {
      var alert = '''{
        "id": "0x2a",
        "message": "An example alert message!",
        "notice_until": "0x24bcca57c00",
        "priority": "0x1"
      }''';
      _json = jsonDecode(alert);
    });

    test('fromJson', () async {
      var alertMessage = AlertMessage.fromJson(_json);
      expect(alertMessage.message, 'An example alert message!');
    });

    test('toJson', () async {
      var alertMessage = AlertMessage.fromJson(_json);
      var map = alertMessage.toJson();
      expect(map['message'], 'An example alert message!');
      expect(map['notice_until'], '0x24bcca57c00');
    });
  });
}
