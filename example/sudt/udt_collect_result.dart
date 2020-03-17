import '../transaction/cells_with_address.dart';
import '../transaction/collect_result.dart';

class UDTCollectResult extends CollectResult {
  BigInt changeUdtAmount;

  UDTCollectResult(List<CellsWithAddress> cellsWithAddresses,
      String changeCapacity, BigInt changeUdt)
      : changeUdtAmount = changeUdt,
        super(cellsWithAddresses, changeCapacity);
}
