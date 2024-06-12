import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salama/core/constants/image_constants.dart';
import 'package:salama/core/constants/string_constants.dart';
import 'package:salama/core/size_handler/size_handler.dart';
import 'package:salama/core/widgets/navigation.dart';
import 'package:salama/features/guest/view/guest_screen.dart';
import 'package:salama/features/splash/controller/cubit.dart';
import 'package:salama/features/splash/controller/states.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  AnimationController? _controllerArabic;
  Animation<int>? _animation;
  Animation<int>? _animationArabic;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = IntTween(begin: 0, end: 6).animate(_controller!)
      ..addListener(() {
        setState(() {
          if (_animation!.value == 6) {
            _controller!.stop();
          }
        });
      });

    _controllerArabic = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationArabic = IntTween(begin: 0, end: 14).animate(_controllerArabic!)
      ..addListener(() {
        setState(() {
          if (_animationArabic!.value == 14) {
            _controllerArabic!.stop();
          }
        });
      });

    _controller!.repeat();
    _controllerArabic!.repeat();

    Future.delayed(const Duration(seconds: 3), () {
      navigateTo(context, const GuestScreen());
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashCubit>(
      create: (context) => SplashCubit(),
      child: BlocBuilder<SplashCubit, SplashStates>(
        builder: (context, state) {
          String text1 = "سلامه, يرحب بك";

          final endIndex =
              min(_animation!.value + 1, StringConstants.appName.length);
          final endIndexArabic = min(_animationArabic!.value + 1, text1.length);
          final animatedText = StringConstants.appName.substring(0, endIndex);
          final animatedTextArabic = text1.substring(0, endIndexArabic);
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 200, 243, 255),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'Logo',
                    child: Image.asset(ImageConstants.logo),
                  ),
                  Text(
                    animatedText,
                    style: GoogleFonts.raleway(
                      fontSize: 14 * SizeHandler.getHegiht(context) * 0.004,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    key: ValueKey(
                        animatedText), // Re-render when animatedText changes
                  ),
                  Text(
                    animatedTextArabic,
                    style: GoogleFonts.raleway(
                      fontSize: 14 * SizeHandler.getHegiht(context) * 0.004,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    key: ValueKey(
                        animatedTextArabic), // Re-render when animatedText changes
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
