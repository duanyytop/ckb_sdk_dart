import '../../../ckb_type.dart';
import '../../address/address_generator.dart';
import '../../address/address_params.dart';
import '../../crypto/key.dart';
import '../api.dart';
import '../system/system_contract.dart';
import '../system/system_script_cell.dart';
import 'cell_gather.dart';
import 'cells.dart';
import 'receiver.dart';

class TxGenerator {
  static final String minCapacity = "6000000000";

  String privateKey;
  Api api;
  Script _lockScript;
  SystemScriptCell _systemScriptCell;

  TxGenerator({this.privateKey, this.api});

  Future<Transaction> generateTx(List<Receiver> receivers) async {
    _systemScriptCell = await SystemContract.getSystemScriptCell(api);
    _lockScript = Key.generateLockScriptWithPrivateKey(
        privateKey, _systemScriptCell.cellHash);

    BigInt needCapacities = BigInt.zero;
    for (Receiver receiver in receivers) {
      needCapacities += receiver.capacity;
    }
    if (needCapacities.compareTo(BigInt.parse(minCapacity)) < 0) {
      throw ("Less than min capacity");
    }

    Cells cellInputs = await CellGatherer(api: api)
        .getCellInputs(_lockScript.computeHash(), needCapacities);

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
