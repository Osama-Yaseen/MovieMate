class UserModel {
  String? id;
  String userName;
  String email;
  String? imagePath;
  String language = 'en';
  String theme = 'light';

  UserModel({
    this.id,
    required this.userName,
    required this.email,
    this.imagePath,
    required this.language,
    required this.theme,
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
    };
  }

  // Create a User object from a Firestore document
  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      userName: data['userName'] ?? 'Unknown', // Default value if null
      email: data['email'] ?? '',
      imagePath: data['imagePath'] ?? '',
      language: data['language'],
      theme: data['theme'],
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
  }) {
    return UserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      imagePath: imagePath ?? this.imagePath,
      language: language ?? this.language,
      theme: theme ?? this.theme,
    );
  }
}
