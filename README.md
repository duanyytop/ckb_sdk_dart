# CKB SDK Dart

[![License](https://img.shields.io/badge/license-MIT-green)](https://github.com/nervosnetwork/ckb-sdk-java/blob/develop/LICENSE)
[![CircleCI](https://circleci.com/gh/duanyytop/ckb_sdk_dart/tree/master.svg?style=svg)](https://circleci.com/gh/duanyytop/ckb_sdk_dart/tree/master)
[![Platform](https://img.shields.io/badge/Platforms-Flutter%20%7C%20Dart_VM-4e4e4e.svg?colorA=28a745)](#installation)
[![codecov](https://codecov.io/gh/duanyytop/ckb_sdk_dart/branch/master/graph/badge.svg)](https://codecov.io/gh/duanyytop/ckb_sdk_dart)

Dart SDK for [Nervos CKB](https://github.com/nervosnetwork/ckb)

## Prerequisites

- Dart 2.5 or later

## Installation

You should install dart firstly through [Dart](https://dart.dev/get-dart).

## Usage

### JSONRPC

A simple usage example of jsonrpc request which in `example/rpc.dart`:

```dart
main() async {
  Api api = Api("http://localhost:8114", hasLogger: false);
  String blockHash = await api.getBlockHash('0x2');
  Block block = await api.getBlock(blockHash);
  print(block.transactions[0].outputs[0].lock.toJson());
}
```

### Simple Wallet example

A simple usage example of `sendTransaction` which is in `example/wallet.dart`:

```dart

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
  String hash = await sendCapacity(api, senderPrivateKey, receivers);
  print('Transaction hash: $hash');
  Timer(Duration(seconds: 10), () async {
    String balance1 = (await getBalance(api, senderAddress)).toString();
    print('Receiver1:  $balance1');
  });
}

```

## Development

If you want to develop by yourself, you can download this project to your local.

```shell
git clone https://github.com/duanyytop/ckb_sdk_dart.git
cd ckb_sdk_dart

pub get                       // download and install dependences
pub run test                  // run sdk unit tests

dart ./example/rpc.dart       // run rpc request example, you should run a ckb node in your local
dart ./example/wallet.dart    // run simple wallet example, you should run a ckb node in your local
```

## Features and bugs

Please create pull requests or issues in this GitHub repo if you want to contribute new features or find bugs.

Welcome to join us. Thanks.
