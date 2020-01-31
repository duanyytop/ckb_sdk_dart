import 'cell_output.dart';

class CellWithStatus {
  static String Live = 'live';
  static String Dead = 'dead';

  CellInfo cell;
  String status;

  CellWithStatus({this.cell, this.status});

  factory CellWithStatus.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return CellWithStatus(cell: CellInfo.fromJson(json['cell']), status: json['status']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'cell': cell.toJson(),
      'status': status,
    };
  }
}

class CellInfo {
  CellData data;
  CellOutput output;

  CellInfo({this.data, this.output});

  factory CellInfo.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return CellInfo(data: CellData.fromJson(json['data']), output: CellOutput.fromJson(json['output']));
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'data': data.toJson(),
      'output': output.toJson(),
    };
  }
}

class CellData {
  String content;
  String hash;

  CellData({this.content, this.hash});

  factory CellData.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return CellData(content: json['content'], hash: json['hash']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'content': content,
      'hash': hash,
    };
  }
}
