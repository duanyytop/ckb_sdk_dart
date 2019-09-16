import 'dart:typed_data';

import 'package:pointycastle/src/utils.dart' as utils;

Uint8List bigIntToList(BigInt value) {
  return utils.encodeBigInt(value);
}

BigInt listToBigInt(Uint8List bytes) {
  return utils.decodeBigInt(bytes);
}

Uint8List hexToList(String hexString) {
  try {
    BigInt big = BigInt.parse(cleanHexPrefix(hexString), radix: 16);
    if (big.toInt() == 0) return Uint8List.fromList([0]);
    return bigIntToList(big);
  } catch (error) {
    return Uint8List.fromList([]);
  }
}

String listToHex(Uint8List bytes) {
  return listToBigInt(bytes).toRadixString(16);
}

String listToWholeHex(Uint8List bytes) {
  String hex = listToBigInt(bytes).toRadixString(16);
  return hex.length % 2 == 0 ? hex : '0${hex}';
}

String cleanHexPrefix(String hex) {
  return hex.startsWith('0x') ? hex.substring(2) : hex;
}

String appendHexPrefix(String hex) {
  return hex.startsWith('0x') ? hex : '0x$hex';
}

String toHexString(String value) {
  if (value.startsWith('0x')) return value;
  try {
    return BigInt.parse(value).toRadixString(16);
  } catch (error) {
    throw ('Input value format error, please input integer or hex string');
  }
}

List<int> toBytesPadded(BigInt value, int length) {
  List<int> result = [];
  for (int i = 0; i < length; i++) {
    result.add(0);
  }

  List<int> bytes = bigIntToList(value);

  int bytesLength;
  int srcOffset;
  if (bytes[0] == 0) {
    bytesLength = bytes.length - 1;
    srcOffset = 1;
  } else {
    bytesLength = bytes.length;
    srcOffset = 0;
  }

  if (bytesLength > length) {
    throw ("Input is too large to put in byte array of size " +
        length.toString());
  }

  int destOffset = length - bytesLength;
  result = arrayCopy(bytes, srcOffset, result, destOffset, bytesLength);
  return result;
}

List<int> arrayCopy(bytes, srcOffset, result, destOffset, bytesLength) {
  for (var i = srcOffset; i < bytesLength; i++) {
    result[destOffset + i] = bytes[i];
  }
  return result;
}
