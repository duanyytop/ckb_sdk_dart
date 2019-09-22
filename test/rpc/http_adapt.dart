import 'package:dio/dio.dart';

class MockAdapter extends HttpClientAdapter {
  DefaultHttpClientAdapter _adapter = DefaultHttpClientAdapter();

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<List<int>> requestStream, Future cancelFuture) async {
    String method = (options.data as Map)['method'];
    switch (method) {
      case 'get_tip_block_number':
        return ResponseBody.fromString(tipBlockNumber, 200);
      case 'get_block_hash':
        return ResponseBody.fromString(getBlockHash, 200);
      case 'get_block':
        return ResponseBody.fromString(getBlock, 200);
      case 'get_block_by_number':
        return ResponseBody.fromString(getBlock, 200);
      case 'get_transaction':
        return ResponseBody.fromString(getTransaction, 200);
      case 'get_cellbase_output_capacity_details':
        return ResponseBody.fromString(getCellbaseOutputCapacityDetails, 200);
      case 'get_tip_header':
        return ResponseBody.fromString(getTipHeader, 200);
      case 'get_cells_by_lock_hash':
        return ResponseBody.fromString(getCellsByLockHash, 200);
      case 'get_live_cell':
        return ResponseBody.fromString(getLiveCell, 200);
      case 'get_current_epoch':
        return ResponseBody.fromString(getCurrentEpoch, 200);
      case 'get_epoch_by_number':
        return ResponseBody.fromString(getEpochByNumber, 200);
      case 'get_header':
        return ResponseBody.fromString(getHeader, 200);
      case 'get_header_by_number':
        return ResponseBody.fromString(getHeaderByNumber, 200);
      case 'get_blockchain_info':
        return ResponseBody.fromString(getBlockchainInfo, 200);
      case 'get_peers_state':
        return ResponseBody.fromString(getPeersState, 200);
      case 'local_node_info':
        return ResponseBody.fromString(localNodeInfo, 200);
      case 'get_peers':
        return ResponseBody.fromString(getPeers, 200);
      case 'tx_pool_info':
        return ResponseBody.fromString(txPoolInfo, 200);
      case 'dry_run_transaction':
        return ResponseBody.fromString(dryRunTransaction, 200);
      case '_compute_transaction_hash':
        return ResponseBody.fromString(computeTransactionHash, 200);
      case '_compute_script_hash':
        return ResponseBody.fromString(computeScriptHash, 200);
      case 'get_transactions_by_lock_hash':
        return ResponseBody.fromString(getTransactionsByLockHash, 200);
      default:
        break;
    }
    return _adapter.fetch(options, requestStream, cancelFuture);
  }
}

const tipBlockNumber = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": "0x400"
        }''';

const getBlockHash = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": "0xc73a331428dd9ef69b8073c248bfae9dc7c27942bb1cb70581e880bd3020d7da"
        }''';

const getBlock = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": {
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
                                    "args": [],
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
                            {
                                "data": [
                                    "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a500"
                                ]
                            }
                        ]
                    }
                ],
                "uncles": []
            }
        }''';

const getTransaction = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": {
                "transaction": {
                    "cell_deps": [
                        {
                            "dep_type": "code",
                            "out_point": {
                                "index": "0x0",
                                "tx_hash": "0x29f94532fb6c7a17f13bcde5adb6e2921776ee6f357adf645e5393bd13442141"
                            }
                        }
                    ],
                    "hash": "0xba86cc2cb21832bf4a84c032eb6e8dc422385cc8f8efb84eb0bc5fe0b0b9aece",
                    "header_deps": [
                        "0x8033e126475d197f2366bbc2f30b907d15af85c9d9533253c6f0787dcbbb509e"
                    ],
                    "inputs": [
                        {
                            "previous_output": {
                                "index": "0x0",
                                "tx_hash": "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17"
                            },
                            "since": "0x0"
                        }
                    ],
                    "outputs": [
                        {
                            "capacity": "0x174876e800",
                            "lock": {
                                "args": [],
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
                    "witnesses": []
                },
                "tx_status": {
                    "block_hash": null,
                    "status": "pending"
                }
            }
        }''';

const getCellbaseOutputCapacityDetails = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": {
                "primary": "0x102b36211d",
                "proposal_reward": "0x0",
                "secondary": "0x2ca110a5",
                "total": "0x1057d731c2",
                "tx_fee": "0x0"
            }
        }''';

const getTipHeader = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": {
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
            }
        }''';

const getCellsByLockHash = '''{
             "id": 2,
              "jsonrpc": "2.0",
              "result": [
                  {
                      "block_hash": "0x03935a4b5e3c03a9c1deb93a39183a9a116c16cff3dc9ab129e847487da0e2b8",
                      "capacity": "0x1d1a94a200",
                      "lock": {
                          "args": [],
                          "code_hash": "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5",
                          "hash_type": "data"
                      },
                      "out_point": {
                          "index": "0x0",
                          "tx_hash": "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17"
                      }
                  },
                  {
                      "block_hash": "0x813edf971bf6d191335a99c52d90dcea1d2d5195386ce4898d9dfe53e81e4fcb",
                      "capacity": "0x1d1a94a200",
                      "lock": {
                          "args": [],
                          "code_hash": "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5",
                          "hash_type": "data"
                      },
                      "out_point": {
                          "index": "0x0",
                          "tx_hash": "0x2e32fd60f965075a9a532c670b6d5475a2417e88872b74069e8076e58906b7bf"
                      }
                  }
              ]
        }''';

