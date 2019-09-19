import './system_script_cell.dart';
import '../../../ckb_rpc.dart';
import '../../../ckb_type.dart';
import '../../type/block.dart';

class SystemContract {
  static Future<SystemScriptCell> getSystemScriptCell(Api api) async {
    Block block = await api.getBlockByNumber("0x0");
    if (block == null) {
      throw ("Genesis block not found");
    }
    if (block.transactions.isEmpty || block.transactions.length < 2) {
      throw ("Genesis block transactions system script not found");
    }
    return SystemScriptCell(
        cellHash: block.transactions[0].outputs[1].type.computeHash(),
        outPoint: OutPoint(txHash: block.transactions[1].hash, index: "0x0"));
  }
}
