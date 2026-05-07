import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/model/food_item.dart';

class FirestoreFoodApi {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // adds food item to the database
  Future<String?> addFoodItem(FoodItem foodItem) async {
    try {
      await db.collection('food_items').doc(foodItem.id).set(foodItem.toJson());
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
}
