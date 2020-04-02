import 'dart:convert';

class LockHashCapacity {
  String capacity;
  String blockNumber;
  String cellsCount;

  LockHashCapacity({this.capacity, this.blockNumber, this.cellsCount});

  factory LockHashCapacity.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return LockHashCapacity(
        capacity: json['capacity'], blockNumber: json['block_number'], cellsCount: json['cells_count']);
  }

  String toJson() {
    return jsonEncode({
      'capacity': capacity,
      'block_number': blockNumber,
      'cells_count': cellsCount,
    });
  }
}
