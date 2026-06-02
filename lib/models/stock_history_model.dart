class StockHistoryModel {
  final String id;
  final String barangId;
  final String barangName;
  final int qty;
  final String userId;
  final String userName;
  final String date;

  StockHistoryModel({
    required this.id,
    required this.barangId,
    required this.barangName,
    required this.qty,
    required this.userId,
    required this.userName,
    required this.date,
  });

  factory StockHistoryModel.fromJson(Map<String, dynamic> json, String id) {
    return StockHistoryModel(
      id: id,
      barangId: json["barangId"],
      barangName: json["barangName"],
      qty: json["qty"],
      userId: json["userId"],
      userName: json["userName"],
      date: json["date"],
    );
  }
}
