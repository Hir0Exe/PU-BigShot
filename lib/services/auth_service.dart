import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: ['email'],
  // );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream del estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuario actual
  User? get currentUser => _auth.currentUser;

  // Registro con email y contraseña
  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
    required UserType userType,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Crear documento de usuario en Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'userType': userType.toString(),
        'createdAt': DateTime.now().toIso8601String(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Error en registro: ${e.message}');
      rethrow;
    }
  }

  // Inicio de sesión con email y contraseña
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('Error en inicio de sesión: ${e.message}');
      rethrow;
    }
  }

  // Inicio de sesión con Google (TEMPORALMENTE DESHABILITADO - Ver README)
  Future<UserCredential?> signInWithGoogle({UserType? userType}) async {
    // TODO: Configurar Google Sign In correctamente para la nueva versión
    throw UnimplementedError(
        'Google Sign In está temporalmente deshabilitado. Usa email/password por ahora.');
    
    /* Código comentado para futuraconfiguración
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // El usuario canceló el inicio de sesión
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Verificar si es un nuevo usuario
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        // Si userType no se proporcionó, usar 'particular' por defecto
        final type = userType ?? UserType.particular;

        // Crear documento de usuario en Firestore
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'userType': type.toString(),
          'createdAt': DateTime.now().toIso8601String(),
        });
      }

      return userCredential;
    } catch (e) {
      print('Error en inicio de sesión con Google: $e');
      rethrow;
    }
    */
  }

  // Obtener tipo de usuario
  Future<UserType?> getUserType(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        String userTypeString = doc.get('userType');
        return userTypeString == 'UserType.business'
            ? UserType.business
            : UserType.particular;
      }
      return null;
    } catch (e) {
      print('Error obteniendo tipo de usuario: $e');
      return null;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    // await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Eliminar cuenta completa
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No hay usuario autenticado');
      }

      final uid = user.uid;

      // Eliminar datos de Firestore
      await _deleteUserData(uid);

      // Eliminar usuario de Authentication
      await user.delete();
    } catch (e) {
      throw Exception('Error al eliminar cuenta: $e');
    }
  }

  // Eliminar todos los datos del usuario en Firestore
  Future<void> _deleteUserData(String uid) async {
    try {
      // Eliminar documento de usuario
      await _firestore.collection('users').doc(uid).delete();

      // Eliminar documento de business si existe
      await _firestore.collection('businesses').doc(uid).delete();

      // Eliminar todos los follows del usuario
      final followsSnapshot = await _firestore
          .collection('follows')
          .where('userId', isEqualTo: uid)
          .get();
      
      for (var doc in followsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Si es empresa, eliminar sus ofertas
      final offersSnapshot = await _firestore
          .collection('offers')
          .where('businessId', isEqualTo: uid)
          .get();
      
      for (var doc in offersSnapshot.docs) {
        await doc.reference.delete();
      }

      // Eliminar follows hacia esta empresa (si es empresa)
      final businessFollowsSnapshot = await _firestore
          .collection('follows')
          .where('businessId', isEqualTo: uid)
          .get();
      
      for (var doc in businessFollowsSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error eliminando datos de Firestore: $e');
      // Continuar con la eliminación de Authentication aunque falle Firestore
    }
  }
}

