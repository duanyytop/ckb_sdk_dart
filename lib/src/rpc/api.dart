import 'dart:async';

import 'package:dio/dio.dart';

import './rpc.dart';
import '../../ckb_type.dart';
import '../type/banned_address.dart';
import '../type/block.dart';
import '../type/blockchain_info.dart';
import '../type/cell_output_with_out_point.dart';
import '../type/cell_transaction.dart';
import '../type/cell_with_status.dart';
import '../type/cellbase_output_capacity.dart';
import '../type/cycles.dart';
import '../type/epoch.dart';
import '../type/header.dart';
import '../type/live_cell.dart';
import '../type/lock_hash_index_state.dart';
import '../type/node_info.dart';
import '../type/out_point.dart';
import '../type/peer_state.dart';
import '../type/script.dart';
import '../type/transaction.dart';
import '../type/tx_pool_info.dart';
import '../type/utils/convert.dart';
import '../utils/utils.dart';

class Api {
  Rpc _rpc;
  HttpClientAdapter adapter;

  Api(String nodeUrl, {hasLogger = false, this.adapter}) {
    _rpc = Rpc(nodeUrl, hasLogger: hasLogger);
    if (adapter != null) {
      _rpc.dio.httpClientAdapter = adapter;
    }
  }

  // Chain RPC
  Future<String> getTipBlockNumber() async {
    return await _rpc.post("get_tip_block_number", []);
  }

  Future<String> getBlockHash(String number) async {
    return await _rpc.post("get_block_hash", [toHexString(number)]);
  }

  Future<Block> getBlock(String hash) async {
    return Block.fromJson(await _rpc.post("get_block", [hash]));
  }

  Future<Block> getBlockByNumber(String number) async {
    return Block.fromJson(
        await _rpc.post("get_block_by_number", [toHexString(number)]));
  }

  Future<TransactionWithStatus> getTransaction(String hash) async {
    return TransactionWithStatus.fromJson(
        await _rpc.post("get_transaction", [hash]));
  }

  Future<CellbaseOutputCapacity> getCellbaseOutputCapacityDetails(
      String blockHash) async {
    return CellbaseOutputCapacity.fromJson(
        await _rpc.post("get_cellbase_output_capacity_details", [blockHash]));
  }

  Future<Header> getTipHeader() async {
    return Header.fromJson(await _rpc.post("get_tip_header", []));
  }

  Future<List<CellOutputWithOutPoint>> getCellsByLockHash(
      {String lockHash, String fromNumber, String toNumber}) async {
    return List.from(await _rpc.post("get_cells_by_lock_hash",
            [lockHash, toHexString(fromNumber), toHexString(toNumber)]))
        .map((cellOutput) => CellOutputWithOutPoint.fromJson(cellOutput))
        .toList();
  }

  Future<CellWithStatus> getLiveCell(
      {OutPoint outPoint, bool withData = false}) async {
    return CellWithStatus.fromJson(await _rpc.post("get_live_cell",
        [Convert.parseOutPoint(outPoint)?.toJson(), withData]));
  }

  Future<Epoch> getCurrentEpoch() async {
    return Epoch.fromJson(await _rpc.post("get_current_epoch", []));
  }

  Future<Epoch> getEpochByNumber(String epochNumber) async {
    return Epoch.fromJson(
        await _rpc.post("get_epoch_by_number", [toHexString(epochNumber)]));
  }

  Future<Header> getHeader(String blockHash) async {
    return Header.fromJson(await _rpc.post("get_header", [blockHash]));
  }

  Future<Header> getHeaderByNumber(String blockNumber) async {
    return Header.fromJson(
        await _rpc.post("get_header_by_number", [toHexString(blockNumber)]));
  }

  // Stats RPC

  Future<BlockchainInfo> getBlockchainInfo() async {
    return BlockchainInfo.fromJson(await _rpc.post("get_blockchain_info", []));
  }

  Future<List<PeerState>> getPeersState() async {
    return List.from(await _rpc.post("get_peers_state", []))
        .map((peerState) => PeerState.fromJson(peerState))
        .toList();
  }

  // Net RPC
  Future<String> setBan(String address, String command, String banTime,
      bool absolute, String reason) async {
    return await _rpc
        .post("set_ban", [address, command, banTime, absolute, reason]);
  }

  Future<List<BannedAddress>> getBannedAddress() async {
    return List.from(await _rpc.post("get_banned_address", []))
        .map((bannedAddress) => BannedAddress.fromJson(bannedAddress))
        .toList();
  }

  Future<NodeInfo> localNodeInfo() async {
    return NodeInfo.fromJson(await _rpc.post("local_node_info", []));
  }

  Future<List<NodeInfo>> getPeers() async {
    return List.from(await _rpc.post("get_peers", []))
        .map((nodeInfo) => NodeInfo.fromJson(nodeInfo))
        .toList();
  }

  // Pool RPC
  Future<TxPoolInfo> txPoolInfo() async {
    return TxPoolInfo.fromJson(await _rpc.post("tx_pool_info", []));
  }

  Future<String> sendTransaction(Transaction transaction) async {
    return await _rpc.post("send_transaction",
        [Convert.parseTransaction(transaction).toRawJson()]);
  }

  // Experiment RPC
  Future<Cycles> dryRunTransaction(Transaction transaction) async {
    return Cycles.fromJson(await _rpc.post("dry_run_transaction",
        [Convert.parseTransaction(transaction).toRawJson()]));
  }

  Future<String> computeTransactionHash(Transaction transaction) async {
    return await _rpc.post("_compute_transaction_hash",
        [Convert.parseTransaction(transaction).toRawJson()]);
  }

  Future<String> computeScriptHash(Script script) async {
    return await _rpc.post("_compute_script_hash", [script]);
  }

  Future<String> calculateDaoMaximumWithdraw(
      OutPoint outPoint, String withdrawBlockHash) async {
    return await _rpc.post("calculate_dao_maximum_withdraw",
        [Convert.parseOutPoint(outPoint), withdrawBlockHash]);
  }

  // Indexer RPC
  Future<LockHashIndexState> indexLockHash(String lockHash,
      {String blockNumber}) async {
    return LockHashIndexState.fromJson(await _rpc.post(
        "index_lock_hash",
        blockNumber == null
            ? [lockHash]
            : [lockHash, toHexString(blockNumber)]));
  }

  Future<List<String>> deindexLockHash(String lockHash) async {
    return List<String>.from(await _rpc.post("deindex_lock_hash", [lockHash]));
  }

  Future<List<LockHashIndexState>> getLockHashIndexStates() async {
    return List.from(await _rpc.post("get_lock_hash_index_states", []))
        .map((lockHash) => LockHashIndexState.fromJson(lockHash))
        .toList();
  }

  Future<List<LiveCell>> getLiveCellsByLockHash(
      String lockHash, String page, String pageSize, bool reverseOrder) async {
    return List.from(await _rpc.post("get_live_cells_by_lock_hash",
            [lockHash, toHexString(page), toHexString(pageSize), reverseOrder]))
        .map((liveCell) => LiveCell.fromJson(liveCell))
        .toList();
  }

  Future<List<CellTransaction>> getTransactionsByLockHash(
      String lockHash, String page, String pageSize, bool reverseOrder) async {
    return List.from(await _rpc.post("get_transactions_by_lock_hash",
            [lockHash, toHexString(page), toHexString(pageSize), reverseOrder]))
        .map((cellTransaction) => CellTransaction.fromJson(cellTransaction))
        .toList();
  }
}
