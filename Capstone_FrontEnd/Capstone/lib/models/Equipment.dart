class Equipment {
  final int id;
  final String? name;
  final int? quantity;
  final String? category;  // Add category field
  final DateTime? lastScanDate;  // Add lastScanDate field
  final DateTime? nextScanDate;  // Add nextScanDate field

  Equipment({
    required this.id,
    this.name,
    this.quantity,
    this.category,
    this.lastScanDate,
    this.nextScanDate,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['equipmentId'] as int,  // Ensure 'equipmentId' is the correct key as per API response
      name: json['name'] as String?,
      quantity: json['quantity'] as int?,
      category: json['category'] as String?,
      lastScanDate: json.containsKey('lastScanDate') && json['lastScanDate'] != null
          ? DateTime.parse(json['lastScanDate']) : null,
      nextScanDate: json.containsKey('nextScanDate') && json['nextScanDate'] != null
          ? DateTime.parse(json['nextScanDate']) : null,
    );
  }

}
