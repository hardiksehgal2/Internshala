import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internshala/screens/all_intership.dart';
import 'package:internshala/utils/on_boarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:velocity_x/velocity_x.dart';

class Sliding1 extends StatefulWidget {
  const Sliding1({super.key});

  @override
  State<Sliding1> createState() => _Sliding1State();
}

class _Sliding1State extends State<Sliding1> {
  int currentIndex = 0;
  final PageController pageController = PageController();
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _getIsOpenStatus(); 
  }

  Future<void> _getIsOpenStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isOpen = prefs.getBool('isOpen') ?? false;
    });
  }

  Future<void> _setIsOpenStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOpen', true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            CustomPaint(
              painter: ArchPaint(backgroundColors[currentIndex]),
              child: SizedBox(
                height: size.height / 1.35,
                width: size.width,
              ),
            ),
            Positioned(
              top: 65,
              left: 0,
              right: 0,
              child: FadeInLeft(
                from: 200,
                child: Container(
                  height: _getImageHeight(currentIndex),
                  width: _getImageWidth(currentIndex),
                  child: Image.asset(
                    onBoardingItems[currentIndex].asset,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 380,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: onBoardingItems.length,
                        itemBuilder: (context, index) {
                          final items = onBoardingItems[index];
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50.0),
                                child: items.titel.text
                                    .textStyle(GoogleFonts.beVietnamPro())
                                    .xl3
                                    .center
                                    .bold
                                    .black
                                    .make(),
                              ),
                              const SizedBox(height: 40),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0),
                                child: items.subtitle.text
                                    .textStyle(GoogleFonts.beVietnamPro())
                                    .center
                                    .xl
                                    .black
                                    .make(),
                              ),
                            ],
                          );
                        },
                        onPageChanged: (value) {
                          setState(() {
                            currentIndex = value;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int index = 0;
                            index < onBoardingItems.length;
                            index++)
                          dotIndicator(isSelected: index == currentIndex),
                      ],
                    ),
                    const SizedBox(height: 35),
                    GestureDetector(
                      onTap: () async {
                        await _setIsOpenStatus(); 
                        Get.to(() => const AllInternships(),
                            transition: Transition.circularReveal,
                            duration: const Duration(milliseconds: 1000));
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                          color: backgroundColors[currentIndex],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: "Join the movement!"
                              .text
                              .textStyle(GoogleFonts.beVietnamPro())
                              .lg
                              .white
                              .make(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: FloatingActionButton(
          onPressed: () async {
            if (currentIndex == onBoardingItems.length - 1) {
              await _setIsOpenStatus();
              Get.to(() => const AllInternships(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 1000));
            } else {
              pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear,
              );
            }
          },
          backgroundColor: Colors.white,
          elevation: 0,
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  double _getImageHeight(int index) {
    switch (index) {
      case 0:
        return 420;
      case 1:
        return 550;
      case 2:
        return 430;
      default:
        return 400;
    }
  }

  double _getImageWidth(int index) {
    switch (index) {
      case 0:
        return 540;
      case 1:
        return 600;
      case 2:
        return 440;
      default:
        return 500;
    }
  }

  List<Color> backgroundColors = [
    Colors.blue.shade300,
    Colors.blue.shade400,
    Colors.blue.shade500,
  ];

  Widget dotIndicator({required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: isSelected ? 8 : 6,
        width: isSelected ? 8 : 6,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.black : Colors.black26),
      ),
    );
  }
}

class ArchPaint extends CustomPainter {
  final Color color;

  ArchPaint(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Path whiteArc = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - 200)
      ..quadraticBezierTo(
          size.width / 2, size.height - 200, size.width, size.height - 200)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(whiteArc, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
