import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salama/core/constants/string_constants.dart';
import 'package:salama/core/services/navigator_service.dart';
import 'package:salama/core/services/shared_pref.dart';
import 'package:salama/features/sign_in/controller/cubit.dart';
import 'package:salama/features/sign_up/controller/cubit.dart';
import 'package:salama/features/splash/controller/cubit.dart';
import 'package:salama/features/splash/view/splash_screen.dart';
import 'package:salama/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  Future.wait([
    CacheHelper.init(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignInCubit()),
        BlocProvider(create: (context) => SplashCubit()),
        BlocProvider(create: (context) => SignUpCubit()),
      ],
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey, // set property

        title: StringConstants.appName,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
