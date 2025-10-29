import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/offer_model.dart';

class OfferService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Crear oferta
  Future<void> createOffer(OfferModel offer) async {
    try {
      await _firestore.collection('offers').doc(offer.id).set(offer.toMap());
    } catch (e) {
      print('Error creando oferta: $e');
      rethrow;
    }
  }

  // Obtener todas las ofertas (para usuarios particulares)
  Stream<List<OfferModel>> getAllOffers() {
    return _firestore
        .collection('offers')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OfferModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Obtener ofertas de un negocio específico
  Stream<List<OfferModel>> getBusinessOffers(String businessId) {
    return _firestore
        .collection('offers')
        .where('businessId', isEqualTo: businessId)
        .snapshots()
        .map((snapshot) {
      final offers = snapshot.docs
          .map((doc) => OfferModel.fromMap(doc.data(), doc.id))
          .toList();
      // Ordenar en memoria en lugar de en la query
      offers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return offers;
    });
  }

  // Eliminar oferta
  Future<void> deleteOffer(String offerId) async {
    try {
      await _firestore.collection('offers').doc(offerId).delete();
    } catch (e) {
      print('Error eliminando oferta: $e');
      rethrow;
    }
  }

  // Buscar ofertas con filtros
  Future<List<OfferModel>> searchOffers({
    String? category,
    bool includeExpired = false,
    String? searchQuery,
  }) async {
    try {
      Query query = _firestore.collection('offers');

      // Filtrar por categoría si se especifica
      if (category != null && category.isNotEmpty && category != 'TODAS') {
        query = query.where('category', isEqualTo: category);
      }

      final snapshot = await query.get();
      var offers = snapshot.docs
          .map((doc) => OfferModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // Filtrar ofertas vencidas
      if (!includeExpired) {
        offers = offers.where((offer) => offer.expirationDate.isAfter(DateTime.now())).toList();
      }

      // Búsqueda por texto (en título o descripción)
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        offers = offers.where((offer) {
          return offer.title.toLowerCase().contains(query) ||
                 offer.description.toLowerCase().contains(query) ||
                 offer.businessName.toLowerCase().contains(query);
        }).toList();
      }

      // Ordenar por fecha de creación
      offers.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return offers;
    } catch (e) {
      print('Error buscando ofertas: $e');
      return [];
    }
  }

  // Obtener ofertas con prioridad para empresas seguidas
  Future<List<OfferModel>> getOffersWithPriority(List<String> followedBusinessIds) async {
    try {
      final snapshot = await _firestore.collection('offers').get();
      var offers = snapshot.docs
          .map((doc) => OfferModel.fromMap(doc.data(), doc.id))
          .toList();

      // Filtrar solo ofertas vigentes
      offers = offers.where((offer) => offer.expirationDate.isAfter(DateTime.now())).toList();

      // Separar ofertas seguidas y no seguidas
      final followedOffers = offers.where((offer) => followedBusinessIds.contains(offer.businessId)).toList();
      final otherOffers = offers.where((offer) => !followedBusinessIds.contains(offer.businessId)).toList();

      // Ordenar ambas listas por fecha
      followedOffers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      otherOffers.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Combinar: primero las seguidas, luego las otras
      return [...followedOffers, ...otherOffers];
    } catch (e) {
      print('Error obteniendo ofertas: $e');
      return [];
    }
  }
}

