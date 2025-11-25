import 'package:flutter/material.dart';

// Este archivo ya no se usa - el AuthWrapper en main.dart maneja todo
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFFE53935),
        ),
      ),
    );
  }
}

