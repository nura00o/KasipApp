import 'package:flutter/material.dart';
import 'SignIn.dart';
import 'SignUp.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isSignIn = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 35),

              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  'assets/images/LogoExmp.png',
                  height: 50,
                  width: 50,
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                'Kasip',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 35),

              Container(
                width: width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    _switchButton("Sign In", isSignIn, () {
                      setState(() => isSignIn = true);
                    }),
                    _switchButton("Sign Up", !isSignIn, () {
                      setState(() => isSignIn = false);
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: isSignIn
                      ? SignInPage(key: const ValueKey('sign_in'))
                      : SignUpPage(key: const ValueKey('sign_up')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _switchButton(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: active ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
