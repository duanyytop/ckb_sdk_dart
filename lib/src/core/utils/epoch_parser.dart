import 'package:ckb_sdk_dart/src/utils/utils.dart';

EpochInfo parseEpoch(String hexEpoch) {
  var epochLong = hexToBigInt(hexEpoch).toInt();
  var length = (epochLong >> 40) & 0xFFFF;
  var index = (epochLong >> 24) & 0xFFFF;
  var number = epochLong & 0xFFFFFF;
  return EpochInfo(length, index, number);
}

String combineEpoch(int length, int index, int number) {
  var epoch = BigInt.from((length << 40) + (index << 24) + number);
  return bigIntToHex(epoch);
}

String epochSince(int length, int index, int number) {
  var bigInteger = BigInt.parse('20', radix: 16) << 56;
  var epoch = BigInt.from((length << 40) + (index << 24) + number);
  return bigIntToHex(bigInteger + epoch);
}

class EpochInfo {
  int length;
  int index;
  int number;

  EpochInfo(this.length, this.index, this.number);
}
