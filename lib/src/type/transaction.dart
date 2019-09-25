import '../crypto/blake2b.dart';
import '../crypto/sign.dart';
import '../utils/utils.dart';
import 'cell_dep.dart';
import 'cell_input.dart';
import 'cell_output.dart';
import 'utils/serializer.dart';
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
            ?.map((witness) => Witness.fromJson(witness))
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
      'witnesses': witnesses?.map((witness) => witness?.toJson())?.toList()
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
      'witnesses': witnesses?.map((witness) => witness?.toJson())?.toList()
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
    List<Witness> signedWitnesses = [];
    for (Witness witness in witnesses) {
      List<String> oldData = witness.data;
      Blake2b blake2b = Blake2b();
      blake2b.update(hexToList(txHash));
      for (String datum in witness.data) {
        blake2b.update(hexToList(datum));
      }
      String message = blake2b.doFinalString();

      String signature = listToHex(
          Sign.signMessage(hexToList(message), privateKey).getSignature());
      witness.data = [signature];
      witness.data.addAll(oldData);
      signedWitnesses.add(witness);
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
