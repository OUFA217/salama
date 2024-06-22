import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salama/core/constants/colors_constants.dart';
import 'package:salama/core/services/shared_pref.dart';
import 'package:salama/features/sign_in/controller/states.dart';
import 'package:salama/features/sign_in/model/sign_in_model.dart';

class SignInCubit extends Cubit<SignInStates> {
  SignInCubit() : super(SignInInitialState());

  static SignInCubit get(context) => BlocProvider.of(context);

  bool showPassword = true;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changeShowPassword() {
    showPassword = !showPassword;
    emit(SignInChangeShowPasswordState());
  }

  void signIn(SignInModel model) {
    emit(SignInLoadingState());
    final response = auth.signInWithEmailAndPassword(
        email: model.email.trim(), password: model.password);
    response.then((value) {
      Fluttertoast.showToast(
          msg: 'Login Success', backgroundColor: ColorsConstants.colorgreen);
      CacheHelper.saveDate(key: 'uid', value: value.user!.uid);
      CacheHelper.saveDate(key: 'email', value: model.email);
      emit(SignInSuccessState());
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: error.toString(), toastLength: Toast.LENGTH_LONG);
      emit(SignInErrorState());
    });
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
