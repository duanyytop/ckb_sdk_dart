import 'package:pointycastle/src/utils.dart' as utils;

List<int> bigIntToList(BigInt value) {
  return utils.encodeBigInt(value);
}

BigInt listToBigInt(List<int> bytes) {
  return utils.decodeBigInt(bytes);
}

List<int> hexToList(String hexString) {
  String hex = hexString.startsWith('0x') ? hexString.substring(2) : hexString;
  return bigIntToList(BigInt.parse(hex, radix: 16));
}

String listToHex(List<int> bytes) {
  return listToBigInt(bytes).toRadixString(16);
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
