import 'package:pointycastle/src/utils.dart' as utils;

List<int> bigIntToList(BigInt value) {
  return utils.encodeBigInt(value);
}

BigInt listToBigInt(List<int> bytes) {
  return utils.decodeBigInt(bytes);
}

List<int> hexToList(String hexString) {
  return bigIntToList(BigInt.parse(cleanHexPrefix(hexString), radix: 16));
}

String listToHex(List<int> bytes) {
  return listToBigInt(bytes).toRadixString(16);
}

String listToWholeHex(List<int> bytes) {
  String hex = listToBigInt(bytes).toRadixString(16);
  return hex.length % 2 == 0 ? hex : '0${hex}';
}

String cleanHexPrefix(String hex) {
  return hex.startsWith('0x') ? hex.substring(2) : hex;
}

String appendHexPrefix(String hex) {
  return hex.startsWith('0x') ? hex : '0x$hex';
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
