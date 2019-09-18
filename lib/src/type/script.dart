import 'package:ckb_sdk_dart/ckb_crypto.dart';
import 'package:ckb_sdk_dart/src/type/utils/serializer.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

class Script {
  static const String data = 'data';
  static const String type = 'type';

  String codeHash;
  List<String> args;
  String hashType;

  Script({this.codeHash, this.args, this.hashType = data});

  factory Script.fromJson(Map<String, dynamic> json) {
    return json == null
        ? null
        : Script(
            codeHash: json['code_hash'],
            args: List<String>.from(json['args']),
            hashType: json['hash_type']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code_hash': codeHash,
      'args': args,
      'hash_type': hashType
    };
  }

  String computeHash() {
    Blake2b blake2b = Blake2b();
    blake2b.update(Serializer.serializeScript(this).toBytes());
    return appendHexPrefix(blake2b.doFinalString());
  }
}
