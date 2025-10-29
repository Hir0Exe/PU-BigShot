enum UserType { particular, business }

class UserModel {
  final String uid;
  final String email;
  final UserType userType;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.userType,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'userType': userType.toString(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      userType: map['userType'] == 'UserType.business'
          ? UserType.business
          : UserType.particular,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

