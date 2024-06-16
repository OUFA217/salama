import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:salama/core/constants/colors_constants.dart';
import 'package:salama/core/size_handler/size_handler.dart';
import 'package:salama/core/widgets/custom_app_bar.dart';
import 'package:salama/features/guest/controller/cubit.dart';
import 'package:salama/features/guest/controller/states.dart';
import 'package:salama/features/sign_in/view/sign_in_screen.dart';
import 'package:salama/features/sign_up/view/sign_up.dart';

class GuestScreen extends StatelessWidget {
  const GuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuestCubit(),
      child: BlocBuilder<GuestCubit, GuestStates>(builder: (context, state) {
        final cubit = GuestCubit.get(context);
        log(state.toString());
        return Scaffold(
          appBar: const CustomAppBar(title: "Guest Salama's Chat"),
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
                        const Text("Guest User",
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 10),
                        const Text(
                          "Guest Salama's Chat",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SignInScreen(),
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
                            foregroundColor: ColorsConstants.colorDefault,
                            backgroundColor: Colors.white,
                          ),
                          child: const Text('Sign In'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const RegisterScreen(),
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
                            foregroundColor: ColorsConstants.colorDefault,
                            backgroundColor: Colors.white, // Text color
                          ),
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                  ),
                ])),
          ),
          body: Chat(
              l10n: const ChatL10nAr(),
              theme: const DefaultChatTheme(
                  inputBackgroundColor: ColorsConstants.colorDefault,
                  highlightMessageColor: ColorsConstants.colorDefault,
                  sentMessageDocumentIconColor: ColorsConstants.colorDefault,
                  primaryColor: ColorsConstants.colorDefault),
              showUserNames: true,
              showUserAvatars: true,
              messages: cubit.messages,
              onSendPressed: cubit.handleSendPressed,
              user: cubit.user),
        );
      }),
    );
  }
}
