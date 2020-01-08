import './serializer.dart';
import '../transaction.dart';

final int SERIALIZED_TX_OFFSET_BYTE_SIZE = 4;

int calculateSerializedSizeInBlock(Transaction transaction) {
  var serializedTx = Serializer.serializeTransaction(transaction);
  return serializedTx.getLength() + SERIALIZED_TX_OFFSET_BYTE_SIZE;
}

final BigInt RADIO = BigInt.from(1000);

BigInt calculateTransactionFee(BigInt transactionSize, BigInt feeRate) {
  var base = transactionSize * feeRate;
  var fee = base ~/ RADIO;
  if ((fee * RADIO).compareTo(base) < 0) {
    return fee + BigInt.one;
  }
  return fee;
}
