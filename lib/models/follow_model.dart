class FollowModel {
  final String userId; // Usuario particular que sigue
  final String businessId; // Empresa/supermercado seguido
  final String businessName; // Nombre del negocio
  final DateTime createdAt;

  FollowModel({
    required this.userId,
    required this.businessId,
    required this.businessName,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'businessId': businessId,
      'businessName': businessName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FollowModel.fromMap(Map<String, dynamic> map) {
    return FollowModel(
      userId: map['userId'] ?? '',
      businessId: map['businessId'] ?? '',
      businessName: map['businessName'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

