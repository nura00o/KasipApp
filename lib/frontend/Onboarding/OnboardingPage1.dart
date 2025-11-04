import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage1 extends StatefulWidget {
  final PageController controller; // добавили

  const OnboardingPage1({super.key, required this.controller});

  @override
  State<OnboardingPage1> createState() => _OnboardingPage1State();
}

class _OnboardingPage1State extends State<OnboardingPage1> {
  @override
  Widget build(BuildContext) {
    final screenWidth = MediaQuery.of(context).size.width; //для адаптивности
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Animate(
              effects: [
                FadeEffect(duration: 450.ms, curve: Curves.easeOut),
                MoveEffect(
                  begin: Offset(0, 40), // начнёт ниже на 40 px
                  end: Offset.zero,
                  duration: 450.ms,
                  curve: Curves.easeOut,
                ),
              ],
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.65,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/StartPage.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: screenHeight * 0.38,
                width: screenWidth, // вместо 415 сделано адаптивно
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 40,
                ),
                decoration: BoxDecoration(
                  color: Colors.white, // фон
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(35), // закругляем только верх
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.08,
                      ), // лёгкая тень
                      blurRadius: 10, // размытие
                      offset: const Offset(0, -2), // направление тени (вверх)
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, //левый край
                  children: [
                    Text(
                      'Find the path\nthat suits you',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: const Color.fromARGB(255, 73, 71, 71),
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Take a short test and find out in which area your abilities will bring the most growth and satisfaction.',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child:
                          ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  widget.controller.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Text(
                                  'Next',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                              .moveY(begin: 30, end: 0, curve: Curves.easeOut)
                              .scaleXY(begin: 0.9, end: 1.0, duration: 400.ms),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
