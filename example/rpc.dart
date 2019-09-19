import 'package:ckb_sdk_dart/ckb_rpc.dart';
import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/type/block.dart';

main() async {
  Api api = Api("http://localhost:8114", hasLogger: true);
  String blockHash = await api.getBlockHash('0x2');
  Block block = await api.getBlock(blockHash);
  print('block: ${block.toJson()}\n');

  TransactionWithStatus tx =
      await api.getTransaction(block.transactions[0].hash);

  print('transaction: ${tx.toJson()}\n');

}
