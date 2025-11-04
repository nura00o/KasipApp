import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingPage2 extends StatefulWidget {
  final PageController controller; // добавили

  const OnboardingPage2({super.key, required this.controller});

  @override
  State<OnboardingPage2> createState() => _OnboardingPage2State();
}

class _OnboardingPage2State extends State<OnboardingPage2> {
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
                    image: AssetImage('assets/images/StartPage2.png'),
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
                      'Explore and use\nthe possibilities',
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
                      'Explore salaries, sought-after skills, and real-world opportunities to choose the best start for yourself.',
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
