class FoodItem {
  // attributes
  String? name;
  String? id;
  String? owner; // uid of the user who added the item
  int? quantity;
  List<String>? requestedBy;
  List<String>? tags;
  String? itemPic; //url
  DateTime? expirationDate;
  bool? isReserved = false;
  String? reservedBy; // uid of the user who reserved the item
  String? description; // for the short description provided by the user

  // constructor
  FoodItem({
    required this.name,
    required this.id,
    required this.quantity,
    required this.expirationDate,
    required this.owner,
    this.requestedBy,
    this.itemPic,
    this.isReserved,
    this.reservedBy,
    this.tags,
    this.description,
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
      owner: item['owner'],
      reservedBy: item['reservedBy'],
      tags: item['tags'],
      description: item['description'],
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
      'owner': owner,
      'reservedBy': reservedBy,
      'tags': tags,
      'description': description,
    };
  }
}