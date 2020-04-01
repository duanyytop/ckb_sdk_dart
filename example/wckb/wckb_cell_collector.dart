import 'dart:math';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/ckb_serialization.dart';
import 'package:ckb_sdk_dart/src/address/address_parser.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/uint128.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

import 'cell_with_block.dart';

class WCKBCellCollector {
  final String ALWAYS_SUCCESS_CODE_HASH = '0x56806108025878f143d767a5e642f83b3043b185ed891a41eb71a7873b3f7284';

  Api api;

  WCKBCellCollector(this.api);

  Future<List<CellWithBlock>> collectInputs(String address, String typeHash, BigInt needCapacity) async {
    var lock = AddressParser.parse(address).script;
    lock.codeHash = ALWAYS_SUCCESS_CODE_HASH;
    lock.hashType = Script.Data;
    var lockHash = lock.computeHash();

    var inputsCapacity = BigInt.zero;
    var cellWithBlocks = <CellWithBlock>[];

    List<CellOutputWithOutPoint> cellOutputList;
    var toBlockNumber = hexToInt(await api.getTipBlockNumber());
    var fromBlockNumber = 1;

    while (fromBlockNumber <= toBlockNumber && inputsCapacity < needCapacity) {
      var currentToBlockNumber = min(fromBlockNumber + 100, toBlockNumber);
      cellOutputList = await api.getCellsByLockHash(
          lockHash: lockHash, fromNumber: intToHex(fromBlockNumber), toNumber: intToHex(currentToBlockNumber));
      for (var cellOutputWithOutPoint in cellOutputList) {
        var cellWithStatus = await api.getLiveCell(outPoint: cellOutputWithOutPoint.outPoint, withData: true);
        var outputsData = cellWithStatus.cell.data.content;
        var cellOutput = cellWithStatus.cell.output;
        var udtTypeValid = cellOutput.type != null && typeHash == cellOutput.type.computeHash();
        var anyoneCanPayLockValid = cellOutput.lock != null && lockHash == cellOutput.lock.computeHash();
        var udtAmountValid = outputsData != null && '0x' != outputsData;
        if (!udtTypeValid || !udtAmountValid || !anyoneCanPayLockValid) {
          continue;
        }
        var cellInput = CellInput(previousOutput: cellOutputWithOutPoint.outPoint, since: '0x0');
        var wckbAmount = UInt128.fromBytes(hexToList(cleanHexPrefix(outputsData).substring(0, 32))).getValue();
        var height = UInt64.fromBytes(hexToList(cleanHexPrefix(outputsData).substring(32))).getValue();
        var blockHash = (await api.getTransaction(cellOutputWithOutPoint.outPoint.txHash)).txStatus.blockHash;

        cellWithBlocks
            .add(CellWithBlock(input: cellInput, height: height, blockHash: blockHash, wckbAmount: wckbAmount));

        inputsCapacity = inputsCapacity + hexToBigInt(cellOutputWithOutPoint.capacity);
        if (inputsCapacity > needCapacity) break;
      }
      fromBlockNumber = currentToBlockNumber + 1;
    }
    if (inputsCapacity < needCapacity) {
      throw Exception('Capacity not enough!');
    }
    return cellWithBlocks;
  }
}
