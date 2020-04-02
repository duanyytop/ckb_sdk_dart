import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/alert_message.dart';
import 'package:test/test.dart';

void main() {
  var _alert;
  group('A group tests of alert message', () {
    setUp(() {
      _alert = '''{
        "id": "0x2a",
        "message": "An example alert message!",
        "notice_until": "0x24bcca57c00",
        "priority": "0x1"
      }''';
    });

    test('fromJson', () async {
      var alertMessage = AlertMessage.fromJson(jsonDecode(_alert));
      expect(alertMessage.message, 'An example alert message!');
    });

    test('toJson', () async {
      var alertMessage = AlertMessage.fromJson(jsonDecode(_alert));
      expect(alertMessage.toJson(),
          '{"id":"0x2a","priority":"0x1","notice_until":"0x24bcca57c00","message":"An example alert message!"}');
    });
  });
}
