import 'package:ckb_sdk_dart/ckb_crypto.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

import 'utils/serializer.dart';

class Script {
  static const String Data = 'data';
  static const String Type = 'type';

  String codeHash;
  String args;
  String hashType;

  Script({this.codeHash, this.args, this.hashType = Data});

  factory Script.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Script(
        codeHash: json['code_hash'],
        args: json['args'],
        hashType: json['hash_type']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code_hash': codeHash,
      'args': args,
      'hash_type': hashType
    };
  }

  int calculateByteSize() {
    var byteSize = 1;
    byteSize += codeHash == null ? 0 : hexToList(codeHash).length;
    if (args == null || args.isEmpty) {
      return byteSize;
    }
    byteSize += hexToList(args).length;
    return byteSize;
  }

  String computeHash() {
    var blake2b = Blake2b();
    blake2b.update(Serializer.serializeScript(this).toBytes());
    return appendHexPrefix(blake2b.doFinalString());
  }
}
