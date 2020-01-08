import 'dart:math';
import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:pointycastle/src/utils.dart' as utils;

String toWholeHex(String hexString) {
  var hex = cleanHexPrefix(hexString);
  var wholeHex = hex.length % 2 == 0 ? hex : '0$hex';
  return appendHexPrefix(wholeHex);
}

Uint8List bigIntToList(BigInt value) {
  return utils.encodeBigInt(value);
}

BigInt listToBigInt(Uint8List bytes) {
  return utils.decodeBigInt(bytes);
}

Uint8List hexToList(String hexString) {
  if (cleanHexPrefix(hexString).isEmpty) {
    return Uint8List.fromList([]);
  }
  return Uint8List.fromList(HEX.decode(cleanHexPrefix(toWholeHex(hexString))));
}

String listToHex(Uint8List bytes) {
  return appendHexPrefix(listToHexNoPrefix(bytes));
}

String listToHexNoPrefix(Uint8List bytes) {
  return HEX.encode(bytes);
}

String listToWholeHex(Uint8List bytes) {
  var hex = listToBigInt(bytes).toRadixString(16);
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

BigInt numberToBigInt(String value) {
  try {
    if (value.startsWith('0x')) {
      return BigInt.parse(cleanHexPrefix(value), radix: 16);
    }
    return BigInt.parse(value);
  } catch (error) {
    throw ('Input value format error, please input integer or hex string');
  }
}

BigInt hexToBigInt(String hex) {
  return BigInt.parse(cleanHexPrefix(hex), radix: 16);
}

int hexToInt(String hex) {
  return BigInt.parse(cleanHexPrefix(hex), radix: 16).toInt();
}

String bigIntToHex(BigInt value) {
  return appendHexPrefix(value.toRadixString(16));
}

String intToHex(int value) {
  return appendHexPrefix(value.toRadixString(16));
}

List<int> toBytesPadded(BigInt value, int length) {
  List<int> bytes = bigIntToList(value);
  if (bytes.length > length) {
    throw ('Input is too large to put in byte array of size ${length.toString()}');
  }
  var result = List<int>(length);
  var offset = length - bytes.length;
  for (var i = 0; i < length; i++) {
    result[i] = i < offset ? 0 : bytes[i - offset];
  }
  return result;
}

BigInt ckbToShannon({BigInt bigInt, num number}) {
  if (bigInt != null) {
    return bigInt * BigInt.from(10).pow(8);
  } else if (number != null) {
    return BigInt.from(number * pow(10, 8));
  }
  throw Exception('Parameter is invalid');
}

List<int> regionToList(int start, int length) {
  var integers = <int>[];
  for (var i = start; i < (start + length); i++) {
    integers.add(i);
  }
  return integers;
}
