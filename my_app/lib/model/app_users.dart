class AppUser {

  // attributes
  String? uid;
  String? name;
  String? email;
  bool? isVerified = false;
  List<String>? dietaryTags = [];

  // constructor
  AppUser({
    required this.name,
    required this.uid,
    required this.email,
    this.isVerified,
    this.dietaryTags,
  });
  
  // factory constructors
  factory AppUser.fromMap(Map<String, dynamic> user) {
     return AppUser(
      name: user['name'],
      email: user['email'],
      uid: user['uid'],
      isVerified: user['isVerified'],
      dietaryTags: user['dietaryTags'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'isVerified': isVerified,
      'dietaryTags': dietaryTags,
    };
  }
}