import 'package:career_compasp/backend/auth.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ForgotPasswordPage.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  bool isSignIn = true;
  bool obscurePassword = true;
  bool obscureConfirm = true;

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  final formkey = GlobalKey<FormState>();
  String errorMessageRegister = '';
  String errorMessageSigIn = '';

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
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessageRegister = e.message ?? 'There ia an problem Nura';
      });
    }
  }

  void sigIn() async {
    try {
      await authService.value.signIn(
        email: controllerEmail.text,
        password: controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessageSigIn = e.message ?? 'There ia an problem Nura';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 35),

              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  'assets/images/LogoExmp.png',
                  height: 50,
                  width: 50,
                ),
              ),

              SizedBox(height: 40),

              Align(
                alignment: Alignment.center,
                child: Text(
                  'Kasip',
                  style: GoogleFonts.poppins(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),

              SizedBox(height: 35),

              Container(
                width: width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isSignIn = true),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSignIn
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                'Sign In',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isSignIn = false),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: !isSignIn
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Email',
                  style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
                ),
              ),

              SizedBox(height: 5),

              TextField(
                controller: controllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Write your email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Password',
                  style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
                ),
              ),

              SizedBox(height: 5),

              TextField(
                controller: controllerPassword,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: isSignIn ? "Password" : "Create a password",
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

              if (!isSignIn) ...[
                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Confirm password',
                    style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
                  ),
                ),

                SizedBox(height: 5),

                TextField(
                  obscureText: obscureConfirm,
                  decoration: InputDecoration(
                    hintText: "repeat password",
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => obscureConfirm = !obscureConfirm),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(errorMessageRegister, style: TextStyle(color: Colors.red)),
              ],

              const SizedBox(height: 15),

              if (isSignIn)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: const Text("Forgot password?"),
                  ),
                ),
              const SizedBox(height: 10),
              Text(errorMessageSigIn, style: TextStyle(color: Colors.red)),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (isSignIn) {
                      sigIn();
                    } else {
                      register();
                    }
                  },
                  child: Text(
                    isSignIn ? "Sign in" : "Sign up",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Text(
                isSignIn ? "Other sign in options" : "Other sign up options",
                style: GoogleFonts.poppins(fontSize: 13),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
