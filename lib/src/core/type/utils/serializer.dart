import 'dart:core';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/ckb_serialization.dart';
import 'package:ckb_sdk_dart/src/core/type/cell_dep.dart';
import 'package:ckb_sdk_dart/src/core/type/cell_input.dart';
import 'package:ckb_sdk_dart/src/core/type/cell_output.dart';
import 'package:ckb_sdk_dart/src/core/type/out_point.dart';
import 'package:ckb_sdk_dart/src/core/type/script.dart';
import 'package:ckb_sdk_dart/src/core/type/witness.dart';
import 'package:ckb_sdk_dart/src/serialization/base/fixed_type.dart';
import 'package:ckb_sdk_dart/src/serialization/base/serialize_type.dart';
import 'package:ckb_sdk_dart/src/serialization/dynamic/dynamic.dart';
import 'package:ckb_sdk_dart/src/serialization/dynamic/option.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/byte1.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/byte32.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/fixed.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/struct.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/uint32.dart';
import 'convert.dart';

class Serializer {
  static Struct serializeOutPoint(OutPoint outPoint) {
    var txHash = Byte32.fromHex(outPoint.txHash);
    var index = UInt32.fromHex(outPoint.index);
    return Struct(<FixedType>[txHash, index]);
  }

  static Table serializeScript(Script script) {
    return Table([
      Byte32.fromHex(script.codeHash),
      Byte1.fromHex(Script.Data == script.hashType ? '00' : '01'),
      script.args != null ? Bytes.fromHex(script.args) : Empty()
    ]);
  }

  static Struct serializeCellInput(CellInput cellInput) {
    var sinceUInt64 = UInt64.fromHex(cellInput.since);
    var outPointStruct = serializeOutPoint(cellInput.previousOutput);
    return Struct(<SerializeType>[sinceUInt64, outPointStruct]);
  }

  static Table serializeCellOutput(CellOutput cellOutput) {
    return Table([
      UInt64.fromHex(cellOutput.capacity),
      serializeScript(cellOutput.lock),
      cellOutput.type != null ? serializeScript(cellOutput.type) : Empty()
    ]);
  }

  static Struct serializeCellDep(CellDep cellDep) {
    var outPointStruct = serializeOutPoint(cellDep.outPoint);
    var depTypeBytes = CellDep.Code == cellDep.depType
        ? Byte1.fromHex('0')
        : Byte1.fromHex('1');
    return Struct([outPointStruct, depTypeBytes]);
  }

  static Fixed<Struct> serializeCellDeps(List<CellDep> cellDeps) {
    return Fixed(cellDeps.map((cellDep) => serializeCellDep(cellDep)).toList());
  }

  static Fixed<Struct> serializeCellInputs(List<CellInput> cellInputs) {
    return Fixed(
        cellInputs.map((cellInput) => serializeCellInput(cellInput)).toList());
  }

  static Dynamic<Table> serializeCellOutputs(List<CellOutput> cellOutputs) {
    return Dynamic(cellOutputs
        ?.map((cellOutput) => serializeCellOutput(cellOutput))
        ?.toList());
  }

  static Dynamic<Bytes> serializeBytes(List<String> bytes) {
    return Dynamic(bytes.map((byte) => Bytes.fromHex(byte)).toList());
  }

  static Fixed<Byte32> serializeByte32(List<String> bytes) {
    return Fixed(bytes.map((byte) => Byte32.fromHex(byte)).toList());
  }

  static Table serializeWitnessArgs(Witness witness) {
    var list = <Option>[];
    list.add(Option(witness.lock == null? Empty() : Bytes.fromHex(witness.lock)));
    list.add(Option(witness.inputType == null? Empty() : Bytes.fromHex(witness.inputType)));
    list.add(Option(witness.outputType == null? Empty() : Bytes.fromHex(witness.outputType)));
    return Table(list);
  }

  static Dynamic<SerializeType> serializeWitnesses(List<dynamic> witnesses) {
    var witnessList = [];
    for (var witness in witnesses) {
      if (witness is Witness) {
        witnessList.add(serializeWitnessArgs(witness));
      } else {
        witnessList.add(Bytes.fromHex(witness));
      }
    }
    witnessList = witnessList.map((witness) => witness as SerializeType).toList();
    return Dynamic<SerializeType>(witnessList);
  }

  static Table serializeRawTransaction(Transaction transaction) {
    var tx = Convert.parseTransaction(transaction);

    return Table([
      UInt32.fromHex(tx?.version),
      Serializer.serializeCellDeps(tx?.cellDeps),
      Serializer.serializeByte32(tx?.headerDeps),
      Serializer.serializeCellInputs(tx?.inputs),
      Serializer.serializeCellOutputs(tx?.outputs),
      Serializer.serializeBytes(tx?.outputsData)
    ]);
  }

  static Table serializeTransaction(Transaction transaction) {
    return Table([serializeRawTransaction(transaction), serializeWitnesses(transaction.witnesses)]);
  }

}
