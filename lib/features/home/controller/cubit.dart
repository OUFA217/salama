import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:logger/logger.dart';
import 'package:salama/core/endpoint/api_endpoints.dart';
import 'package:salama/core/services/shared_pref.dart';
import 'package:salama/features/home/controller/states.dart';
import 'package:salama/features/home/model/home_model.dart';
import 'package:salama/features/home/model/home_user_model.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void removeMesssageFromFirestore(types.TextMessage message) {
    _firestore
        .collection('messages')
        .doc(CacheHelper.getActualData(key: "email"))
        .collection('messages')
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
      'text': message.text != "Loading..."
          ? arabicWords
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", "")
              .replaceAll(",", "")
          : message.text,
      'createdAt': Timestamp.fromMillisecondsSinceEpoch(message.createdAt!),
      'userId': message.author.id,
    };

    _firestore
        .collection('messages')
        .doc(CacheHelper.getActualData(key: "email"))
        .collection('messages')
        .add(messageData);
  }

  void _loadMessagesFromFirestore() {
    _firestore
        .collection('messages')
        .doc(CacheHelper.getActualData(key: "email"))
        .collection('messages')
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
    _firestore
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
      id: model.aiUser!.id!,
      text: "Loading...",
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
      RegExp regExp = RegExp(r'[\u0600-\u06FF\u0750-\u077F]+');
      Iterable<RegExpMatch> matches = regExp.allMatches(
          value.data["chatbot_output"].toString().replaceAll("\n", ""));
      List<String> arabicWords =
          matches.map((match) => match.group(0)!).toList();
      final messageUser = types.TextMessage(
        id: model.aiUser!.id!,
        text: arabicWords
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", "")
            .replaceAll(",", ""),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        author: aiUser,
      );
      messages.removeWhere((element) => element.text == "Loading...");
      removeMesssageFromFirestore(messageUserLoading);
      messages.insert(0, messageUser);
      emit(HomeSuccessState());

      _saveMessageToFirestore(messageUser);
    }).catchError((error) {
      Logger().e(error.toString());
    });
  }
}
