
import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/src/core/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/core/type/cell_input.dart';

class TransactionBuilder {

  List<CellInput> _cellInputs = [];
  List<CellOutput> _cellOutputs = [];
  List<String> _cellOutputsData = [];
  List<CellDep> _cellDeps = [];
  List<String> _headerDeps = [];
  List _witnesses = [];

  TransactionBuilder(Api api) {
    SystemContract.getSystemSecpCell(api: api)
      .then((systemScriptCell) => {
        _cellDeps.add(CellDep(
          outPoint: systemScriptCell.outPoint, depType: CellDep.DepGroup))
      });
  }

  void addInput(CellInput input) {
    _cellInputs.add(input);
  }

  void addInputs(List<CellInput> inputs) {
    _cellInputs.addAll(inputs);
  }

  void setInputs(List<CellInput> inputs) {
    _cellInputs = inputs;
  }

  void addWitnesses(List witnesses) {
    _witnesses = witnesses;
  }

  void addWitness(Object witness) {
    _witnesses.add(witness);
  }

  void addOutput(CellOutput output) {
    _cellOutputs.add(output);
  }

  void addOutputs(List<CellOutput> outputs) {
    _cellOutputs.addAll(outputs);
  }

  void setOutputs(List<CellOutput> outputs) {
    _cellOutputs = outputs;
  }

  void addCellDep(CellDep cellDep) {
    _cellDeps.add(cellDep);
  }

  void addCellDeps(List<CellDep> cellDeps) {
    _cellDeps.addAll(cellDeps);
  }

  List<CellDep> getCellDeps() {
    return _cellDeps;
  }

  void setOutputsData(List<String> outputsData) {
    _cellOutputsData = outputsData;
  }

  void setHeaderDeps(List<String> headerDeps) {
    _headerDeps = headerDeps;
  }

  Transaction buildTx() {
    if (_cellOutputsData.isEmpty) {
      for (var i = 0; i < _cellOutputs.length; i++) {
        _cellOutputsData.add('0x');
      }
    }

    return Transaction(
        version: '0', cellDeps: _cellDeps, headerDeps: _headerDeps, inputs: _cellInputs, outputs: _cellOutputs, outputsData: _cellOutputsData, witnesses: _witnesses);
    }
}
