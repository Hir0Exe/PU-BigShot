import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../business/business_home_screen.dart';
import 'user_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    // Redirigir según el tipo de usuario
    if (authProvider.userType == UserType.business) {
      return const BusinessHomeScreen();
    } else {
      return const UserHomeScreen();
    }
  }
}

