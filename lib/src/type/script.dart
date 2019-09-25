import '../../ckb_crypto.dart';
import '../utils/utils.dart';
import 'utils/serializer.dart';

class Script {
  static const String data = 'data';
  static const String type = 'type';

  String codeHash;
  List<String> args;
  String hashType;

  Script({this.codeHash, this.args, this.hashType = data});

  factory Script.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Script(
        codeHash: json['code_hash'],
        args: (json['args'] as List).map((arg) => arg.toString())?.toList(),
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
    int byteSize = 1;
    byteSize += codeHash == null ? 0 : hexToList(codeHash).length;
    if (args == null || args.isEmpty) {
      return byteSize;
    }
    byteSize += args?.fold(
        0, (previous, element) => previous + hexToList(element).length);
    return byteSize;
  }

  String computeHash() {
    Blake2b blake2b = Blake2b();
    blake2b.update(Serializer.serializeScript(this).toBytes());
    return appendHexPrefix(blake2b.doFinalString());
  }
}
