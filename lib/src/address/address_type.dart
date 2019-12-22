import 'package:ckb_sdk_dart/ckb_core.dart';

class AddressParseResult {
  Network network;
  Script script;
  AddressFormatType type;

  AddressParseResult(this.network, this.script, this.type);
}

enum AddressFormatType {
  SHORT,
  FULL
}

enum Network {
  MAINNET,
  TESTNET
}

enum CodeHashType {
  BLAKE160,
  MULTISIG
}
