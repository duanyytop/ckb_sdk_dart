import 'dart:math';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/address/address_parser.dart';
import 'package:ckb_sdk_dart/src/core/type/witness.dart';
import 'package:ckb_sdk_dart/src/core/utils/calculator.dart';
import 'package:ckb_sdk_dart/src/core/utils/serializer.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/uint128.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

import '../transaction/cells_with_address.dart';
import 'udt_collect_result.dart';

class UDTCellCollector {
  final BigInt _MIN_UDT_CHANGE_CAPACITY = BigInt.from(142);

  Api api;
  bool noLimit = false;

  UDTCellCollector(this.api, {this.noLimit});

  Future<UDTCollectResult> collectInputs(List<String> addresses, Transaction tx, BigInt feeRate, int initialLength,
      String typeHash, BigInt udtAmount) async {
    var lockHashes = [];
    for (var address in addresses) {
      lockHashes.add(AddressParser.parse(address).script.computeHash());
    }
    var lockInputsMap = <String, List<CellInput>>{};
    for (String lockHash in lockHashes) {
      lockInputsMap[lockHash] = [];
    }
    var cellInputs = <CellInput>[];

    print(tx.toJson());

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
    var inputUdtAmount = BigInt.zero;
    for (String lockHash in lockHashes) {
      var toBlockNumber = hexToInt(await api.getTipBlockNumber());
      var fromBlockNumber = 1;

      while (fromBlockNumber <= toBlockNumber) {
        var currentToBlockNumber = min(fromBlockNumber + 100, toBlockNumber);
        cellOutputList = await api.getCellsByLockHash(
            lockHash: lockHash, fromNumber: intToHex(fromBlockNumber), toNumber: intToHex(currentToBlockNumber));
        for (var cellOutputWithOutPoint in cellOutputList) {
          var cellWithStatus = await api.getLiveCell(outPoint: cellOutputWithOutPoint.outPoint, withData: true);
          var outputsData = cellWithStatus.cell.data.content;
          var cellOutput = cellWithStatus.cell.output;

          var udtTypeValid = cellOutput.type != null && typeHash == cellOutput.type.computeHash();
          var udtAmountValid = outputsData != null && '0x' != outputsData && hexToBigInt(outputsData) > BigInt.zero;
          if (!udtTypeValid || !udtAmountValid) {
            continue;
          }
          inputUdtAmount += UInt128.fromHex(outputsData).getValue();
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
          if (inputsCapacity - sumNeedCapacity >= (noLimit ? BigInt.zero : _MIN_UDT_CHANGE_CAPACITY) &&
              inputUdtAmount >= udtAmount) {
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
            if (inputsCapacity > sumNeedCapacity) break;
          }
        }
        fromBlockNumber = currentToBlockNumber + 1;
      }
    }
    if (inputsCapacity < (needCapacity + _calculateTxFee(transaction, feeRate))) {
      throw Exception('Capacity not enough!');
    }
    var changeCapacity = inputsCapacity - (needCapacity + _calculateTxFee(transaction, feeRate));
    var changeUdtAmount = inputUdtAmount - udtAmount;
    var cellsWithAddresses = <CellsWithAddress>[];
    lockInputsMap.forEach((key, value) =>
        {cellsWithAddresses.add(CellsWithAddress(inputs: value, address: addresses[lockHashes.indexOf(key)]))});
    if (tx.inputs != null && tx.inputs.isNotEmpty) {
      cellsWithAddresses[0].inputs.insertAll(0, tx.inputs);
    }
    return UDTCollectResult(cellsWithAddresses, bigIntToHex(changeCapacity), changeUdtAmount);
  }

  BigInt _calculateTxFee(Transaction transaction, BigInt feeRate) {
    return calculateTransactionFee(transaction, feeRate);
  }

  Future<BigInt> getUdtBalanceWithAddress(String address, String typeHash) async {
    return await getUdtBalanceWithLockHash(AddressParser.parse(address).script.computeHash(), typeHash);
  }

  Future<BigInt> getUdtBalanceWithLockHash(String lockHash, String typeHash) async {
    var udtAmount = BigInt.zero;
    var toBlockNumber = hexToInt(await api.getTipBlockNumber());
    var fromBlockNumber = 1;

    while (fromBlockNumber <= toBlockNumber) {
      var currentToBlockNumber = min(fromBlockNumber + 100, toBlockNumber);
      var cellOutputs = await api.getCellsByLockHash(
          lockHash: lockHash, fromNumber: intToHex(fromBlockNumber), toNumber: intToHex(currentToBlockNumber));

      if (cellOutputs != null && cellOutputs.isNotEmpty) {
        for (var output in cellOutputs) {
          var cellWithStatus = await api.getLiveCell(outPoint: output.outPoint, withData: true);
          var outputsData = cellWithStatus.cell.data.content;
          var cellOutput = cellWithStatus.cell.output;
          if (cellOutput.type == null || typeHash != cellOutput.type.computeHash()) {
            continue;
          }
          udtAmount += UInt128.fromHex(outputsData).getValue();
        }
      }
      fromBlockNumber = currentToBlockNumber + 1;
    }
    return udtAmount;
  }

  BigInt calculateOutputSize(CellOutput cellOutput) {
    return BigInt.from(Serializer.serializeCellOutput(cellOutput).getLength());
  }
}
