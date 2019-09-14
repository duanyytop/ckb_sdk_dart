import 'cell_dep.dart';
import 'cell_input.dart';
import 'cell_output.dart';
import 'witness.dart';

class Transaction {
  String version;
  String hash;
  List<CellDep> cellDeps;
  List<String> headerDeps;
  List<CellInput> inputs;
  List<CellOutput> outputs;
  List<String> outputsData;
  List<Witness> witnesses;

  Transaction(
      {this.version,
      this.hash,
      this.cellDeps,
      this.headerDeps,
      this.inputs,
      this.outputs,
      this.outputsData,
      this.witnesses});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        version: json['version'],
        hash: json['hash'],
        cellDeps: List.from(json['cell_deps'])
            .map((cellDep) => CellDep.fromJson(cellDep))
            .toList(),
        headerDeps: List<String>.from(json['header_deps']),
        inputs: List.from(json['inputs'])
            .map((input) => CellInput.fromJson(input))
            .toList(),
        outputs: List.from(json['outputs'])
            .map((output) => CellOutput.fromJson(output))
            .toList(),
        outputsData: List<String>.from(json['outputs_data']),
        witnesses: List.from(json['witnesses'])
            .map((witness) => Witness.fromJson(witness))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'version': version,
      'hash': hash,
      'cell_deps': cellDeps,
      'version': version,
      'header_deps': hash,
      'outputs': outputs,
      'outputs_data': outputsData,
      'witnesses': witnesses
    };
  }
}
