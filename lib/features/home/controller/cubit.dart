import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:salama/core/endpoint/api_endpoints.dart';
import 'package:salama/core/services/shared_pref.dart';
import 'package:salama/features/home/controller/states.dart';
import 'package:salama/features/home/model/home_model.dart';
import 'package:salama/features/home/model/home_user_model.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState()) {
    _initializeUser();
  }
  static HomeCubit get(context) => BlocProvider.of(context);

  List<types.TextMessage> messages = [];
  late types.User user;
  late HomeModel model;
  late types.User aiUser;

  void _initializeUser() {
    model = HomeModel(
        user: HomeUserModel(
          name: CacheHelper.getActualData(key: "userName"),
          id: CacheHelper.getActualData(key: "uid").toString(),
        ),
        aiUser: HomeUserModel(
          name: "سلامة, مرشدك الاصطناعى",
          id: "1",
        ));

    user = types.User(
        id: model.user!.id!,
        firstName: model.user!.name,
        imageUrl:
            "https://kirstymelmedlifecoach.com/wp-content/uploads/2020/10/279-2799324_transparent-guest-png-become-a-member-svg-icon.png");

    aiUser = types.User(
        id: model.aiUser!.id!,
        firstName: model.aiUser!.name,
        imageUrl: 'https://avatars.githubusercontent.com/u/39745173?v=4');
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: model.user!.id!,
      text: message.text,
    );

    addMessage(textMessage);
  }

  void loadMessages() {
    messages = [
      types.TextMessage(
        id: model.aiUser!.id!,
        text: "Loading...",
        createdAt: DateTime.now().millisecondsSinceEpoch,
        author: aiUser,
      )
    ];
    emit(HomeLoadingState());
  }

  void addMessage(types.TextMessage message) {
    messages.insert(0, message);

    final messageUser = types.TextMessage(
      id: model.aiUser!.id!,
      text: "Loading...",
      createdAt: DateTime.now().millisecondsSinceEpoch,
      author: aiUser,
    );
    messages.insert(0, messageUser);

    emit(HomeLoadingState());

    Dio dio = Dio();
    final response = dio.post(apiUrl, data: {
      "user_input": message.text.toString(),
    });
    response.then((value) {
      final messageUser = types.TextMessage(
        id: model.aiUser!.id!,
        text: value.data["chatbot_output"].toString().replaceAll("\n", ""),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        author: aiUser,
      );
      messages.removeWhere((element) => element.text == "Loading...");
      messages.insert(0, messageUser);
      emit(HomeSuccessState());
    }).catchError((error) {});
  }
}
