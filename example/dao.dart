import 'package:ckb_sdk_dart/src/rpc/api.dart';
import 'package:ckb_sdk_dart/src/type/out_point.dart';
import 'package:ckb_sdk_dart/src/type/transaction.dart';

import 'payment/nervos_dao.dart';

Api api;
const String privateKey =
    "e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3";

main() async {
  api = Api("http://localhost:8114", hasLogger: false);
  OutPoint outPoint = await depositToDao();
  print(outPoint.toJson());

  // you should wait 7200 blocks(180 epoch) to withdraw capacity from dao.

  String hash = await withdrawFromDao(OutPoint(
      txHash:
          '0x7627a84badeb04ad90e3b0d28bc852376ea7525e2c02a338d4cb2e4435e872d9',
      index: '0'));
  print(hash);
}

Future<OutPoint> depositToDao() async {
  NervosDao nervosDao = NervosDao(api: api);
  return await nervosDao.depositToDao(privateKey, BigInt.parse('100000000000'));
}

Future<String> withdrawFromDao(OutPoint outPoint) async {
  NervosDao nervosDao = NervosDao(api: api);
  Transaction tx = await nervosDao.generateWithdrawFromDaoTx(privateKey, outPoint);
  String hash = await api.sendTransaction(tx);
  return hash;
}
