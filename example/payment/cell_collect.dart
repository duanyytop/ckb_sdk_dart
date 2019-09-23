import 'dart:math';

import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/rpc/api.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

const step = 100;

class CellCollect {
  Api api;
  String lockHash;

  CellCollect({this.api, this.lockHash});

  Future<List<CellOutputWithOutPoint>> getUnspentCells(
      {bool skipDataType = true}) async {
    List<CellOutputWithOutPoint> results = [];
    int to = hexToBigInt(await api.getTipBlockNumber()).toInt();
    int from = 1;

    while (from <= to) {
      int current = min(from + step, to);
      List<CellOutputWithOutPoint> cellOutputs = await api.getCellsByLockHash(
          lockHash: lockHash,
          fromNumber: from.toString(),
          toNumber: current.toString());

      if (cellOutputs.isNotEmpty) {
        if (skipDataType) {
          for (var cellOutput in cellOutputs) {
            CellWithStatus cell = await api.getLiveCell(
                outPoint: cellOutput.outPoint, withData: true);
            CellOutput output = cell.cell.output;
            String outputData = cell.cell.data.content;
            if ((outputData.isEmpty ||
                    (outputData.isNotEmpty && outputData == '0x')) &&
                output.type == null) {
              results.add(cellOutput);
            }
          }
        } else {
          results.addAll(cellOutputs);
        }
      }
      from = current + 1;
    }
    return results;
  }

  Future<CellCollectContainer> gatherInputs(
      {BigInt capacity,
      BigInt minCapacity,
      BigInt minChangeCapacity,
      BigInt fee}) async {
    if (capacity < minCapacity) {
      throw ('capacity cannot be less than $minCapacity');
    }
    if (minChangeCapacity == null) {
      minChangeCapacity = BigInt.zero;
    }
    BigInt totalCapacity = capacity + fee;
    BigInt collectCapacity = BigInt.zero;

    List<CellInput> cellInputs = [];
    List<Witness> witnesses = [];

    List<CellOutputWithOutPoint> cellOutputs = await getUnspentCells();
    for (var cellOuput in cellOutputs) {
      cellInputs.add(CellInput(previousOutput: cellOuput.outPoint, since: '0'));
      witnesses.add(Witness(data: []));
      collectCapacity += hexToBigInt(cellOuput.capacity);
      BigInt diff = collectCapacity - totalCapacity;
      if (diff >= minChangeCapacity || diff == BigInt.zero) {
        break;
      }
    }
    if (collectCapacity < totalCapacity) {
      throw ('Capacity not enough!');
    }
    return CellCollectContainer(
        inputs: cellInputs, capacity: collectCapacity, witnesses: witnesses);
  }

  Future<BigInt> getBalance() async {
    List<CellOutputWithOutPoint> cellInputs = await getUnspentCells();
    BigInt balance = cellInputs.fold(BigInt.zero,
        (previous, element) => previous + hexToBigInt(element.capacity));
    return balance;
  }
}

class CellCollectContainer {
  List<CellInput> inputs;
  BigInt capacity;
  List<Witness> witnesses;

  CellCollectContainer({this.inputs, this.capacity, this.witnesses});
}
