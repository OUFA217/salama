import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salama/core/constants/colors_constants.dart';
import 'package:salama/core/widgets/background.dart';
import 'package:salama/features/sign_in/view/sign_in_screen.dart';
import 'package:salama/features/sign_up/controller/cubit.dart';
import 'package:salama/features/sign_up/controller/states.dart';
import 'package:salama/features/sign_up/model/User.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocConsumer<SignUpCubit, SignUpStates>(listener: (context, state) {
      if (state is SignUpSuccessState) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const SignInScreen(),
            transitionDuration: const Duration(milliseconds: 1000),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    }, builder: (context, state) {
      final cubit = SignUpCubit.get(context);

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
                    "REGISTER",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorsConstants.colorDefault,
                        fontSize: 36),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: cubit.nameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: cubit.userNameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(labelText: "Username"),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: cubit.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
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
                SizedBox(height: size.height * 0.05),
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
                      if (state is SignUpLoadingState ||
                          state is SignUpLoadingFirebaseState) {
                      } else {
                        FocusScope.of(context).unfocus();

                        if (cubit.passwordController.text.isNotEmpty &&
                            cubit.emailController.text.isNotEmpty &&
                            cubit.nameController.text.isNotEmpty &&
                            cubit.userNameController.text.isNotEmpty) {
                          cubit.signUp(SignUpUser(
                            username: cubit.userNameController.text,
                            email: cubit.emailController.text,
                            name: cubit.nameController.text,
                            password: cubit.passwordController.text,
                          ));
                        } else if (cubit.nameController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please Enter Your Name",
                              backgroundColor: Colors.red);
                        } else if (cubit.emailController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please Enter Your Email",
                              backgroundColor: Colors.red);
                        } else if (cubit.userNameController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please Enter Your Username",
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
                      width: size.width * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient: const LinearGradient(colors: [
                            Color.fromARGB(255, 255, 136, 34),
                            Color.fromARGB(255, 255, 177, 41)
                          ])),
                      padding: const EdgeInsets.all(0),
                      child: state is SignUpLoadingState ||
                              state is SignUpLoadingFirebaseState
                          ? const CircularProgressIndicator(
                              color: ColorsConstants.colorDefault,
                              strokeAlign: 3.0,
                              strokeWidth: 1.0,
                            )
                          : const Text(
                              "SIGN UP",
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
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const SignInScreen(),
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
                      "Already Have an Account? Sign in",
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
