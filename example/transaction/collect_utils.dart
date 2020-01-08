import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/address/address_parser.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

import 'cell_collect.dart';
import 'collect_result.dart';
import 'receiver.dart';

class CollectUtils {
  Api api;
  bool skipDataAndType;

  CollectUtils(this.api, {this.skipDataAndType = true});

  Future<CollectResult> collectInputs(List<String> addresses,
      Transaction transaction, BigInt feeRate, int initialLength) async {
    return await CellCollector(api, skipDataAndType: skipDataAndType)
        .collectInputs(addresses, transaction, feeRate, initialLength);
  }

  List<CellOutput> generateOutputs(
      List<Receiver> receivers, String changeAddress) {
    var cellOutputs = <CellOutput>[];
    for (var receiver in receivers) {
      var addressParseResult = AddressParser.parse(receiver.address);
      cellOutputs.add(CellOutput(
          capacity: bigIntToHex(receiver.capacity),
          lock: addressParseResult.script));
    }
    var needCapacity = BigInt.zero;
    for (var receiver in receivers) {
      needCapacity = needCapacity + receiver.capacity;
    }

    cellOutputs.add(CellOutput(
        capacity: '0x0', lock: AddressParser.parse(changeAddress).script));

    return cellOutputs;
  }
}
