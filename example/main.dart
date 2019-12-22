
import 'package:ckb_sdk_dart/ckb_core.dart';

void main() async {
  var api = Api('http://localhost:8114', hasLogger: true);
  var blockHash = await api.getBlockHash('0x2');
  print('blockHash: $blockHash \n');

  var block = await api.getBlock(blockHash);
  print('block: ${block.toJson()}\n');

  var tx = await api.getTransaction(block.transactions[0].hash);

  print('transaction: ${tx.toJson()}\n');
}
