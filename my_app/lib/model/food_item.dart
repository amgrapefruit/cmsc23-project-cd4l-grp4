class FoodItem {
  // attributes
  String? name;
  String? id;
  int? quantity;
  String? requestedBy;
  String? itemPic; //url
  DateTime? expirationDate;
  bool? isReserved = false;

  // constructor
  FoodItem({
    required this.name,
    required this.id,
    required this.quantity,
    required this.expirationDate,
    this.requestedBy,
    this.itemPic,
    this.isReserved,
  });

  // factory constructors
  factory FoodItem.fromMap(Map<String, dynamic> item) {
    return FoodItem(
      name: item['name'],
      id: item['id'],
      quantity: item['quantity'],
      expirationDate: item['expirationDate'],
      requestedBy: item['requestedBy'],
      itemPic: item['itemPic'],
      isReserved: item['isReserved'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'expirationDate': expirationDate,
      'requestedBy': requestedBy,
      'itemPic': itemPic,
      'isReserved': isReserved,
    };
  }
}