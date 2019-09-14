class AlertMessage {
  String id;
  String priority;
  String noticeUtil;
  String message;

  AlertMessage({this.id, this.priority, this.noticeUtil, this.message});

  factory AlertMessage.fromJson(Map<String, dynamic> json) {
    return AlertMessage(
        id: json['id'],
        priority: json['priority'],
        noticeUtil: json['notice_until'],
        message: json['message']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'priority': priority,
      'notice_until': noticeUtil,
      'message': message,
    };
  }
}
