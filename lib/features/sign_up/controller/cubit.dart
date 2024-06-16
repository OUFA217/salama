import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:salama/features/sign_up/controller/states.dart';
import 'package:salama/features/sign_up/model/User.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit() : super(SignUpInitialState());

  static SignUpCubit get(context) => BlocProvider.of(context);

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController userNameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool showPassword = true;

  FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void changeShowPassword() {
    showPassword = !showPassword;
    emit(SignUpChangeShowPasswordState());
  }

  void signUp(SignUpUser user) async {
    user.email = emailController.text.trim();
    user.name = nameController.text;
    user.username = userNameController.text;
    user.password = passwordController.text;
    emit(SignUpLoadingState());

    final response = auth.createUserWithEmailAndPassword(
        email: user.email!, password: user.password!);
    _firestore.collection('users').doc(user.email).set(
        {'name': user.name, 'username': user.username, 'email': user.email});
    emit(SignUpLoadingFirebaseState());
    response.then((value) {
      emit(SignUpSuccessState());
      Logger().d(value.user);
    }).catchError((error) {
      Fluttertoast.showToast(msg: error.toString());
      emit(SignUpErrorState());
    });
  }
}
