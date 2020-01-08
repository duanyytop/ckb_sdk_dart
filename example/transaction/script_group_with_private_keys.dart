import 'package:ckb_sdk_dart/src/core/transaction/script_group.dart';

class ScriptGroupWithPrivateKeys {
  ScriptGroup scriptGroup;
  List<String> privateKeys;

  ScriptGroupWithPrivateKeys(this.scriptGroup, this.privateKeys);
}
