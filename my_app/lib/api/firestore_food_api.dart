import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/model/food_item.dart';

class FirestoreFoodApi {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // adds food item to the database
  Future<String?> addFoodItem(FoodItem foodItem) async {
    try {
      Map<String, String> imageMap = {'bytes': foodItem.toJson()['itemPicBase64']};
      final imageRef = await db.collection('food_images').add(imageMap);

      // change the base64 field to its docuID
      foodItem.itemPicBase64 = imageRef.id;

      await db.collection('food_items').add(foodItem.toJson());
      return null;
    } on FirebaseException catch (e) {
      return 'Failed to add food item: $e';
    }
  }

  // adds food item to the database using map
  Future<String?> addFoodItemFromMap(Map<String, dynamic> foodItem) async {
    try {
      Map<String, String> imageMap = {'bytes': foodItem['itemPicBase64']};
      final imageRef = await db.collection('food_images').add(imageMap);
      
      // change the base64 field to its docuID
      foodItem['itemPicBase64'] = imageRef.id;

      await db.collection('food_items').add(foodItem);
      return null;
    } on FirebaseException catch (e) {
      return 'Failed to add food item: $e';
    }
  }

  // update food item in the database
  Future<String?> updateFoodItem(FoodItem foodItem) async {
    try {
      await db.collection('food_items').doc(foodItem.id).update(foodItem.toJson());
      return null;
    } on FirebaseException catch (e) {
      return 'Failed to update food item: $e';
    }
  }

  // get user requesters
  Future<Stream<QuerySnapshot>> getUserRequesters(String foodItemId) async {  
    final doc = await db.collection('food_items').doc(foodItemId).get();
    final requesters = doc.get('requestedBy');
    return db.collection('users').where('uid', whereIn: requesters).snapshots();
  }

  // get food items by query map
  Stream<QuerySnapshot> getFoodItemsByQuery(Map<String, dynamic> query) {
    final ref = db.collection('food_items');

    query.forEach((key, value) {
      if (value is List) {
        // query all elements in the list
        for (var element in value) {
          ref.where(key, arrayContains: element);
        }
      }
      else {
        ref.where(key, isEqualTo: value);
      }
    });

    return ref.snapshots();
  }

  // get all food items
  Stream<QuerySnapshot> getAllFoodItems() {
    return db.collection('food_items').snapshots();
  }

  // get food items by user
  Future<QuerySnapshot> getFoodItemsByUser(String userId) async {
    return await db.collection('food_items').where('owner', isEqualTo: userId).get();
  }

  // get food item by id
  Future<DocumentSnapshot> getFoodItemById(String foodItemId) async {
    return await db.collection('food_items').doc(foodItemId).get();
  }
}
