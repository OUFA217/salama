import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:salama/core/endpoint/api_endpoints.dart';
import 'package:salama/features/guest/controller/states.dart';
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
    try {
      messages.insert(0, message);
      emit(GuessLoadingMessageState());
      log(message.text.toString());
      Dio dio = Dio();
      final response =
          dio.post(apiUrl, data: {"user_input": message.text.toString()});
      emit(GuessLoadedMessageState());
      response.then((value) {
        final messageUser = types.TextMessage(
          id: const Uuid().v4(),
          text: value.data["chatbot_output"],
          createdAt: DateTime.now().millisecondsSinceEpoch,
          author: anotherUser,
        );
        messages.insert(0, messageUser);
        log(messages.toString());
        emit(GuestSentSuccessfullyMessageState());
      }).catchError((error) {
        log("the error is: $error");
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void onMessageReceived(Message message) {
    // messages.add(message);
  }

  final user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );
  final anotherUser = const types.User(
    id: '85091008-a484-4a89-ae75-a22bf8d6f3ac',
  );
}
