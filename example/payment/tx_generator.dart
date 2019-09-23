import 'package:ckb_sdk_dart/ckb_addrss.dart';
import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/address/address_params.dart';
import 'package:ckb_sdk_dart/src/crypto/key.dart';
import 'package:ckb_sdk_dart/src/rpc/api.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_script_cell.dart';
import 'package:ckb_sdk_dart/src/utils/utils.dart';

import 'cell_collect.dart';

final minCapacity = BigInt.parse("6000000000");

class TxGenerator {
  String privateKey;
  Api api;

  TxGenerator({this.privateKey, this.api});

  Future<Transaction> generateTx(
      {List<Receiver> receivers, String fee = '0'}) async {
    BigInt feeBigInt = numberToBigInt(fee);
    SystemScriptCell _systemScriptCell =
        await SystemContract.getSystemScriptCell(api);
    Script _lockScript = Key.generateLockScriptWithPrivateKey(
        privateKey, _systemScriptCell.cellHash);

    BigInt needCapacity = receivers.fold(
        BigInt.zero, (previous, element) => previous + element.capacity);

    if (needCapacity < minCapacity) {
      throw ("Less than min capacity");
    }

    CellCollect cellCollect =
        CellCollect(api: api, lockHash: _lockScript.computeHash());

    CellCollectContainer collectContainer = await cellCollect.gatherInputs(
        capacity: needCapacity, minCapacity: minCapacity, fee: feeBigInt);

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

    List<String> outputsData =
        receivers.map((receiver) => receiver.data).toList();

    if (collectContainer.capacity > (needCapacity + feeBigInt)) {
      cellOutputs.add(CellOutput(
          capacity:
              (collectContainer.capacity - needCapacity - feeBigInt).toString(),
          lock: _lockScript));
      outputsData.add('0x');
    }

    Transaction transaction = Transaction(
        version: "0",
        cellDeps: [
          CellDep(
              outPoint: _systemScriptCell.outPoint, depType: CellDep.depGroup)
        ],
        headerDeps: [],
        inputs: collectContainer.inputs,
        outputs: cellOutputs,
        outputsData: outputsData,
        witnesses: collectContainer.witnesses);

    return transaction.sign(privateKey);
  }
}

class Receiver {
  String address;
  BigInt capacity;
  String data;

  Receiver({this.address, this.capacity, this.data = '0x'});
}
