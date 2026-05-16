import 'dart:typed_data';

class FoodItem {
  // attributes
  String? name;
  String? id;
  String? owner; // uid of the user who added the item
  int? quantity;
  String? unit; // e.g. "lbs", "pieces", etc.
  List<String>? requestedBy;
  List<String>? dietaryTags;
  List<String>? foodTypeTags;
  String? itemPicBase64; // base64
  DateTime? expirationDate;
  String? pickupLocation;
  bool? isReserved = false;
  String? reservedBy; // uid of the user who reserved the item

  // constructor
  FoodItem({
    required this.name,
    required this.id,
    required this.quantity,
    required this.unit,
    required this.expirationDate,
    required this.owner,
    required this.pickupLocation,
    this.requestedBy,
    this.itemPicBase64,
    this.isReserved,
    this.reservedBy,
    this.dietaryTags,
    this.foodTypeTags,
  });

  // factory constructors
  factory FoodItem.fromMap(Map<String, dynamic> item) {
    return FoodItem(
      name: item['name'],
      id: item['id'],
      quantity: item['quantity'],
      unit: item['unit'],
      expirationDate: item['expirationDate'],
      requestedBy: item['requestedBy'],
      itemPicBase64: item['itemPicBase64'],
      isReserved: item['isReserved'],
      owner: item['owner'],
      reservedBy: item['reservedBy'],
      dietaryTags: item['dietaryTags'],
      foodTypeTags: item['foodTypeTags'],
      pickupLocation: item['pickupLocation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'expirationDate': expirationDate,
      'requestedBy': requestedBy,
      'itemPicBase64': itemPicBase64,
      'isReserved': isReserved,
      'owner': owner,
      'reservedBy': reservedBy,
      'dietaryTags': dietaryTags,
      'foodTypeTags': foodTypeTags,
      'pickupLocation': pickupLocation,
    };
  }
}