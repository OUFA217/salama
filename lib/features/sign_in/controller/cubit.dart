import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salama/features/sign_in/controller/states.dart';
import 'package:salama/features/sign_in/model/sign_in_model.dart';

class SignInCubit extends Cubit<SignInStates> {
  SignInCubit() : super(SignInInitialState());

  static SignInCubit get(context) => BlocProvider.of(context);

  bool showPassword = true;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  void changeShowPassword() {
    showPassword = !showPassword;
    emit(SignInChangeShowPasswordState());
  }

  void signIn(SignInModel model) {}
}
