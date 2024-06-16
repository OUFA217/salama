import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salama/core/constants/colors_constants.dart';
import 'package:salama/core/size_handler/size_handler.dart';
import 'package:salama/core/widgets/background.dart';
import 'package:salama/features/home/view/home_screen.dart';
import 'package:salama/features/sign_in/controller/cubit.dart';
import 'package:salama/features/sign_in/controller/states.dart';
import 'package:salama/features/sign_in/model/sign_in_model.dart';
import 'package:salama/features/sign_up/view/sign_up.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInStates>(listener: (context, state) {
      if (state is SignInSuccessState) {
        Fluttertoast.showToast(msg: "Login Successful");
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const HomeScreen(),
              transitionDuration: const Duration(milliseconds: 1000),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
            (route) => false);
      }
    }, builder: (context, state) {
      final cubit = SignInCubit.get(context);
      return Scaffold(
        body: SingleChildScrollView(
          child: Background(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorsConstants.colorDefault,
                        fontSize: 36),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: SizeHandler.getHegiht(context) * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: cubit.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                ),
                SizedBox(height: SizeHandler.getHegiht(context) * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: cubit.passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: SizeHandler.getHegiht(context) * 0.05),
                Container(
                  alignment: Alignment.centerRight,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      textStyle: const WidgetStatePropertyAll(
                          TextStyle(color: Colors.white)),
                      padding: const WidgetStatePropertyAll(EdgeInsets.all(0)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0))),
                    ),
                    onPressed: () {
                      if (state is SignInLoadingState) {
                      } else {
                        if (cubit.passwordController.text.isNotEmpty &&
                            cubit.emailController.text.isNotEmpty) {
                          cubit.signIn(SignInModel(
                            email: cubit.emailController.text,
                            password: cubit.passwordController.text,
                          ));
                        } else if (cubit.emailController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please Enter Your Email",
                              backgroundColor: Colors.red);
                        } else if (cubit.passwordController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please Enter Your Password",
                              backgroundColor: Colors.red);
                        }
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: SizeHandler.getHegiht(context) * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient: const LinearGradient(colors: [
                            Color.fromARGB(255, 255, 136, 34),
                            Color.fromARGB(255, 255, 177, 41)
                          ])),
                      padding: const EdgeInsets.all(0),
                      child: state is SignInLoadingState
                          ? const CircularProgressIndicator(
                              color: ColorsConstants.colorDefault,
                              strokeAlign: 3.0,
                              strokeWidth: 1.0,
                            )
                          : const Text(
                              "SIGN IN",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const RegisterScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                  opacity: animation, child: child);
                            },
                            transitionDuration:
                                const Duration(milliseconds: 1000),
                          ));
                    },
                    child: const Text(
                      "Already Have an Account? Sign up",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: ColorsConstants.colorDefault),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
