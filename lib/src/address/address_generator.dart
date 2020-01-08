import 'package:bip_bech32/bip_bech32.dart';
import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/address/address_type.dart';
import 'package:ckb_sdk_dart/src/address/address_utils.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

class AddressGenerator {
  static String generate(Network network, Script script) {
    if (Script.Type == script.hashType &&
        cleanHexPrefix(script.args).length == 40) {
      if (SECP_BLAKE160_CODE_HASH == cleanHexPrefix(script.codeHash)) {
        // Payload: type(01) | code hash index(00, P2PH) | args
        var payload =
            TYPE_SHORT + CODE_HASH_IDX_BLAKE160 + cleanHexPrefix(script.args);
        var data = hexToList(payload);
        var bech32codec = Bech32Codec();
        return bech32codec
            .encode(Bech32(prefix(network), convertBits(data, 8, 5, true)));
      } else {
        if (MULTISIG_CODE_HASH == cleanHexPrefix(script.codeHash)) {
          // Payload: type(01) | code hash index(01, multi-sig) | args
          var payload =
              TYPE_SHORT + CODE_HASH_IDX_MULTISIG + cleanHexPrefix(script.args);
          var data = hexToList(payload);
          var bech32codec = Bech32Codec();
          return bech32codec
              .encode(Bech32(prefix(network), convertBits(data, 8, 5, true)));
        }
        return generateFullAddress(network, script);
      }
    }
    return generateFullAddress(network, script);
  }

  static String generateFullAddress(Network network, Script script) {
    var type = Script.Type == script.hashType ? TYPE_FULL_TYPE : TYPE_FULL_DATA;
    // Payload: type(02/04) | code hash | args
    var payload =
        type + cleanHexPrefix(script.codeHash) + cleanHexPrefix(script.args);
    var data = hexToList(payload);
    var bech32codec = Bech32Codec();
    return bech32codec
        .encode(Bech32(prefix(network), convertBits(data, 8, 5, true)));
  }

  static String prefix(Network network) {
    return network == Network.MAINNET ? 'ckb' : 'ckt';
  }
}
