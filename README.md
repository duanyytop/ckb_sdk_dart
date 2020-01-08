# CKB SDK Dart

[![License](https://img.shields.io/badge/license-MIT-green)](https://github.com/nervosnetwork/ckb-sdk-java/blob/develop/LICENSE)
[![Pub](https://img.shields.io/pub/v/ckb_sdk_dart.svg)](https://pub.dev/packages/ckb_sdk_dart)
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
  Api api = Api('http://localhost:8114', hasLogger: false);
  String blockHash = await api.getBlockHash('0x2');
  Block block = await api.getBlock(blockHash);
  print(block.transactions[0].outputs[0].lock.toJson());
}
```

### Simple Wallet example

A simple usage example of `sendTransaction` which is in `example/wallet.dart`:

```dart

main() async {
    api = Api(NODE_URL);

    print('Before transferring, sender\'s balance: ${await getBalance(TestAddress)} CKB');

    print('Before transferring, first receiver\'s balance: ${await getBalance(ReceiveAddresses[0])} CKB');

    print('Before transferring, change address\'s balance: ${await getBalance(changeAddress)} CKB');

    var hash = await sendCapacity(receivers, changeAddress);
    print('Transaction hash: $hash');

    // waiting transaction into block, sometimes you should wait more seconds
    sleep(Duration(seconds: 30));

    print('After transferring, sender\'s balance: ${await getBalance(TestAddress)} CKB');

    print('After transferring, receiver\'s balance: ${await getBalance(ReceiveAddresses[0])} CKB');

    print('After transferring, change address\'s balance: ${await getBalance(changeAddress)} CKB');
}

```

## Development

If you want to develop by yourself, you can download this project to your local.

```shell
git clone https://github.com/duanyytop/ckb_sdk_dart.git
cd ckb_sdk_dart

pub get                       // download and install dependences
pub run test                  // run sdk unit tests

dart ./example/main.dart       // run rpc request example, you should run a ckb node in your local
dart ./example/single_key_single_sig_tx_example.dart    // run simple transaction example, you should run a ckb node in your local
dart ./example/multi_key_single_sig_tx_example.dart    // run multi keys transaction example, you should run a ckb node in your local
```

## Features and bugs

Please create pull requests or issues in this GitHub repo if you want to contribute new features or find bugs.

Welcome to join us. Thanks.
