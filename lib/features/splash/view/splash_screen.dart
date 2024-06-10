import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      navigateTo(context, const GuestScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(),
      child: BlocBuilder<SplashCubit, SplashStates>(builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 200, 243, 255),
          body: AnimatedContainer(
            duration: const Duration(seconds: 1),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(tag: 'Logo', child: Image.asset(ImageConstants.logo)),
                Text(
                  StringConstants.appName,
                  style: TextStyle(
                      fontSize: 14 * SizeHandler.getHegiht(context) * 0.004,
                      fontWeight: FontWeight.bold),
                )
              ],
            )),
          ),
        );
      }),
    );
  }
}
