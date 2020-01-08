import 'package:bip_bech32/bip_bech32.dart';
import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/address/address_utils.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

import 'address_type.dart';

class AddressParser {
  static String _parsePayload(String address) {
    var bech32codec = Bech32Codec();
    var parsed = bech32codec.decode(address);
    var data = convertBits(parsed.data, 5, 8, false);
    if (data.isEmpty) return null;
    var bech32 = Bech32(parsed.hrp, data);
    return listToHexNoPrefix(bech32.data);
  }

  static AddressParseResult parse(String address) {
    var payload = _parsePayload(address);
    if (payload == null) {
      throw Exception('Address bech32 decode fail');
    }
    var type = payload.substring(0, 2);
    if (TYPE_SHORT == type) {
      var codeHashIndex = payload.substring(2, 4);
      var args = appendHexPrefix(payload.substring(4));
      if (cleanHexPrefix(args).length / 2 != 20) {
        throw Exception('Short address args byte length must be equal to 20');
      }
      if (CODE_HASH_IDX_BLAKE160 == codeHashIndex) {
        return AddressParseResult(
            parseNetwork(address),
            Script(
                codeHash: appendHexPrefix(SECP_BLAKE160_CODE_HASH),
                args: args,
                hashType: Script.Type),
            AddressFormatType.SHORT);
      } else if (CODE_HASH_IDX_MULTISIG == codeHashIndex) {
        return AddressParseResult(
            parseNetwork(address),
            Script(
                codeHash: appendHexPrefix(MULTISIG_CODE_HASH),
                args: args,
                hashType: Script.Type),
            AddressFormatType.SHORT);
      } else {
        throw Exception('Short address code hash index must be 00 or 01');
      }
    }

    var codeHash = appendHexPrefix(payload.substring(2, 66));
    var args = appendHexPrefix(payload.substring(66));
    if (TYPE_FULL_DATA == type) {
      return AddressParseResult(
          parseNetwork(address),
          Script(codeHash: codeHash, args: args, hashType: Script.Data),
          AddressFormatType.FULL);
    } else if (TYPE_FULL_TYPE == type) {
      return AddressParseResult(
          parseNetwork(address),
          Script(codeHash: codeHash, args: args, hashType: Script.Type),
          AddressFormatType.FULL);
    }
    throw Exception('Full address type must be 02 or 04');
  }

  static Network parseNetwork(String address) {
    if (address.startsWith('ckb')) {
      return Network.MAINNET;
    } else if (address.startsWith('ckt')) {
      return Network.TESTNET;
    }
    throw Exception('Address prefix should be ckb or ckt');
  }
}
