import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/follow_model.dart';

class FollowService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Seguir a una empresa
  Future<void> followBusiness(String userId, String businessId, String businessName) async {
    try {
      final followId = '${userId}_$businessId';
      final follow = FollowModel(
        userId: userId,
        businessId: businessId,
        businessName: businessName,
        createdAt: DateTime.now(),
      );
      
      await _firestore.collection('follows').doc(followId).set(follow.toMap());
    } catch (e) {
      throw Exception('Error al seguir: $e');
    }
  }

  // Dejar de seguir a una empresa
  Future<void> unfollowBusiness(String userId, String businessId) async {
    try {
      final followId = '${userId}_$businessId';
      await _firestore.collection('follows').doc(followId).delete();
    } catch (e) {
      throw Exception('Error al dejar de seguir: $e');
    }
  }

  // Verificar si el usuario sigue a una empresa
  Future<bool> isFollowing(String userId, String businessId) async {
    try {
      final followId = '${userId}_$businessId';
      final doc = await _firestore.collection('follows').doc(followId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Obtener empresas que sigue el usuario
  Stream<List<FollowModel>> getUserFollows(String userId) {
    return _firestore
        .collection('follows')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FollowModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Obtener IDs de empresas que sigue el usuario
  Future<List<String>> getFollowedBusinessIds(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('follows')
          .where('userId', isEqualTo: userId)
          .get();
      
      return snapshot.docs.map((doc) => doc.data()['businessId'] as String).toList();
    } catch (e) {
      return [];
    }
  }

  // Contar seguidores de una empresa
  Future<int> getFollowersCount(String businessId) async {
    try {
      final snapshot = await _firestore
          .collection('follows')
          .where('businessId', isEqualTo: businessId)
          .get();
      
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }
}

