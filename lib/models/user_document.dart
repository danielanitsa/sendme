import 'package:appwrite/models.dart';

class UserDocument {
  final String id;
  final String fullname;
  final String email;
  final String registeredAt;
  dynamic password;
  dynamic avatarUrl;

  UserDocument({
    required this.id,
    required this.fullname,
    required this.email,
    required this.registeredAt,
    this.avatarUrl,
  });

  // Improved toJson method with null handling
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname.isNotEmpty
          ? fullname
          : 'Anonymous User', // Default value if empty
      'email': email,
      'registeredAt': registeredAt,
      'avatarUrl': avatarUrl.toString().isNotEmpty ? avatarUrl : null,
    };
  }

  factory UserDocument.fromAuthUser(User user) {
    return UserDocument(
      id: user.$id,
      fullname: user.name.isNotEmpty ? user.name : 'Anonymous User',
      email: user.email,
      registeredAt: user.$createdAt,
    );
  }
}
