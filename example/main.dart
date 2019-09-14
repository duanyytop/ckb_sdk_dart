import 'package:ckb_sdk_dart/ckb_rpc.dart';
import 'package:ckb_sdk_dart/src/type/block.dart';

main() async {
  Api api = Api("http://localhost:8114", openLogger: false);
  String blockHash = await api.getBlockHash('0x2');
  Block block = await api.getBlock(blockHash);
  print(block.transactions[0].outputs[0].lock.toJson());
}
