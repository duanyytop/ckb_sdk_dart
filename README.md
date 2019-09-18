CKB SDK with Dart language.

## Prerequisites

- Dart 2.5 or later

## Installation

You should install dart first through [Dart](https://dart.dev/get-dart).

## Usage

### JSONRPC

A simple usage example of jsonrpc request:

```dart
import 'package:ckb_sdk_dart/ckb_rpc.dart';
import 'package:ckb_sdk_dart/src/type/block.dart';

main() async {
  Api api = Api("http://localhost:8114", hasLogger: false);
  String blockHash = await api.getBlockHash('0x2');
  Block block = await api.getBlock(blockHash);
  print(block.transactions[0].outputs[0].lock.toJson());
}
```

### Simple Wallet

A simple usage example of transaction:

```dart
import 'dart:async';

import 'package:ckb_sdk_dart/ckb_rpc.dart';
import 'package:ckb_sdk_dart/ckb_type.dart';
import 'package:ckb_sdk_dart/src/address/address_generator.dart';
import 'package:ckb_sdk_dart/src/address/address_params.dart';
import 'package:ckb_sdk_dart/src/crypto/key.dart';
import 'package:ckb_sdk_dart/src/rpc/transaction/cell_gather.dart';
import 'package:ckb_sdk_dart/src/rpc/transaction/receiver.dart';
import 'package:ckb_sdk_dart/src/rpc/transaction/tx_generator.dart';

main() async {
  Api api = Api("http://localhost:8114", hasLogger: false);
  String senderPrivateKey =
      "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee";

  AddressGenerator generator = AddressGenerator(network: Network.testnet);
  String publicKey = Key.publicKeyFromPrivate(senderPrivateKey);
  String senderAddress = generator.addressFromPublicKey(publicKey);
  List<Receiver> receivers = [
    Receiver("ckt1qyqqtdpzfjwq7e667ktjwnv3hngrqkmwyhhqpa8dav",
        BigInt.parse("10000000000")),
    Receiver("ckt1qyq9ngn77wagfurp29738apv738dqgrpqpssfhr0l6",
        BigInt.parse("12000000000")),
    Receiver("ckt1qyq2pmuxkr0xwx8kp3ya2juryrygf27dregs44skek",
        BigInt.parse("15000000000"))
  ];

  String balance = (await getBalance(api, senderAddress)).toString();
  print('Receiver1:  $balance');
  String hash = await sendCapacity(api, senderPrivateKey, receivers);
  print('Transaction hash: $hash');
  Timer(Duration(seconds: 10), () async {
    String balance1 = (await getBalance(api, senderAddress)).toString();
    print('Receiver1:  $balance1');
  });
}

Future<BigInt> getBalance(Api api, String address) {
  CellGatherer cellGatherer = CellGatherer(api: api);
  return cellGatherer.getCapacitiesWithAddress(address);
}

Future<String> sendCapacity(
    Api api, String privateKey, List<Receiver> receivers) async {
  TxGenerator txGenerator = TxGenerator(privateKey: privateKey, api: api);
  Transaction transaction = await txGenerator.generateTx(receivers);
  return await api.sendTransaction(transaction);
}

```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
