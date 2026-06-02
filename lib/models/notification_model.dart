class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "body": body,
    "createdAt": createdAt,
  };

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["id"],
      title: json["title"],
      body: json["body"],
      createdAt: json["createdAt"],
    );
  }
}
