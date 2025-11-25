import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'controllers/auth_controller.dart';
import 'models/user_model.dart';
import 'screens/auth/login_screen.dart';
import 'screens/business/business_home_screen.dart';
import 'screens/home/user_home_screen.dart';

// INSTANCIA GLOBAL del controlador - se inicializa una sola vez
late final AuthController authController;

// GlobalKey para el Navigator
final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Inicializar el controlador singleton ANTES de runApp
  authController = AuthController();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    print('🔥 [MyApp] initState - Adding listener to authController');
    // El MyApp NUNCA se destruye, por lo que el listener SIEMPRE estará activo
    authController.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    print('🔥 [MyApp] dispose - Removing listener');
    authController.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    print('🔥 [MyApp] _onAuthChanged called - Rebuilding MaterialApp');
    if (mounted) {
      setState(() {}); // Reconstruir el MaterialApp con el nuevo home
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🔥 [MyApp] Building... isLoading=${authController.isLoading}, user=${authController.currentUser?.email ?? "null"}, userType=${authController.userType}');
    
    // Determinar qué pantalla mostrar
    Widget homeScreen;
    String screenKey;
    
    if (authController.isLoading) {
      screenKey = 'loading';
      homeScreen = const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFE53935)),
        ),
      );
    } else if (!authController.isAuthenticated) {
      print('🔥 [MyApp] No user, showing LoginScreen');
      screenKey = 'login';
      homeScreen = const LoginScreen();
    } else {
      print('🔥 [MyApp] User logged in, showing home');
      if (authController.userType == UserType.business) {
        screenKey = 'business_${authController.currentUser!.uid}';
        homeScreen = const BusinessHomeScreen();
      } else {
        screenKey = 'user_${authController.currentUser!.uid}';
        homeScreen = const UserHomeScreen();
      }
    }
    
    print('🔥 [MyApp] Using screen key: $screenKey');
    
    return MaterialApp(
      key: ValueKey(screenKey), // FORZAR reconstrucción completa cuando cambia el estado
      title: 'BigShot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: const Color(0xFFE53935), // Rojo vibrante
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE53935), // Rojo vibrante
            foregroundColor: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
          accentColor: const Color(0xFFFF6F00), // Naranja vibrante
        ).copyWith(secondary: const Color(0xFFFF6F00)),
      ),
      home: homeScreen,
    );
  }
}

// AuthGate ya no es necesario - toda la lógica está en MyApp
