import 'dart:async';

import 'package:ckb_sdk_dart/ckb_rpc.dart';
import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/address/address_generator.dart';
import 'package:ckb_sdk_dart/src/address/address_params.dart';
import 'package:ckb_sdk_dart/src/crypto/key.dart';

import 'payment/cell_collect.dart';
import 'payment/tx_generator.dart';

main() async {
  Api api = Api("http://localhost:8114", hasLogger: false);
  String senderPrivateKey =
      "e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3";

  AddressGenerator generator = AddressGenerator(network: Network.testnet);
  String publicKey = Key.publicKeyFromPrivate(senderPrivateKey);
  String senderAddress = generator.addressFromPublicKey(publicKey);
  List<Receiver> receivers = [
    Receiver(
        address: "ckt1qyqqtdpzfjwq7e667ktjwnv3hngrqkmwyhhqpa8dav",
        capacity: BigInt.parse("10000000000")),
    Receiver(
        address: "ckt1qyq9ngn77wagfurp29738apv738dqgrpqpssfhr0l6",
        capacity: BigInt.parse("12000000000")),
    Receiver(
        address: "ckt1qyq2pmuxkr0xwx8kp3ya2juryrygf27dregs44skek",
        capacity: BigInt.parse("15000000000"))
  ];

  String balance = (await getBalance(api, senderAddress)).toString();
  print('Receiver1:  $balance');
  String hash = await sendCapacity(api, senderPrivateKey, receivers, BigInt.from(10000));
  print('Transaction hash: $hash');
  Timer(Duration(seconds: 10), () async {
    String balance1 = (await getBalance(api, senderAddress)).toString();
    print('Receiver1:  $balance1');
  });
}

Future<BigInt> getBalance(Api api, String address) async {
  Script lockScript =
      await Key.generateLockScriptWithAddress(address: address, api: api);
  CellCollect cellCollect =
      CellCollect(api: api, lockHash: lockScript.computeHash());
  return cellCollect.getBalance();
}

Future<String> sendCapacity(
    Api api, String privateKey, List<Receiver> receivers, BigInt fee) async {
  TxGenerator txGenerator = TxGenerator(privateKey: privateKey, api: api);
  Transaction transaction = await txGenerator.generateTx(receivers: receivers, fee: fee);
  return await api.sendTransaction(transaction);
}
