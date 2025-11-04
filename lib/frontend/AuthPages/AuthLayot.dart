import 'package:career_compasp/backend/auth.service.dart';
import 'package:career_compasp/frontend/AppLoadingPage.dart';
import 'package:career_compasp/frontend/HomePage.dart';
import 'package:career_compasp/frontend/StartPages.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, this.pageIfNotConnected});

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = const AppLoadingPage();
            } else if (snapshot.hasData) {
              widget = const HomePage();
            } else {
              widget = pageIfNotConnected ?? const StartPages();
            }

            return widget;
          },
        );
      },
    );
  }
}
