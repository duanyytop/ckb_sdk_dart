import 'package:ckb_sdk_dart/ckb_core.dart';
import 'package:ckb_sdk_dart/ckb_utils.dart';
import 'package:ckb_sdk_dart/src/core/transaction/script_group.dart';
import 'package:ckb_sdk_dart/src/core/transaction/secp256k1_sighash_all_builder.dart';
import 'package:ckb_sdk_dart/src/core/transaction/transaction_builder.dart';
import 'package:ckb_sdk_dart/src/core/type/witness.dart';
import 'package:ckb_sdk_dart/src/crypto/key.dart';
import 'package:ckb_sdk_dart/src/crypto/sign.dart';
import 'package:ckb_sdk_dart/src/serialization/fixed/uint128.dart';

import 'sudt/udt_cell_collector.dart';
import 'transaction/collect_utils.dart';
import 'transaction/receiver.dart';
import 'transaction/script_group_with_private_keys.dart';

final String SUDT_CODE_HASH =
    '0x48dbf59b4c7ee1547238021b4869bceedf4eea6b43772e5d66ef8865b6ae7212';
final String SUDT_OUT_POINT_TX_HASH =
    '0x78fbb1d420d242295f8668cb5cf38869adac3500f6d4ce18583ed42ff348fa64';
final String OUTPUTS_DATE_PLACEHOLDER = '00000000000000000000000000000000';
final BigInt SUDT_MIN_CELL_CAPACITY = ckbToShannon(number: 142);
final BigInt SUDT_ISSUE_CELL_CAPACITY = ckbToShannon(number: 1000);
final String ReceiveAddress = 'ckt1qyqxgp7za7dajm5wzjkye52asc8fxvvqy9eqlhp82g';
final String TestPrivateKey =
    'd00c06bfd800d27397002dca6fb0993d5ba6399b4238b2f29ee9deb97593d2bc';
final String TestAddress = 'ckt1qyqvsv5240xeh85wvnau2eky8pwrhh4jr8ts8vyj37';

final String NODE_URL = 'http://localhost:8114';
Api api;

void main() async {
  api = Api(NODE_URL, hasLogger: false);
  print('Tip block number: ${await api.getTipBlockNumber()}');
  var udtType = Script(
      codeHash: SUDT_CODE_HASH,
      args: generateLockScriptWithAddress(TestAddress).computeHash(),
      hashType: Script.Data);

  var balance = await _getUdtBalance(TestAddress, udtType.computeHash());
  print('Balance: $balance');

//  var transferHash = await _transfer(BigInt.from(100000), udtType);
//  print('UDT transfer hash: $transferHash');
}

Future<String> _getUdtBalance(String address, String typeHash) async {
  return (await UDTCellCollector(api)
          .getUdtBalanceWithAddress(address, typeHash))
      .toString();
}

Future<String> _transfer(BigInt udtAmount, Script udtType) async {
  var scriptGroupWithPrivateKeysList = [];

  var txBuilder = TransactionBuilder(api);
  var txUtils = CollectUtils(api);

  var receiver = Receiver(ReceiveAddress, SUDT_MIN_CELL_CAPACITY);
  var cellOutputs = txUtils.generateOutputs([receiver], TestAddress);

  for (var output in cellOutputs) {
    output.type = udtType;
  }
  txBuilder.addOutputs(cellOutputs);

  var cellOutputsData = [
    listToHex(UInt128(udtAmount).toBytes()),
    listToHex(UInt128.fromHex(OUTPUTS_DATE_PLACEHOLDER).toBytes())
  ];
  txBuilder.setOutputsData(cellOutputsData);

  txBuilder.addCellDep(CellDep(
      outPoint: OutPoint(txHash: SUDT_OUT_POINT_TX_HASH, index: '0x0'),
      depType: CellDep.Code));

  // You can get fee rate by rpc or set a simple number
  // BigInteger feeRate = Numeric.toBigInt(api.estimateFeeRate("5").feeRate);
  var feeRate = BigInt.from(1024);

  // initial_length = 2 * secp256k1_signature_byte.length
  var result = await UDTCellCollector(api).collectInputs(
      [TestAddress],
      txBuilder.buildTx(),
      feeRate,
      Sign.SIGN_LENGTH * 2,
      udtType.computeHash(),
      udtAmount);

  // update change output capacity after collecting cells
  cellOutputs[1].capacity = result.changeCapacity;

  txBuilder.setOutputs(cellOutputs);

  cellOutputsData[1] = listToHex(UInt128(result.changeUdtAmount).toBytes());
  txBuilder.setOutputsData(cellOutputsData);

  var startIndex = 0;
  for (var cellsWithAddress in result.cellsWithAddresses) {
    txBuilder.addInputs(cellsWithAddress.inputs);
    for (var i = 0; i < cellsWithAddress.inputs.length; i++) {
      txBuilder.addWitness(
          i == 0 ? Witness(lock: Witness.SIGNATURE_PLACEHOLDER) : '0x');
    }
    scriptGroupWithPrivateKeysList.add(ScriptGroupWithPrivateKeys(
        ScriptGroup(regionToList(startIndex, cellsWithAddress.inputs.length)),
        [TestPrivateKey]));
    startIndex += cellsWithAddress.inputs.length;
  }

  var signBuilder = Secp256k1SighashAllBuilder(txBuilder.buildTx());

  for (var scriptGroupWithPrivateKeys in scriptGroupWithPrivateKeysList) {
    signBuilder.sign(scriptGroupWithPrivateKeys.scriptGroup,
        scriptGroupWithPrivateKeys.privateKeys[0]);
  }
  return api.sendTransaction(signBuilder.buildTx());
}
