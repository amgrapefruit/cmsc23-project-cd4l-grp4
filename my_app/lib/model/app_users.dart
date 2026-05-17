class AppUser {

  // attributes
  String? uid;
  String? name;
  String? email;
  bool? isVerified = false;
  List<String>? dietaryTags = [];
  List<String>? foodInterests = [];
  String? rolePreference; // "To receive food" or "To give surplus food" or "Both"

  // constructor
  AppUser({
    required this.name,
    required this.uid,
    required this.email,
    this.isVerified,
    this.dietaryTags,
    this.foodInterests,
    this.rolePreference,
  });
  
  // factory constructors
  factory AppUser.fromMap(Map<String, dynamic> user) {
     return AppUser(
      name: user['name'],
      email: user['email'],
      uid: user['uid'],
      isVerified: user['isVerified'],
      dietaryTags: user['dietaryTags'],
      foodInterests: user['foodInterests'],
      rolePreference: user['rolePreference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'isVerified': isVerified,
      'dietaryTags': dietaryTags,
      'foodInterests': foodInterests,
      'rolePreference': rolePreference,
    };
  }
}