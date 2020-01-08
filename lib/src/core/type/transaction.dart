import 'dart:typed_data';

import 'package:ckb_sdk_dart/src/core/type/witness.dart';
import 'package:ckb_sdk_dart/src/crypto/blake2b.dart';
import 'package:ckb_sdk_dart/src/crypto/sign.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

import '../../../ckb_serialization.dart';
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
  List<dynamic> witnesses;

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
        witnesses:
            (json['witnesses'] as List)?.map((witness) => witness)?.toList());
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
    var blake2b = Blake2b();
    blake2b.update(Serializer.serializeRawTransaction(this)?.toBytes());
    return appendHexPrefix(blake2b.doFinalString());
  }

  Transaction sign(String privateKey) {
    if (witnesses.isEmpty) {
      throw Exception('Need at least one witness!');
    }
    if (witnesses[0] is! Witness) {
      throw Exception('First witness must be of Witness type!');
    }
    var txHash = computeHash();
    var emptiedWitness = witnesses[0] as Witness;
    emptiedWitness.lock = Witness.SIGNATURE_PLACEHOLDER;
    var witnessTable = Serializer.serializeWitnessArgs(emptiedWitness);
    var blake2b = Blake2b();
    blake2b.update(hexToList(txHash));
    blake2b.update(UInt64.fromInt(witnessTable.getLength()).toBytes());
    blake2b.update(witnessTable.toBytes());
    for (var i = 1; i < witnesses.length; i++) {
      Uint8List bytes;
      if (witnesses[i] is Witness) {
        bytes =
            Serializer.serializeWitnessArgs(witnesses[i] as Witness).toBytes();
      } else {
        bytes = hexToList(witnesses[i] as String);
      }
      blake2b.update(UInt64.fromInt(bytes.length).toBytes());
      blake2b.update(bytes);
    }
    var message = blake2b.doFinalString();
    (witnesses[0] as Witness).lock = listToHex(
        Sign.signMessage(hexToList(message), privateKey).getSignature());

    var signedWitness = [];
    for (Object witness in witnesses) {
      if (witness is Witness) {
        signedWitness
            .add(listToHex(Serializer.serializeWitnessArgs(witness).toBytes()));
      } else {
        signedWitness.add(witness);
      }
    }

    return Transaction(
        version: version,
        hash: txHash,
        cellDeps: cellDeps,
        headerDeps: headerDeps,
        inputs: inputs,
        outputs: outputs,
        outputsData: outputsData,
        witnesses: signedWitness);
  }
}
