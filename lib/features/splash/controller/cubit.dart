import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salama/features/splash/controller/states.dart';
import 'package:salama/features/splash/model/splash_model.dart';

class SplashCubit extends Cubit<SplashStates> {
  SplashCubit() : super(SplashInitial());

  static SplashCubit get(context) => BlocProvider.of(context);

  void checkIfUserIsLoggedIn(SplashModel splashModel) {
    if (splashModel.isLoggedIn) {}
  }
}
