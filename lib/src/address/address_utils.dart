import 'dart:typed_data';

const String TYPE_SHORT =
    '01'; // short version for locks with popular code_hash
const String TYPE_FULL_DATA = '02'; // full version with hash_type = 'Data'
const String TYPE_FULL_TYPE = '04'; // full version with hash_type = 'Type'

const String CODE_HASH_IDX_BLAKE160 = '00';
const String CODE_HASH_IDX_MULTISIG = '01';

const String SECP_BLAKE160_CODE_HASH =
    '9bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8';
const String MULTISIG_CODE_HASH =
    '5c5069eb0857efc65e1bca0c07df34c31663b3622fd3876c876320fc9634e2a8';

Uint8List convertBits(Uint8List data, int fromBits, int toBits, bool pad) {
  var acc = 0;
  var bits = 0;
  var maxv = (1 << toBits) - 1;
  var ret = <int>[];
  for (var i = 0; i < data.length; i++) {
    var b = data[i] & 0xff;
    if ((b >> fromBits) > 0) {
      throw Exception('Address format exception');
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
        'Strict mode was used but input couldn\'t be converted without padding');
  }
  return Uint8List.fromList(ret);
}
