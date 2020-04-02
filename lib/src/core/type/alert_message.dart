import 'dart:convert';

class AlertMessage {
  String id;
  String priority;
  String noticeUtil;
  String message;

  AlertMessage({this.id, this.priority, this.noticeUtil, this.message});

  factory AlertMessage.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return AlertMessage(
        id: json['id'], priority: json['priority'], noticeUtil: json['notice_until'], message: json['message']);
  }

  String toJson() {
    return jsonEncode({
      'id': id,
      'priority': priority,
      'notice_until': noticeUtil,
      'message': message,
    });
  }
}
