class UserModel {
  String? id;
  String userName;
  String email;
  String? imagePath;
  String language;
  String theme;
  bool isSubscribed;

  UserModel({
    this.id,
    required this.userName,
    required this.email,
    this.imagePath,
    this.language = 'en', // ✅ Default value
    this.theme = 'light', // ✅ Default value
    this.isSubscribed = false, // ✅ Default value
  });

  // Convert a User object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'imagePath': imagePath ?? '',
      'language': language,
      'theme': theme,
      'isSubscribed': isSubscribed, // ✅ Use actual value
    };
  }

  // Create a User object from a Firestore document
  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      userName: data['userName'] ?? 'Unknown', // ✅ Default value if null
      email: data['email'] ?? '',
      imagePath: data['imagePath'] ?? '',
      language: data['language'] ?? 'en', // ✅ Default fallback
      theme: data['theme'] ?? 'light', // ✅ Default fallback
      isSubscribed: data['isSubscribed'] ?? false, // ✅ Avoid null issue
    );
  }

  // CopyWith method for updating values
  UserModel copyWith({
    String? id,
    String? userName,
    String? email,
    String? imagePath,
    String? language,
    String? theme,
    bool? isSubscribed,
  }) {
    return UserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      imagePath: imagePath ?? this.imagePath,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      isSubscribed: isSubscribed ?? this.isSubscribed, // ✅ Use actual value
    );
  }
}
