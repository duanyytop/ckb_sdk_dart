import 'dart:math';

import 'package:ckb_sdk_dart/ckb_addrss.dart';
import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/address/address_params.dart';
import 'package:ckb_sdk_dart/src/crypto/key.dart';
import 'package:ckb_sdk_dart/src/rpc/api.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_script_cell.dart';

import 'cell_collect.dart';

const minCapacity = "6000000000";

class TxGenerator {
  String privateKey;
  Api api;

  TxGenerator({this.privateKey, this.api});

  Future<Transaction> generateTx(List<Receiver> receivers) async {
    SystemScriptCell _systemScriptCell =
        await SystemContract.getSystemScriptCell(api);
    Script _lockScript = Key.generateLockScriptWithPrivateKey(
        privateKey, _systemScriptCell.cellHash);

    BigInt needCapacities = BigInt.zero;
    for (Receiver receiver in receivers) {
      needCapacities += receiver.capacity;
    }
    if (needCapacities.compareTo(BigInt.parse(minCapacity)) < 0) {
      throw ("Less than min capacity");
    }

    Cells cellInputs = await CellCollect.getCellInputs(
        api: api,
        lockHash: _lockScript.computeHash(),
        capacity: needCapacities);

    if (cellInputs.capacity.compareTo(needCapacities) < 0) {
      throw ("No enough Capacities");
    }

    List<CellOutput> cellOutputs = [];
    AddressGenerator generator = AddressGenerator(network: Network.testnet);
    for (Receiver receiver in receivers) {
      String blake2b = generator.blake160FromAddress(receiver.address);
      cellOutputs.add(CellOutput(
          capacity: receiver.capacity.toString(),
          lock: Script(
              codeHash: _systemScriptCell.cellHash,
              args: [blake2b],
              hashType: Script.type)));
    }

    if (cellInputs.capacity.compareTo(needCapacities) > 0) {
      cellOutputs.add(CellOutput(
          capacity: (cellInputs.capacity - needCapacities).toString(),
          lock: _lockScript));
    }

    List<Witness> witnesses = [];
    for (int i = 0; i < cellInputs.inputs.length; i++) {
      witnesses.add(Witness(data: []));
    }

    List<String> cellOutputsData = [];
    for (int i = 0; i < cellOutputs.length; i++) {
      cellOutputsData.add("0x");
    }

    Transaction transaction = Transaction(
        version: "0",
        cellDeps: [
          CellDep(
              outPoint: _systemScriptCell.outPoint, depType: CellDep.depGroup)
        ],
        headerDeps: [],
        inputs: cellInputs.inputs,
        outputs: cellOutputs,
        outputsData: cellOutputsData,
        witnesses: witnesses);

    return transaction.sign(privateKey);
  }
}

class Receiver {
  String address;
  BigInt capacity;

  Receiver(this.address, this.capacity);
}
