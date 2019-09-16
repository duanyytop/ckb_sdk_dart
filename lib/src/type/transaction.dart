import 'package:ckb_sdk_dart/src/crypto/blake2b.dart';
import 'package:ckb_sdk_dart/src/crypto/sign.dart';
import 'package:ckb_sdk_dart/src/type/serializer/serializer.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

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
      'header_deps': headerDeps,
      'inputs': inputs,
      'outputs': outputs,
      'outputs_data': outputsData,
      'witnesses': witnesses
    };
  }

  String computeHash() {
    Blake2b blake2b = Blake2b();
    blake2b.update(Serializer.serializeTransaction(this).toBytes());
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

      String signature = appendHexPrefix(listToHex(
          Sign.signMessage(hexToList(message), privateKey).getSignature()));
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
