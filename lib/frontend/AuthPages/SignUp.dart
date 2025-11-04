import 'package:career_compasp/frontend/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../backend/auth.service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirm = true;
  String errorMessage = '';

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  void register() async {
    try {
      await authService.value.createAccount(
        email: controllerEmail.text,
        password: controllerPassword.text,
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
              hintText: "Create a password",
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
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Confirm password',
              style: GoogleFonts.inter(fontSize: 15),
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            obscureText: obscureConfirm,
            decoration: InputDecoration(
              hintText: "Repeat password",
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureConfirm ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => obscureConfirm = !obscureConfirm),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(errorMessage, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(child: Text("Other sign up options")),
        ],
      ),
    );
  }
}
