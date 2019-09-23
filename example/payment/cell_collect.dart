import 'dart:math';

import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/crypto/key.dart';
import 'package:ckb_sdk_dart/src/rpc/api.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_script_cell.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

const step = 100;

class CellCollect {
  static Future<Cells> getCellInputs(
      {Api api, String lockHash, BigInt capacity}) async {
    List<CellInput> cellInputs = [];
    BigInt collectCapacity = BigInt.zero;
    int to = hexToBigInt(await api.getTipBlockNumber()).toInt();
    int from = 1;

    while (from <= to && collectCapacity.compareTo(capacity) < 0) {
      int current = min(from + step, to);
      List<CellOutputWithOutPoint> cellOutputs = await api.getCellsByLockHash(
          lockHash: lockHash,
          fromNumber: from.toString(),
          toNumber: to.toString());

      if (cellOutputs.isNotEmpty) {
        for (var cellOutput in cellOutputs) {
          collectCapacity += hexToBigInt(cellOutput.capacity);
          cellInputs
              .add(CellInput(previousOutput: cellOutput.outPoint, since: "0"));
          if (collectCapacity.compareTo(capacity) > 0) break;
        }
      }
      from = current + 1;
    }
    return Cells(inputs: cellInputs, capacity: collectCapacity);
  }

  static Future<BigInt> getCapacityWithAddress(
      {Api api, String address}) async {
    SystemScriptCell systemScriptCell =
        await SystemContract.getSystemScriptCell(api);
    Script lockScript =
        Key.generateLockScriptWithAddress(address, systemScriptCell.cellHash);
    return getCapacityWithLockHash(
        api: api, lockHash: lockScript.computeHash());
  }

  static Future<BigInt> getCapacityWithLockHash(
      {Api api, String lockHash}) async {
    BigInt capacity = BigInt.zero;
    int to = hexToBigInt(await api.getTipBlockNumber()).toInt();
    int from = 1;

    while (from <= to) {
      int current = min(from + step, to);
      List<CellOutputWithOutPoint> cellOutputs = await api.getCellsByLockHash(
          lockHash: lockHash,
          fromNumber: from.toString(),
          toNumber: current.toString());

      if (cellOutputs.isNotEmpty) {
        capacity += cellOutputs.fold(capacity,
            (previous, element) => previous + hexToBigInt(element.capacity));
      }
      from = current + 1;
    }
    return capacity;
  }
}

class Cells {
  List<CellInput> inputs;
  BigInt capacity;

  Cells({this.inputs, this.capacity});
}
