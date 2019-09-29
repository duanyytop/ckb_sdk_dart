import '../crypto/blake2b.dart';
import '../crypto/sign.dart';
import '../utils/utils.dart';
import 'cell_dep.dart';
import 'cell_input.dart';
import 'cell_output.dart';
import 'utils/serializer.dart';

class Transaction {
  String version;
  String hash;
  List<CellDep> cellDeps;
  List<String> headerDeps;
  List<CellInput> inputs;
  List<CellOutput> outputs;
  List<String> outputsData;
  List<String> witnesses;

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
    if (json == null) return null;
    return Transaction(
        version: json['version'],
        hash: json['hash'],
        cellDeps: (json['cell_deps'] as List)
            ?.map((cellDep) => CellDep.fromJson(cellDep))
            ?.toList(),
        headerDeps: (json['header_deps'] as List)
            ?.map((headerDep) => headerDep?.toString())
            ?.toList(),
        inputs: (json['inputs'] as List)
            ?.map((input) => CellInput.fromJson(input))
            ?.toList(),
        outputs: (json['outputs'] as List)
            ?.map((output) => CellOutput.fromJson(output))
            ?.toList(),
        outputsData: (json['outputs_data'] as List)
            ?.map((outputData) => outputData.toString())
            ?.toList(),
        witnesses: (json['witnesses'] as List)
            ?.map((witness) => witness?.toString())
            ?.toList());
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'version': version,
      'hash': hash,
      'cell_deps': cellDeps?.map((cellDep) => cellDep?.toJson())?.toList(),
      'header_deps': headerDeps,
      'inputs': inputs?.map((input) => input?.toJson())?.toList(),
      'outputs': outputs?.map((output) => output?.toJson())?.toList(),
      'outputs_data': outputsData,
      'witnesses': witnesses
    };
  }

  Map<String, dynamic> toRawJson() {
    return <String, dynamic>{
      'version': version,
      'cell_deps': cellDeps?.map((cellDep) => cellDep?.toJson())?.toList(),
      'header_deps': headerDeps,
      'inputs': inputs?.map((input) => input?.toJson())?.toList(),
      'outputs': outputs?.map((output) => output?.toJson())?.toList(),
      'outputs_data': outputsData,
      'witnesses': witnesses
    };
  }

  String computeHash() {
    Blake2b blake2b = Blake2b();
    blake2b.update(Serializer.serializeTransaction(this)?.toBytes());
    return appendHexPrefix(blake2b.doFinalString());
  }

  Transaction sign(String privateKey) {
    if (witnesses.length < inputs.length) {
      throw ("Invalid number of witnesses");
    }
    String txHash = computeHash();
    List<String> signedWitnesses = [];
    for (String witness in witnesses) {
      Blake2b blake2b = Blake2b();
      blake2b.update(hexToList(txHash));
      blake2b.update(hexToList(witness));
      String message = blake2b.doFinalString();

      String signature = listToHex(
          Sign.signMessage(hexToList(message), privateKey).getSignature());
      signedWitnesses.add('$signature${cleanHexPrefix(witness)}');
    }

    return Transaction(
        version: version,
        hash: txHash,
        cellDeps: cellDeps,
        headerDeps: headerDeps,
        inputs: inputs,
        outputs: outputs,
        outputsData: outputsData,
        witnesses: signedWitnesses);
  }
}
