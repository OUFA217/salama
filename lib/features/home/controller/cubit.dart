import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:logger/logger.dart';
import 'package:salama/core/endpoint/api_endpoints.dart';
import 'package:salama/core/services/shared_pref.dart';
import 'package:salama/features/home/controller/states.dart';
import 'package:salama/features/home/model/home_model.dart';
import 'package:salama/features/home/model/home_user_model.dart';
import 'package:uuid/uuid.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState()) {
    _initializeUser();
    _loadMessagesFromFirestore();
  }
  static HomeCubit get(context) => BlocProvider.of(context);

  List<types.TextMessage> messages = [];
  late types.User user;
  late HomeModel model;
  late types.User aiUser;
  int index = 0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController feedbackController = TextEditingController();
  void removeMesssageFromFirestore(types.TextMessage message) {
    firestore
        .collection('messages')
        .doc(CacheHelper.getActualData(key: "email"))
        .collection('messages$index')
        .where('text', isEqualTo: message.text)
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    emit(HomeRemoveMessageFirebaseState());
  }

  void _saveMessageToFirestore(types.TextMessage message) {
    RegExp regExp = RegExp(r'[\u0600-\u06FF\u0750-\u077F]+');
    Iterable<RegExpMatch> matches = regExp.allMatches(message.text);
    List<String> arabicWords = matches.map((match) => match.group(0)!).toList();
    log((message.author.id == model.aiUser!.id).toString());
    final messageData = {
      'text': message.text != "Salama is Typing..."
          ? arabicWords
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", "")
              .replaceAll(",", "")
          : message.text,
      'createdAt': Timestamp.fromMillisecondsSinceEpoch(message.createdAt!),
      'userId': message.author.id,
    };

    firestore
        .collection('messages')
        .doc(CacheHelper.getActualData(key: "email"))
        .collection('messages$index')
        .add(messageData);
  }

  void _loadMessagesFromFirestore({int chatLength = 0}) {
    index = chatLength;
    firestore
        .collection('messages')
        .doc(CacheHelper.getActualData(key: "email"))
        .collection('messages$index')
        .orderBy('createdAt', descending: true)
        .get()
        .then((snapshot) {
      messages = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return types.TextMessage(
          author: data['userId'] == user.id ? user : aiUser,
          createdAt: (data['createdAt'] as Timestamp).millisecondsSinceEpoch,
          id: doc.id,
          text: data['text'],
        );
      }).toList();
      emit(HomeLoadingMessageFirebaseState());
    });
  }

  String? userName;
  String? name;
  void _initializeUser() {
    firestore
        .collection("users")
        .doc(CacheHelper.getActualData(key: "email"))
        .get()
        .then((value) {
      userName = value.data()!["username"];
      name = value.data()!["name"];
    });
    model = HomeModel(
        user: HomeUserModel(
          name: CacheHelper.getActualData(key: "userName"),
          id: CacheHelper.getActualData(key: "uid").toString(),
        ),
        aiUser: HomeUserModel(
          name: "سلامة, مرشدك الاصطناعى",
          id: "${CacheHelper.getActualData(key: "uid")}5",
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
    emit(HomeInitializeUserState());
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: model.user!.id!,
      text: message.text.toString(),
    );

    addMessage(textMessage);
  }

  void addMessage(types.TextMessage message) {
    messages.insert(0, message);
    emit(HomeSuccessState());
    _saveMessageToFirestore(message);

    final messageUserLoading = types.TextMessage(
      id: const Uuid().v4(),
      text: "Salama is Typing...",
      createdAt: DateTime.now().millisecondsSinceEpoch,
      author: aiUser,
    );
    messages.insert(0, messageUserLoading);
    emit(HomeSuccessState());

    _saveMessageToFirestore(messageUserLoading);

    Dio dio = Dio();
    final response = dio.post(apiUrl, data: {
      "user_input": message.text.toString(),
    });
    response.then((value) {
      final messageUser = types.TextMessage(
        id: model.aiUser!.id!,
        text: value.data["chatbot_output"],
        createdAt: DateTime.now().millisecondsSinceEpoch,
        author: aiUser,
      );
      messages.removeWhere((element) => element.text == "Salama is Typing...");
      removeMesssageFromFirestore(messageUserLoading);
      messages.insert(0, messageUser);
      emit(HomeSuccessState());

      _saveMessageToFirestore(messageUser);
    }).catchError((error) {
      Logger().e(error.toString());
      log(error.toString());
      emit(HomeErrorState(error.toString()));
    });
  }
}
