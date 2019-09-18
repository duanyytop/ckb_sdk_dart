import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

class Convert {
  static OutPoint parseOutPoint(OutPoint outPoint) {
    return OutPoint(
        txHash: outPoint.txHash, index: toHexString(outPoint.index));
  }

  static Transaction parseTransaction(Transaction transaction) {
    List<CellDep> cellDeps = transaction.cellDeps
        .map((cellDep) => CellDep(
            outPoint: parseOutPoint(cellDep.outPoint),
            depType: cellDep.depType))
        .toList();

    List<CellInput> inputs = transaction.inputs
        .map((input) => CellInput(
            previousOutput: parseOutPoint(input.previousOutput),
            since: toHexString(input.since)))
        .toList();

    List<CellOutput> outputs = transaction.outputs
        .map((output) => CellOutput(
            capacity: toHexString(output.capacity),
            lock: output.lock,
            type: output.type))
        .toList();

    return Transaction(
        version: toHexString(transaction.version),
        cellDeps: cellDeps,
        headerDeps: transaction.headerDeps,
        inputs: inputs,
        outputs: outputs,
        outputsData: transaction.outputsData,
        witnesses: transaction.witnesses);
  }
}
