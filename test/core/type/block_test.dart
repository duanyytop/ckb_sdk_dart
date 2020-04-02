import 'dart:convert';

import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:test/test.dart';

void main() {
  var _block;
  group('A group tests of block', () {
    setUp(() {
      _block = '''{
        "header": {
            "dao": "0x0100000000000000005827f2ba13b000d77fa3d595aa00000061eb7ada030000",
            "difficulty": "0x7a1200",
            "epoch": "0x7080018000001",
            "hash": "0xc73a331428dd9ef69b8073c248bfae9dc7c27942bb1cb70581e880bd3020d7da",
            "nonce": "0x0",
            "number": "0x400",
            "parent_hash": "0x956315644ef52193db540709d3a34c7149cfb173e4eedcc64ee10aa366795439",
            "proposals_hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
            "timestamp": "0x5cd2b117",
            "transactions_root": "0x8ad0468383d0085e26d9c3b9b648623e4194efc53a03b7cd1a79e92700687f1e",
            "uncles_count": "0x0",
            "uncles_hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
            "version": "0x0",
            "witnesses_root": "0x90445a0795a2d7d4af033ec0282a8a1f68f11ffb1cd091b95c2c5515a8336e9c"
        },
        "proposals": [],
        "transactions": [
            {
                "cell_deps": [],
                "hash": "0x8ad0468383d0085e26d9c3b9b648623e4194efc53a03b7cd1a79e92700687f1e",
                "header_deps": [],
                "inputs": [
                    {
                        "previous_output": {
                            "index": "0xffffffff",
                            "tx_hash": "0x0000000000000000000000000000000000000000000000000000000000000000"
                        },
                        "since": "0x400"
                    }
                ],
                "outputs": [
                    {
                        "capacity": "0x1057d731c2",
                        "lock": {
                            "args": "0x",
                            "code_hash": "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5",
                            "hash_type": "data"
                        },
                        "type": null
                    }
                ],
                "outputs_data": [
                    "0x"
                ],
                "version": "0x0",
                "witnesses": [
                    "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a500"
                ]
            }
        ],
        "uncles": []
      }''';
    });

    test('fromJson', () async {
      var block = Block.fromJson(jsonDecode(_block));
      expect(block.header.hash, '0xc73a331428dd9ef69b8073c248bfae9dc7c27942bb1cb70581e880bd3020d7da');
      expect(block.transactions[0].outputs[0].lock.codeHash,
          '0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5');
      expect(
          block.transactions[0].witnesses[0], '0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a500');
    });

    test('toJson', () async {
      var block = Block.fromJson(jsonDecode(_block));
      var json = block.toJson();
      expect(json,
          '{"header":"{\\"dao\\":\\"0x0100000000000000005827f2ba13b000d77fa3d595aa00000061eb7ada030000\\",\\"compact_target\\":\\"null\\",\\"hash\\":\\"0xc73a331428dd9ef69b8073c248bfae9dc7c27942bb1cb70581e880bd3020d7da\\",\\"number\\":\\"0x400\\",\\"epoch\\":\\"0x7080018000001\\",\\"parent_hash\\":\\"0x956315644ef52193db540709d3a34c7149cfb173e4eedcc64ee10aa366795439\\",\\"nonce\\":\\"0x0\\",\\"timestamp\\":\\"0x5cd2b117\\",\\"transactions_root\\":\\"0x8ad0468383d0085e26d9c3b9b648623e4194efc53a03b7cd1a79e92700687f1e\\",\\"proposals_hash\\":\\"0x0000000000000000000000000000000000000000000000000000000000000000\\",\\"uncles_hash\\":\\"0x0000000000000000000000000000000000000000000000000000000000000000\\",\\"version\\":\\"0x0\\"}","uncles":[],"proposals":[],"transactions":["{\\"version\\":\\"0x0\\",\\"hash\\":\\"0x8ad0468383d0085e26d9c3b9b648623e4194efc53a03b7cd1a79e92700687f1e\\",\\"cell_deps\\":[],\\"header_deps\\":[],\\"inputs\\":[\\"{\\\\\\"previous_output\\\\\\":\\\\\\"{\\\\\\\\\\\\\\"tx_hash\\\\\\\\\\\\\\":\\\\\\\\\\\\\\"0x0000000000000000000000000000000000000000000000000000000000000000\\\\\\\\\\\\\\",\\\\\\\\\\\\\\"index\\\\\\\\\\\\\\":\\\\\\\\\\\\\\"0xffffffff\\\\\\\\\\\\\\"}\\\\\\",\\\\\\"since\\\\\\":\\\\\\"0x400\\\\\\"}\\"],\\"outputs\\":[\\"{\\\\\\"capacity\\\\\\":\\\\\\"0x1057d731c2\\\\\\",\\\\\\"lock\\\\\\":\\\\\\"{\\\\\\\\\\\\\\"code_hash\\\\\\\\\\\\\\":\\\\\\\\\\\\\\"0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5\\\\\\\\\\\\\\",\\\\\\\\\\\\\\"args\\\\\\\\\\\\\\":\\\\\\\\\\\\\\"0x\\\\\\\\\\\\\\",\\\\\\\\\\\\\\"hash_type\\\\\\\\\\\\\\":\\\\\\\\\\\\\\"data\\\\\\\\\\\\\\"}\\\\\\",\\\\\\"type\\\\\\":null}\\"],\\"outputs_data\\":[\\"0x\\"],\\"witnesses\\":[\\"0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a500\\"]}"]}');
    });
  });
}
