import 'dart:typed_data';
import 'package:convert/convert.dart';

import 'package:pointycastle/src/utils.dart' as utils;

String toWholeHex(String hexString) {
  String hex = cleanHexPrefix(hexString);
  String wholeHex = hex.length % 2 == 0 ? hex : '0$hex';
  return appendHexPrefix(wholeHex);
}

Uint8List bigIntToList(BigInt value) {
  return utils.encodeBigInt(value);
}

BigInt listToBigInt(Uint8List bytes) {
  return utils.decodeBigInt(bytes);
}

Uint8List hexToList(String hexString) {
  return Uint8List.fromList(hex.decode(cleanHexPrefix(toWholeHex(hexString))));
}

String listToHex(Uint8List bytes) {
  return appendHexPrefix(listToHexNoPrefix(bytes));
}

String listToHexNoPrefix(Uint8List bytes) {
  return hex.encode(bytes);
}

String listToWholeHex(Uint8List bytes) {
  String hex = listToBigInt(bytes).toRadixString(16);
  return toWholeHex(hex);
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
    return appendHexPrefix(BigInt.parse(value).toRadixString(16));
  } catch (error) {
    throw ('Input value format error, please input integer or hex string');
  }
}

BigInt hexToBigInt(String hex) {
  return BigInt.parse(cleanHexPrefix(hex), radix: 16);
}

List<int> toBytesPadded(BigInt value, int length) {
  List<int> bytes = bigIntToList(value);
  if (bytes.length > length) {
    throw ('Input is too large to put in byte array of size ${length.toString()}');
  }
  List<int> result = List(length);
  int offset = length - bytes.length;
  for (int i = 0; i < length; i++) {
    result[i] = i < offset ? 0 : bytes[i - offset];
  }
  return result;
}
