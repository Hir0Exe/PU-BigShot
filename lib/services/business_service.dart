import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/business_model.dart';

class BusinessService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Guardar datos de empresa
  Future<void> saveBusinessData(BusinessModel business) async {
    try {
      await _firestore
          .collection('businesses')
          .doc(business.uid)
          .set(business.toMap());
    } catch (e) {
      print('Error guardando datos de empresa: $e');
      rethrow;
    }
  }

  // Subir logo de empresa
  Future<String> uploadLogo(String uid, File file) async {
    try {
      final ref = _storage.ref().child('business_logos/$uid.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error subiendo logo: $e');
      rethrow;
    }
  }

  // Subir registro mercantil
  Future<String> uploadRegistroMercantil(String uid, File file) async {
    try {
      final ref = _storage.ref().child('registros_mercantiles/$uid.pdf');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error subiendo registro mercantil: $e');
      rethrow;
    }
  }

  // Obtener datos de empresa
  Future<BusinessModel?> getBusinessData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('businesses').doc(uid).get();
      if (doc.exists) {
        return BusinessModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error obteniendo datos de empresa: $e');
      return null;
    }
  }

  // Obtener todas las empresas (para usuarios particulares)
  Stream<List<BusinessModel>> getAllBusinesses() {
    return _firestore.collection('businesses').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => BusinessModel.fromMap(doc.data()))
          .toList();
    });
  }
}

