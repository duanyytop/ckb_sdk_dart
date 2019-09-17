import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/address/address_generator.dart';
import 'package:ckb_sdk_dart/src/rpc/api.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_contract.dart';
import 'package:ckb_sdk_dart/src/rpc/system/system_script_cell.dart';
import 'package:ckb_sdk_dart/src/rpc/transaction/cell_gather.dart';
import 'package:ckb_sdk_dart/src/rpc/transaction/cells.dart';
import 'package:ckb_sdk_dart/src/rpc/transaction/receiver.dart';
import 'package:ckb_sdk_dart/src/rpc/transaction/tx_utils.dart';

class TxGenerator {
  static final String minCapacity = "6000000000";

  String _privateKey;
  Script _lockScript;
  SystemScriptCell _systemScriptCell;
  Api _api;

  TxGenerator(String privateKey, Api api) {
    _privateKey = privateKey;
    _api = api;

    SystemContract.getSystemScriptCell(api)
        .then((response) => _systemScriptCell = response);
    _lockScript = TxUtils.generateLockScriptWithPrivateKey(
        privateKey, _systemScriptCell.cellHash);
  }

  Future<Transaction> generateTx(List<Receiver> receivers) async {
    BigInt needCapacities = BigInt.zero;
    for (Receiver receiver in receivers) {
      needCapacities += receiver.capacity;
    }
    if (needCapacities.compareTo(BigInt.parse(minCapacity)) < 0) {
      throw ("Less than min capacity");
    }

    Cells cellInputs = await CellGatherer(api: _api)
        .getCellInputs(_lockScript.computeHash(), needCapacities);
    if (cellInputs.capacity.compareTo(needCapacities) < 0) {
      throw ("No enough Capacities");
    }

    List<CellOutput> cellOutputs = [];
    AddressGenerator generator = AddressGenerator(network: Network.Testnet);
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
      witnesses.add(Witness());
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

    return transaction.sign(_privateKey);
  }
}
