import 'dart:math';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/address/address_parser.dart';
import 'package:ckb_sdk_dart/src/core/type/witness.dart';
import 'package:ckb_sdk_dart/src/core/utils/calculator.dart';
import 'package:ckb_sdk_dart/src/core/utils/serializer.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

import 'cells_with_address.dart';
import 'collect_result.dart';

class CellCollector {
  final BigInt MIN_CELL_CAPACITY = ckbToShannon(number: 61);

  Api api;
  bool skipDataAndType;

  CellCollector(this.api, {this.skipDataAndType = true});

  Future<CollectResult> collectInputs(List<String> addresses, Transaction tx, BigInt feeRate, int initialLength) async {
    var lockHashes = [];
    for (var address in addresses) {
      lockHashes.add(AddressParser.parse(address).script.computeHash());
    }
    var lockInputsMap = <String, List<CellInput>>{};
    for (String lockHash in lockHashes) {
      lockInputsMap[lockHash] = [];
    }
    var cellInputs = <CellInput>[];

    for (var i = 0; i < tx.outputs.length - 1; i++) {
      var size = tx.outputs[i].occupiedCapacity('0x');
      if (size > hexToInt(tx.outputs[i].capacity)) {
        throw Exception('Cell output byte size must not be bigger than capacity');
      }
    }

    var transaction = Transaction(
        version: '0',
        cellDeps: tx.cellDeps,
        headerDeps: tx.headerDeps,
        inputs: tx.inputs,
        outputs: tx.outputs,
        outputsData: tx.outputsData,
        witnesses: []);

    var inputsCapacity = BigInt.zero;
    for (var cellInput in tx.inputs) {
      cellInputs.add(cellInput);

      var cellWithStatus = await api.getLiveCell(outPoint: cellInput.previousOutput, withData: false);
      inputsCapacity = inputsCapacity + hexToBigInt(cellWithStatus.cell.output.capacity);
    }
    var witnesses = [];

    var changeOutput = tx.outputs[tx.outputs.length - 1];

    var needCapacity = BigInt.zero;
    for (var cellOutput in tx.outputs) {
      needCapacity = needCapacity + hexToBigInt(cellOutput.capacity);
    }
    List<CellOutputWithOutPoint> cellOutputList;
    for (String lockHash in lockHashes) {
      var toBlockNumber = hexToInt(await api.getTipBlockNumber());
      var fromBlockNumber = 1;

      while (
          fromBlockNumber <= toBlockNumber && inputsCapacity < (needCapacity + _calculateTxFee(transaction, feeRate))) {
        var currentToBlockNumber = min(fromBlockNumber + 100, toBlockNumber);
        cellOutputList = await api.getCellsByLockHash(
            lockHash: lockHash, fromNumber: intToHex(fromBlockNumber), toNumber: intToHex(currentToBlockNumber));
        for (var cellOutputWithOutPoint in cellOutputList) {
          if (skipDataAndType) {
            var cellWithStatus = await api.getLiveCell(outPoint: cellOutputWithOutPoint.outPoint, withData: true);
            var outputsDataContent = cellWithStatus.cell.data.content;
            var cellOutput = cellWithStatus.cell.output;
            if ((outputsDataContent.isNotEmpty && '0x' != outputsDataContent) || cellOutput.type != null) {
              continue;
            }
          }
          var cellInput = CellInput(previousOutput: cellOutputWithOutPoint.outPoint, since: '0x0');
          inputsCapacity = inputsCapacity + hexToBigInt(cellOutputWithOutPoint.capacity);
          var cellInputList = lockInputsMap[lockHash];
          cellInputList.add(cellInput);
          cellInputs.add(cellInput);
          witnesses.add('0x');
          transaction.inputs = cellInputs;
          transaction.witnesses = witnesses;
          var sumNeedCapacity =
              needCapacity + _calculateTxFee(transaction, feeRate) + calculateOutputSize(changeOutput);
          if (inputsCapacity > (sumNeedCapacity + MIN_CELL_CAPACITY)) {
            // update witness of group first element
            var witnessIndex = 0;
            for (String hash in lockHashes) {
              if (lockInputsMap[hash].isEmpty) break;
              witnesses[witnessIndex] = Witness(lock: '0' * initialLength);
              witnessIndex += lockInputsMap[hash].length;
            }

            transaction.witnesses = witnesses;
            // calculate sum need capacity again
            sumNeedCapacity = needCapacity + _calculateTxFee(transaction, feeRate) + calculateOutputSize(changeOutput);
            if (inputsCapacity > (sumNeedCapacity + MIN_CELL_CAPACITY)) break;
          }
        }
        fromBlockNumber = currentToBlockNumber + 1;
      }
    }
    if (inputsCapacity < (needCapacity + _calculateTxFee(transaction, feeRate) + MIN_CELL_CAPACITY)) {
      throw Exception('Capacity not enough!');
    }
    var changeCapacity = inputsCapacity - (needCapacity + _calculateTxFee(transaction, feeRate));
    var cellsWithAddresses = <CellsWithAddress>[];
    lockInputsMap.forEach((key, value) =>
        {cellsWithAddresses.add(CellsWithAddress(inputs: value, address: addresses[lockHashes.indexOf(key)]))});
    if (tx.inputs != null && tx.inputs.isNotEmpty) {
      cellsWithAddresses[0].inputs.insertAll(0, tx.inputs);
    }
    return CollectResult(cellsWithAddresses, bigIntToHex(changeCapacity));
  }

  BigInt _calculateTxFee(Transaction transaction, BigInt feeRate) {
    return calculateTransactionFee(transaction, feeRate);
  }

  Future<BigInt> getCapacityWithAddress(String address) async {
    return await getCapacityWithLockHash(AddressParser.parse(address).script.computeHash());
  }

  Future<BigInt> getCapacityWithLockHash(String lockHash) async {
    var capacity = BigInt.zero;
    var toBlockNumber = hexToInt(await api.getTipBlockNumber());
    var fromBlockNumber = 1;

    while (fromBlockNumber <= toBlockNumber) {
      var currentToBlockNumber = min(fromBlockNumber + 100, toBlockNumber);
      var cellOutputs = await api.getCellsByLockHash(
          lockHash: lockHash, fromNumber: intToHex(fromBlockNumber), toNumber: intToHex(currentToBlockNumber));

      if (cellOutputs != null && cellOutputs.isNotEmpty) {
        for (var output in cellOutputs) {
          if (skipDataAndType) {
            var cellWithStatus = await api.getLiveCell(outPoint: output.outPoint, withData: true);
            var outputsDataContent = cellWithStatus.cell.data.content;
            var cellOutput = cellWithStatus.cell.output;
            if ((outputsDataContent.isNotEmpty && '0x' != outputsDataContent) || cellOutput.type != null) {
              continue;
            }
          }
          capacity = capacity + hexToBigInt(output.capacity);
        }
      }
      fromBlockNumber = currentToBlockNumber + 1;
    }
    return capacity;
  }

  BigInt calculateOutputSize(CellOutput cellOutput) {
    return BigInt.from(Serializer.serializeCellOutput(cellOutput).getLength());
  }
}
