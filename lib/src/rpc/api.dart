import 'dart:async';

import '../type/banned_address.dart';
import '../type/blockchain_info.dart';
import '../type/cell.dart';
import '../type/cell_transaction.dart';
import '../type/cycles.dart';
import '../type/epoch.dart';
import '../type/live_cell.dart';
import '../type/lock_hash_index_state.dart';
import '../type/node_info.dart';
import '../type/out_point.dart';
import '../type/peer_state.dart';
import '../type/script.dart';
import '../type/tx_pool_info.dart';
import '../type/block.dart';
import '../type/cell_output_with_out_point.dart';
import '../type/cellbase_output_capacity.dart';
import '../type/header.dart';
import '../type/transaction.dart';

import './rpc.dart';

class Api {
  Rpc _rpc;

  Api(String nodeUrl, {openLogger = false}) {
    _rpc = Rpc(nodeUrl, openLogger: openLogger);
  }

  // Chain RPC

  Future<String> getTipBlockNumber() async {
    return await _rpc.post("get_tip_block_number", []);
  }

  Future<String> getBlockHash(String number) async {
    return await _rpc.post("get_block_hash", [number]);
  }

  Future<Block> getBlock(String hash) async {
    return Block.fromJson(await _rpc.post("get_block", [hash]));
  }

  Future<Block> getBlockByNumber(String number) async {
    return Block.fromJson(await _rpc.post("get_block_by_number", [number]));
  }

  Future<Transaction> getTransaction(String hash) async {
    return Transaction.fromJson(await _rpc.post("get_transaction", [hash]));
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
      String lockHash, String fromNumber, String toNumber) async {
    return List.from(await _rpc
            .post("get_cells_by_lock_hash", [lockHash, fromNumber, toNumber]))
        .map((cellOutput) => CellOutputWithOutPoint.fromJson(cellOutput))
        .toList();
  }

  Future<Cell> getLiveCell(OutPoint outPoint) async {
    return Cell.fromJson(await _rpc.post("get_live_cell", [outPoint]));
  }

  Future<Epoch> getCurrentEpoch() async {
    return Epoch.fromJson(await _rpc.post("get_current_epoch", []));
  }

  Future<Epoch> getEpochByNumber(String epochNumber) async {
    return Epoch.fromJson(
        await _rpc.post("get_epoch_by_number", [epochNumber]));
  }

  Future<Header> getHeader(String blockHash) async {
    return Header.fromJson(await _rpc.post("get_header", [blockHash]));
  }

  Future<Header> getHeaderByNumber(String blockNumber) async {
    return Header.fromJson(
        await _rpc.post("get_header_by_number", [blockNumber]));
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
    return await _rpc.post("send_transaction", [transaction]);
  }

  // Experiment RPC
  Future<Cycles> dryRunTransaction(Transaction transaction) async {
    return Cycles.fromJson(
        await _rpc.post("dry_run_transaction", [transaction]));
  }

  Future<String> computeTransactionHash(Transaction transaction) async {
    return await _rpc.post("_compute_transaction_hash", [transaction]);
  }

  Future<String> computeScriptHash(Script script) async {
    return await _rpc.post("_compute_script_hash", [script]);
  }

  Future<String> calculateDaoMaximumWithdraw(
      OutPoint outPoint, String withdrawBlockHash) async {
    return await _rpc
        .post("calculate_dao_maximum_withdraw", [outPoint, withdrawBlockHash]);
  }

  // Indexer RPC
  Future<LockHashIndexState> indexLockHash(String lockHash,
      {String blockNumber}) async {
    return LockHashIndexState.fromJson(await _rpc.post("index_lock_hash",
        blockNumber == null ? [lockHash] : [lockHash, blockNumber]));
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
            [lockHash, page, pageSize, reverseOrder]))
        .map((liveCell) => LiveCell.fromJson(liveCell))
        .toList();
  }

  Future<List<CellTransaction>> getTransactionsByLockHash(
      String lockHash, String page, String pageSize, bool reverseOrder) async {
    return List.from(await _rpc.post("get_transactions_by_lock_hash",
            [lockHash, page, pageSize, reverseOrder]))
        .map((cellTransaction) => CellTransaction.fromJson(cellTransaction))
        .toList();
  }
}
