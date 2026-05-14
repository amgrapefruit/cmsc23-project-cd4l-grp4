import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:my_app/api/firestore_food_api.dart';

class FoodProvider with ChangeNotifier {
  late FirestoreFoodApi firebaseService;
  late Stream<QuerySnapshot> _foodItemsStream;
  Stream<QuerySnapshot> get foodItems => _foodItemsStream;
  String? currentUserId;

  FoodProvider() {
    firebaseService = FirestoreFoodApi();
    fetchFoodItems(null);
  }

  void fetchFoodItems(Map<String, dynamic>? query) {
    if (query != null) {
      _foodItemsStream = firebaseService.getFoodItemsByQuery(query);
    }
    else {
      _foodItemsStream = firebaseService.getAllFoodItems();
    }
    
    notifyListeners();
  }
}