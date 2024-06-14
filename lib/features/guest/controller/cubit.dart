import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:logger/logger.dart';
import 'package:salama/core/endpoint/api_endpoints.dart';
import 'package:salama/core/services/navigator_service.dart';
import 'package:salama/core/services/shared_pref.dart';
import 'package:salama/features/guest/controller/states.dart';
import 'package:salama/features/sign_in/view/sign_in_screen.dart';
import 'package:salama/features/sign_up/view/sign_up.dart';
import 'package:uuid/uuid.dart';

class GuestCubit extends Cubit<GuestStates> {
  GuestCubit() : super(GuestInitialState());
  static GuestCubit get(context) => BlocProvider.of(context);
  List<types.TextMessage> messages = [];

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    addMessage(textMessage);
  }

  void loadMessages() async {}

  void addMessage(types.TextMessage message) {
    final cachedLengthMessageBool = CacheHelper.getData(key: "length");

    Logger().e(cachedLengthMessageBool);

    int cachedLengthMessage = 0;

    if (cachedLengthMessageBool == true) {
      cachedLengthMessage = CacheHelper.getActualData(key: "length");
    }
    if (cachedLengthMessage == 10) {
      var context = NavigationService.navigatorKey.currentContext;

      showDialog(
        context: context!,
        builder: (context) {
          return AlertDialog(
            title: const Text("Guest User Can't Send More Than 10 Messages"),
            content: const Text("You can't send more than 10 messages"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const RegisterScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                                opacity: animation, child: child);
                          },
                          transitionDuration:
                              const Duration(milliseconds: 1200),
                        ));
                  },
                  child: const Text("Sign Up")),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const SignInScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                                opacity: animation, child: child);
                          },
                          transitionDuration:
                              const Duration(milliseconds: 1200),
                        ));
                  },
                  child: const Text("Sign In")),
            ],
          );
        },
      );
    } else {
      messages.insert(0, message);
      final messageUser = types.TextMessage(
        id: const Uuid().v4(),
        text: "Loading...",
        createdAt: DateTime.now().millisecondsSinceEpoch,
        author: anotherUser,
      );
      messages.insert(0, messageUser);

      emit(GuessLoadingMessageState());
      log(message.text.toString());
      Dio dio = Dio();
      final response =
          dio.post(apiUrl, data: {"user_input": message.text.toString()});
      emit(GuessLoadedMessageState());
      response.then((value) {
        final messageUser = types.TextMessage(
          id: const Uuid().v4(),
          text: value.data["chatbot_output"].toString().replaceAll("\n", ""),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          author: anotherUser,
        );
        messages.removeWhere((element) => element.text == "Loading...");
        messages.insert(0, messageUser);
        Logger().i(messages.length.toString());
        CacheHelper.saveDate(key: "length", value: messages.length);
        emit(GuestSentSuccessfullyMessageState());
      }).catchError((error) {
        log("the error is: $error");
      });
    }
  }

  void onMessageReceived(Message message) {
    // messages.add(message);
  }

  final user = const types.User(
      id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
      firstName: "زائر",
      imageUrl:
          "https://kirstymelmedlifecoach.com/wp-content/uploads/2020/10/279-2799324_transparent-guest-png-become-a-member-svg-icon.png");
  final anotherUser = const types.User(
    firstName: "سلامة",
    lastName: "مرشدك الاصطناعى",
    imageUrl: 'https://avatars.githubusercontent.com/u/39745173?v=4',
    id: '85091008-a484-4a89-ae75-a22bf8d6f3ac',
  );
}
