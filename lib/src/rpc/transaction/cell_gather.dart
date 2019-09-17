import 'dart:math';

import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/rpc/api.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_script_cell.dart';
import 'package:ckb_sdk_dart/src/rpc/transaction/cells.dart';
import 'package:ckb_sdk_dart/src/rpc/transaction/tx_utils.dart';
import 'package:ckb_sdk_dart/src/type/cell_output_with_out_point.dart';

class CellGatherer {
  Api api;

  CellGatherer({this.api});

  Future<Cells> getCellInputs(String lockHash, BigInt needCapacities) async {
    List<CellInput> cellInputs = [];
    BigInt inputsCapacities = BigInt.zero;
    int toNumber = int.parse(await api.getTipBlockNumber(), radix: 16);
    int fromNumber = 1;

    while (fromNumber <= toNumber &&
        inputsCapacities.compareTo(needCapacities) < 0) {
      int currentToNumber = min(fromNumber + 100, toNumber);
      List<CellOutputWithOutPoint> cellOutputs = await api.getCellsByLockHash(
          lockHash: lockHash,
          fromNumber: fromNumber.toString(),
          toNumber: currentToNumber.toString());

      if (cellOutputs.isNotEmpty) {
        for (var cellOutput in cellOutputs) {
          inputsCapacities += BigInt.parse(cellOutput.capacity, radix: 16);
          cellInputs
              .add(CellInput(previousOutput: cellOutput.outPoint, since: "0"));
          if (inputsCapacities.compareTo(needCapacities) > 0) break;
        }
      }
      fromNumber = currentToNumber + 1;
    }
    return Cells(inputs: cellInputs, capacity: inputsCapacities);
  }

  Future<BigInt> getCapacitiesWithAddress(String address) async {
    SystemScriptCell systemScriptCell =
        await SystemContract.getSystemScriptCell(api);
    Script lockScript = TxUtils.generateLockScriptWithAddress(
        address, systemScriptCell.cellHash);
    return getCapacitiesWithLockHash(lockScript.computeHash());
  }

  Future<BigInt> getCapacitiesWithLockHash(String lockHash) async {
    BigInt capacity = BigInt.zero;
    int toNumber = int.parse(await api.getTipBlockNumber(), radix: 16);
    int fromNumber = 1;

    while (fromNumber <= toNumber) {
      int currentToNumber = min(fromNumber + 100, toNumber);
      List<CellOutputWithOutPoint> cellOutputs = await api.getCellsByLockHash(
          lockHash: lockHash,
          fromNumber: fromNumber.toString(),
          toNumber: currentToNumber.toString());

      if (cellOutputs.isNotEmpty) {
        for (var output in cellOutputs) {
          capacity += BigInt.parse(output.capacity, radix: 16);
        }
      }
      fromNumber = currentToNumber + 1;
    }
    return capacity;
  }
}
