class AppNotification {
  final int notificationId;
  final int? userId;
  final String? title;
  final String? content;
  final DateTime? timestamp;

  AppNotification({
    required this.notificationId,
    this.userId,
    this.title,
    this.content,
    this.timestamp,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      notificationId: json['notificationId'],
      userId: json['userId'],
      title: json['title'],
      content: json['content'],
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
    );
  }
}
