import './serializer.dart';
import '../../serialization/dynamic/table.dart';
import '../transaction.dart';

final int SERIALIZED_TX_OFFSET_BYTE_SIZE = 4;

int calculateSerializedSizeInBlock(Transaction transaction) {
  Table serializedTx = Serializer.serializeTransaction(transaction);
  return serializedTx.getLength() + SERIALIZED_TX_OFFSET_BYTE_SIZE;
}

final BigInt RADIO = BigInt.from(1000);

BigInt calculateTransactionFee(BigInt transactionSize, BigInt feeRate) {
  BigInt base = transactionSize * feeRate;
  BigInt fee = base ~/ RADIO;
  if ((fee * RADIO).compareTo(base) < 0) {
    return fee + BigInt.one;
  }
  return fee;
}
