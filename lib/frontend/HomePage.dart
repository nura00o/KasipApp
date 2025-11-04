import 'package:career_compasp/backend/auth.service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void logout() async {
    await authService.value.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}
