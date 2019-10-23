import 'package:ckb_sdk_dart/ckb_addrss.dart';
import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/address/address_params.dart';
import 'package:ckb_sdk_dart/src/crypto/key.dart';
import 'package:ckb_sdk_dart/src/rpc/api.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_script_cell.dart';

import 'cell_collect.dart';

class TxGenerator {
  String privateKey;
  Api api;

  TxGenerator({this.privateKey, this.api});

  Future<Transaction> generateTx({List<Receiver> receivers, BigInt fee}) async {
    if (fee == null) throw ('Transaction fee should not be null');
    SystemScriptCell systemScriptCell =
        await SystemContract.getSystemSecpCell(api: api);
    Script lockScript = await Key.generateLockScriptWithPrivateKey(
        privateKey: privateKey, codeHash: systemScriptCell.cellHash);

    BigInt needCapacity = receivers.fold(
        BigInt.zero, (previous, element) => previous + element.capacity);

    List<CellOutput> cellOutputs = [];
    AddressGenerator generator = AddressGenerator(network: Network.testnet);
    for (Receiver receiver in receivers) {
      String blake2b = generator.blake160FromAddress(receiver.address);
      cellOutputs.add(CellOutput(
          capacity: receiver.capacity.toString(),
          lock: Script(
              codeHash: systemScriptCell.cellHash,
              args: blake2b,
              hashType: Script.type)));
    }

    CellOutput changeOutput = CellOutput(capacity: '0', lock: lockScript);

    CellCollect cellCollect =
        CellCollect(api: api, lockHash: lockScript.computeHash());

    CellCollectResult collectResult = await cellCollect.gatherInputs(
        capacity: needCapacity,
        minCapacity:
            BigInt.from(cellOutputs[0].calculateByteSize(receivers[0].data)),
        minChangeCapacity: BigInt.from(changeOutput.calculateByteSize("0x")),
        fee: fee);

    List<String> outputsData =
        receivers.map((receiver) => receiver.data).toList();

    if (collectResult.capacity > (needCapacity + fee)) {
      cellOutputs.add(CellOutput(
          capacity: (collectResult.capacity - needCapacity - fee).toString(),
          lock: lockScript));
      outputsData.add("0x");
    }

    Transaction transaction = Transaction(
        version: "0",
        cellDeps: [
          CellDep(
              outPoint: systemScriptCell.outPoint, depType: CellDep.depGroup)
        ],
        headerDeps: [],
        inputs: collectResult.inputs,
        outputs: cellOutputs,
        outputsData: outputsData,
        witnesses: collectResult.witnesses);

    return transaction.sign(privateKey);
  }
}

class Receiver {
  String address;
  BigInt capacity;
  String data;

  Receiver({this.address, this.capacity, this.data = "0x"});
}
