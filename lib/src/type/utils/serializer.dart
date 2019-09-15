import 'dart:core';

import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/serialization/base/fixed_type.dart';
import 'package:ckb_sdk_dart/src/serialization/dynamic/bytes.dart';
import 'package:ckb_sdk_dart/src/serialization/dynamic/dynamic.dart';
import 'package:ckb_sdk_dart/src/serialization/dynamic/table.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/byte1.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/byte32.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/empty.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/fixed.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/struct.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/uint32.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/uint64.dart';

class Serializer {
  static Struct serializeOutPoint(OutPoint outPoint) {
    Byte32 txHash = Byte32.fromHex(outPoint.txHash);
    Uint32 index = Uint32.fromHex(outPoint.index);
    return Struct(<FixedType>[txHash, index]);
  }

  static Table serializeScript(Script script) {
    List<Bytes> args = script.args.map((arg) => Bytes.fromHex(arg)).toList();
    return Table([
      Byte32.fromHex(script.codeHash),
      Byte1.fromHex(Script.data == script.hashType ? "00" : "01"),
      Dynamic(args)
    ]);
  }

  static Struct serializeCellInput(CellInput cellInput) {
    Uint64 sinceUInt64 = Uint64.fromHex(cellInput.since);
    Struct outPointStruct = serializeOutPoint(cellInput.previousOutput);
    return Struct(<FixedType>[sinceUInt64, outPointStruct]);
  }

  static Table serializeCellOutput(CellOutput cellOutput) {
    return Table([
      Uint64.fromHex(cellOutput.capacity),
      serializeScript(cellOutput.lock),
      cellOutput.type != null ? serializeScript(cellOutput.type) : Empty()
    ]);
  }

  static Struct serializeCellDep(CellDep cellDep) {
    Struct outPointStruct = serializeOutPoint(cellDep.outPoint);
    Byte1 depTypeBytes = CellDep.code == cellDep.depType
        ? Byte1.fromHex("0")
        : Byte1.fromHex("1");
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
    return Dynamic(
        cellOutputs.map((cellOutput) => serializeCellOutput(cellOutput)));
  }

  static Dynamic<Bytes> serializeBytes(List<String> bytes) {
    return Dynamic(bytes.map((byte) => Bytes.fromHex(byte)));
  }

  static Fixed<Byte32> serializeByte32(List<String> bytes) {
    return Fixed(bytes.map((byte) => Byte32.fromHex(byte)));
  }

  static Table serializeTransaction(Transaction transaction) {
    Uint32 versionUInt32 = Uint32.fromHex(transaction.version);
    Fixed<Struct> cellDepFixed =
        Serializer.serializeCellDeps(transaction.cellDeps);
    Fixed<Byte32> headerDepFixed =
        Serializer.serializeByte32(transaction.headerDeps);
    Fixed<Struct> inputsFixed =
        Serializer.serializeCellInputs(transaction.inputs);
    Dynamic<Table> outputsVec =
        Serializer.serializeCellOutputs(transaction.outputs);
    Dynamic<Bytes> dataVec = Serializer.serializeBytes(transaction.outputsData);
    return Table([
      versionUInt32,
      cellDepFixed,
      headerDepFixed,
      inputsFixed,
      outputsVec,
      dataVec
    ]);
  }
}
