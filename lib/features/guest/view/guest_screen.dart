import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:salama/core/constants/colors_constants.dart';
import 'package:salama/core/widgets/custom_app_bar.dart';
import 'package:salama/features/guest/controller/cubit.dart';
import 'package:salama/features/guest/controller/states.dart';

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
          appBar: const CustomAppBar(title: "Salama's Chat"),
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