const getLiveCell = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": {
                "cell": {
                    "data": {
                        "content": "0x7f454c460201010000000000000000000200f3000100000078000100000000004000000000000000980000000000000005000000400038000100400003000200010000000500000000000000000000000000010000000000000001000000000082000000000000008200000000000000001000000000000001459308d00573000000002e7368737472746162002e74657874000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b000000010000000600000000000000780001000000000078000000000000000a0000000000000000000000000000000200000000000000000000000000000001000000030000000000000000000000000000000000000082000000000000001100000000000000000000000000000001000000000000000000000000000000",
                        "hash": "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5"
                    },
                    "output": {
                        "capacity": "0x802665800",
                        "lock": {
                            "args": [],
                            "code_hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
                            "hash_type": "data"
                        },
                        "type": null
                    }
                },
                "status": "live"
            }
        }''';

const getCurrentEpoch = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": {
                "difficulty": "0x3e8",
                "length": "0x3e8",
                "number": "0x0",
                "start_number": "0x0"
            }
        }''';

const getEpochByNumber = '''{
             "id": 2,
            "jsonrpc": "2.0",
            "result": {
                "difficulty": "0x3e8",
                "length": "0x3e8",
                "number": "0x0",
                "start_number": "0x0"
            }
        }''';

const getHeader = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": {
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
            }
        }''';

const getHeaderByNumber = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": {
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
            }
        }''';

const getBlockchainInfo = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": {
                "alerts": [
                    {
                        "id": "0x2a",
                        "message": "An example alert message!",
                        "notice_until": "0x24bcca57c00",
                        "priority": "0x1"
                    }
                ],
                "chain": "main",
                "difficulty": "0x7a1200",
                "epoch": "0x7080018000001",
                "is_initial_block_download": true,
                "median_time": "0x5cd2b105"
            }
        }''';

const getPeersState = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": [
                {
                    "blocks_in_flight": "0x56",
                    "last_updated": "0x16a95af332d",
                    "peer": "0x1"
                }
            ]
        }''';

const localNodeInfo = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": {
                "addresses": [
                    {
                        "address": "/ip4/192.168.0.2/tcp/8112/p2p/QmTRHCdrRtgUzYLNCin69zEvPvLYdxUZLLfLYyHVY3DZAS",
                        "score": "0xff"
                    },
                    {
                        "address": "/ip4/0.0.0.0/tcp/8112/p2p/QmTRHCdrRtgUzYLNCin69zEvPvLYdxUZLLfLYyHVY3DZAS",
                        "score": "0x1"
                    }
                ],
                "is_outbound": null,
                "node_id": "QmTRHCdrRtgUzYLNCin69zEvPvLYdxUZLLfLYyHVY3DZAS",
                "version": "0.0.0"
            }
        }''';

const getPeers = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": [
                {
                    "addresses": [
                        {
                            "address": "/ip4/192.168.0.3/tcp/8115",
                            "score": "0x1"
                        }
                    ],
                    "is_outbound": true,
                    "node_id": "QmaaaLB4uPyDpZwTQGhV63zuYrKm4reyN2tF1j2ain4oE7",
                    "version": "unknown"
                },
                {
                    "addresses": [
                        {
                            "address": "/ip4/192.168.0.4/tcp/8113",
                            "score": "0xff"
                        }
                    ],
                    "is_outbound": false,
                    "node_id": "QmRuGcpVC3vE7aEoB6fhUdq9uzdHbyweCnn1sDBSjfmcbM",
                    "version": "unknown"
                },
                {
                    "addresses": [],
                    "node_id": "QmUddxwRqgTmT6tFujXbYPMLGLAE2Tciyv6uHGfdYFyDVa",
                    "version": "unknown"
                }
            ]
        }''';

const txPoolInfo = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": {
                "last_txs_updated_at": "0x0",
                "orphan": "0x0",
                "pending": "0x1",
                "proposed": "0x0",
                "total_tx_cycles": "0xc",
                "total_tx_size": "0x112"
            }
        }''';

const dryRunTransaction = '''{
              "id": 2,
              "jsonrpc": "2.0",
              "result": {
                  "cycles": "0xc"
              }
        }''';

const computeTransactionHash = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": "0xba86cc2cb21832bf4a84c032eb6e8dc422385cc8f8efb84eb0bc5fe0b0b9aece"
        }''';

const computeScriptHash = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": "0xd8753dd87c7dd293d9b64d4ca20d77bb8e5f2d92bf08234b026e2d8b1b00e7e9"
        }''';

const getTransactionsByLockHash = '''{
            "id": 2,
            "jsonrpc": "2.0",
            "result": [
                {
                    "consumed_by": null,
                    "created_by": {
                        "block_number": "0x1",
                        "index": "0x0",
                        "tx_hash": "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17"
                    }
                },
                {
                    "consumed_by": null,
                    "created_by": {
                        "block_number": "0x2",
                        "index": "0x0",
                        "tx_hash": "0x2e32fd60f965075a9a532c670b6d5475a2417e88872b74069e8076e58906b7bf"
                    }
                }
            ]
        }''';
