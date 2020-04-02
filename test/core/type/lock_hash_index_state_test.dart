import 'dart:convert';

import 'package:ckb_sdk_dart/src/core/type/lock_hash_index_state.dart';
import 'package:test/test.dart';

void main() {
  var _liveCell;
  group('A group tests of lock hash index state', () {
    setUp(() {
      _liveCell = '''{
        "block_hash": "0xc73a331428dd9ef69b8073c248bfae9dc7c27942bb1cb70581e880bd3020d7da",
        "block_number": "0x400",
        "lock_hash": "0xd8753dd87c7dd293d9b64d4ca20d77bb8e5f2d92bf08234b026e2d8b1b00e7e9"
      }''';
    });

    test('fromJson', () async {
      var lockHashIndexState = LockHashIndexState.fromJson(jsonDecode(_liveCell));
      expect(lockHashIndexState.blockHash, '0xc73a331428dd9ef69b8073c248bfae9dc7c27942bb1cb70581e880bd3020d7da');
      expect(lockHashIndexState.lockHash, '0xd8753dd87c7dd293d9b64d4ca20d77bb8e5f2d92bf08234b026e2d8b1b00e7e9');
    });

    test('toJson', () async {
      var lockHashIndexState = LockHashIndexState.fromJson(jsonDecode(_liveCell));
      var map = lockHashIndexState.toJson();
      expect(lockHashIndexState.toJson(),
          '{"block_hash":"0xc73a331428dd9ef69b8073c248bfae9dc7c27942bb1cb70581e880bd3020d7da","block_number":"0x400","lock_hash":"0xd8753dd87c7dd293d9b64d4ca20d77bb8e5f2d92bf08234b026e2d8b1b00e7e9"}');
    });
  });
}
