class LockHashCapacity {
  String capacity;
  String blockNumber;
  String cellsCount;

  LockHashCapacity({this.capacity, this.blockNumber, this.cellsCount});

  factory LockHashCapacity.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return LockHashCapacity(
        capacity: json['capacity'],
        blockNumber: json['block_number'],
        cellsCount: json['cells_count']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'capacity': capacity,
      'block_number': blockNumber,
      'cells_count': cellsCount,
    };
  }
}
