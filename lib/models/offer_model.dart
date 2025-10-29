class OfferModel {
  final String id;
  final String businessId;
  final String businessName;
  final String title;
  final String description;
  final String category;
  final String? imageUrl;
  final DateTime expirationDate;
  final DateTime createdAt;

  OfferModel({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.title,
    required this.description,
    required this.category,
    this.imageUrl,
    required this.expirationDate,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'businessId': businessId,
      'businessName': businessName,
      'title': title,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'expirationDate': expirationDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OfferModel.fromMap(Map<String, dynamic> map, String id) {
    return OfferModel(
      id: id,
      businessId: map['businessId'] ?? '',
      businessName: map['businessName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'OTROS',
      imageUrl: map['imageUrl'],
      expirationDate: DateTime.parse(map['expirationDate']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

