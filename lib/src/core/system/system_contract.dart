import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/ckb_crypto.dart';

import './system_script_cell.dart';

class SystemContract {
  static Future<Block> getGenesisBlock({Api api}) async {
    Block block = await api.getBlockByNumber("0x0");
    if (block == null) {
      throw ("Genesis block not found");
    }
    if (block.transactions.isEmpty || block.transactions.length < 2) {
      throw ("Genesis block transactions system script not found");
    }
    return block;
  }

  static Future<SystemScriptCell> getSystemSecpCell({Api api}) async {
    Block block = await getGenesisBlock(api: api);
    return SystemScriptCell(
        cellHash: block.transactions[0].outputs[1].type.computeHash(),
        outPoint: OutPoint(txHash: block.transactions[1].hash, index: "0x0"));
  }

  static Future<String> getSecpCodeHash({Api api}) async {
    return (await getSystemSecpCell(api: api)).cellHash;
  }

  static Future<SystemScriptCell> getSystemDaoCell({Api api}) async {
    Block block = await getGenesisBlock(api: api);
    return SystemScriptCell(
        cellHash: Blake2b.hash(block.transactions[0].outputsData[2]),
        outPoint: OutPoint(txHash: block.transactions[0].hash, index: "0x2"));
  }

  static Future<String> getDaoCodeHash({Api api}) async {
    return (await getSystemDaoCell(api: api)).cellHash;
  }
}
