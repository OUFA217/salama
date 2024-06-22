import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:salama/core/constants/colors_constants.dart';
import 'package:salama/core/services/shared_pref.dart';
import 'package:salama/core/size_handler/size_handler.dart';
import 'package:salama/core/widgets/custom_app_bar.dart';
import 'package:salama/features/guest/view/guest_screen.dart';
import 'package:salama/features/home/controller/cubit.dart';
import 'package:salama/features/home/controller/states.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
        final cubit = HomeCubit.get(context);
        return Scaffold(
          drawer: Drawer(
            width: SizeHandler.getWidth(context) * 0.6,
            child: Container(
                color: ColorsConstants.colorDefault,
                child: ListView(children: [
                  DrawerHeader(
                    child: Center(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 10),
                        Text(cubit.userName ?? "Guest",
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 10),
                        Text(cubit.name ?? "Guest",
                            style: TextStyle(color: Colors.white)),
                      ],
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // ListView.builder(itemBuilder: (context, index) {
                        //   return null;
                        // }),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.55),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Feedback'),
                                  content: Container(
                                    child: TextField(
                                      maxLines: 5,
                                      minLines: 5,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.done,
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      controller: cubit.feedbackController,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        cubit.firestore
                                            .collection('messages')
                                            .doc(CacheHelper.getActualData(
                                                key: "email"))
                                            .get()
                                            .then((value) {
                                          log(value.exists.toString());
                                          log(value.data().toString());
                                          if (value.exists) {
                                            cubit.firestore
                                                .collection('messages')
                                                .doc(CacheHelper.getActualData(
                                                    key: "email"))
                                                .update({
                                              "Feedback":
                                                  cubit.feedbackController.text
                                            }).then((value) {
                                              cubit.feedbackController.clear();

                                              Navigator.pop(context);
                                            }).catchError((e) {
                                              log(e.toString());
                                            });
                                          } else {
                                            cubit.firestore
                                                .collection('messages')
                                                .doc(CacheHelper.getActualData(
                                                    key: "email"))
                                                .set({
                                              "Feedback":
                                                  cubit.feedbackController.text
                                            }).then((value) {
                                              cubit.feedbackController.clear();
                                              Navigator.pop(context);
                                            }).catchError((e) {
                                              log(e.toString());
                                            });
                                          }
                                        });
                                      },
                                      child: const Text(
                                        'Submit',
                                        style: TextStyle(
                                            color:
                                                ColorsConstants.colorDefault),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        cubit.feedbackController.clear();

                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(SizeHandler.getWidth(context) * 0.5,
                                SizeHandler.getHegiht(context) * 0.06),
                            foregroundColor: ColorsConstants.colorDefault,
                            backgroundColor: Colors.white, // Text color
                          ),
                          child: const Text('Leave a Feedback'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            CacheHelper.sharedPreferences!.clear();
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const GuestScreen(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                        opacity: animation, child: child);
                                  },
                                  transitionDuration:
                                      const Duration(milliseconds: 1200),
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                const Color.fromARGB(255, 255, 8, 8),
                            backgroundColor: Colors.white, // Text color
                          ),
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
                  ),
                ])),
          ),
          appBar: const CustomAppBar(title: "Salama's Chat"),
          body: SizedBox(
            height: SizeHandler.getHegiht(context) * 0.9,
            child: Stack(
              children: [
                Chat(
                    l10n: const ChatL10nAr(),
                    theme: const DefaultChatTheme(
                        inputBackgroundColor: ColorsConstants.colorDefault,
                        highlightMessageColor: ColorsConstants.colorDefault,
                        sentMessageDocumentIconColor:
                            ColorsConstants.colorDefault,
                        primaryColor: ColorsConstants.colorDefault),
                    messages: cubit.messages,
                    onSendPressed: cubit.handleSendPressed,
                    showUserAvatars: true,
                    user: cubit.user),
                Positioned(child: Container())
              ],
            ),
          ),
        );
      }),
    );
  }
}
