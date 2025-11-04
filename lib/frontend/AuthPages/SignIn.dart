import 'package:career_compasp/frontend/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../backend/auth.service.dart';
import 'ForgotPasswordPage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  bool obscurePassword = true;
  String errorMessage = '';

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  void signIn() async {
    try {
      await authService.value.signIn(
        email: controllerEmail.text.trim(),
        password: controllerPassword.text.trim(),
      );

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = e.message ?? 'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text('Email', style: GoogleFonts.inter(fontSize: 15)),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controllerEmail,
            decoration: const InputDecoration(
              hintText: "Write your email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text('Password', style: GoogleFonts.inter(fontSize: 15)),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controllerPassword,
            obscureText: obscurePassword,
            decoration: InputDecoration(
              hintText: "Password",
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => obscurePassword = !obscurePassword),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                );
              },
              child: const Text("Forgot password?"),
            ),
          ),
          Text(errorMessage, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: signIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Sign In",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(child: Text("Other sign in options")),
        ],
      ),
    );
  }
}
