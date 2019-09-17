import 'dart:typed_data';

import 'package:bip_bech32/bip_bech32.dart';
import 'package:ckb_sdk_dart/src/address/address_params.dart';
import 'package:ckb_sdk_dart/src/crypto/ripemd160.dart';
import 'package:ckb_sdk_dart/src/crypto/sha256.dart';

import '../crypto/blake2b.dart';
import '../utils/utils.dart';

class AddressGenerator {
  Network network;
  FormatType formatType;
  CodeHashIndex codeHashIndex;

  AddressGenerator(
      {this.network = Network.mainnet,
      this.formatType = FormatType.short,
      this.codeHashIndex = CodeHashIndex.blake160});

  String addressFromPublicKey(String publicKey) {
    if (codeHashIndex == CodeHashIndex.ripemd160) {
      return address(Ripemd160.hash(Sha256.hash(publicKey)));
    }
    return address(Blake2b.blake160(publicKey));
  }

  String address(String arg) {
    // Payload: type(01) | code hash index(00, P2PH) | arg (pubkey blake160)
    String payload = AddressParams.formatType(formatType) +
        AddressParams.codeHashIndex(codeHashIndex) +
        cleanHexPrefix(arg);
    Uint8List data = hexToList(payload);
    Bech32Codec bech32codec = Bech32Codec();
    String prefix = AddressParams.network(network);
    return bech32codec.encode(Bech32(prefix, _convertBits(data, 8, 5, true)));
  }

  Bech32 parse(String address) {
    Bech32Codec bech32codec = Bech32Codec();
    Bech32 parsed = bech32codec.decode(address);
    Uint8List data = _convertBits(parsed.data, 5, 8, false);
    return data.isEmpty ? null : Bech32(parsed.hrp, data);
  }

  String blake160FromAddress(String address) {
    Bech32 bech32 = parse(address);
    String payload = listToWholeHex(bech32.data);
    return payload.startsWith(AddressParams.formatType(formatType))
        ? payload.replaceAll(
            AddressParams.formatType(formatType) +
                AddressParams.codeHashIndex(codeHashIndex),
            "")
        : null;
  }

  Uint8List _convertBits(Uint8List data, int fromBits, int toBits, bool pad) {
    int acc = 0;
    int bits = 0;
    int maxv = (1 << toBits) - 1;
    List<int> ret = List<int>();
    for (int i = 0; i < data.length; i++) {
      int b = data[i] & 0xff;
      if ((b >> fromBits) > 0) {
        throw Exception("Address format exception");
      }
      acc = (acc << fromBits) | b;
      bits += fromBits;
      while (bits >= toBits) {
        bits -= toBits;
        ret.add((acc >> bits) & maxv);
      }
    }

    if (pad && (bits > 0)) {
      ret.add((acc << (toBits - bits)) & maxv);
    } else if (bits >= fromBits || ((acc << (toBits - bits)) & maxv) != 0) {
      throw Exception(
          "Strict mode was used but input couldn't be converted without padding");
    }
    return Uint8List.fromList(ret);
  }
}
