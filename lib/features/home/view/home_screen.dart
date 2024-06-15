import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:salama/core/constants/colors_constants.dart';
import 'package:salama/core/size_handler/size_handler.dart';
import 'package:salama/core/widgets/custom_app_bar.dart';
import 'package:salama/features/home/controller/cubit.dart';
import 'package:salama/features/home/controller/states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
        final cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: const CustomAppBar(title: "Salama's Chat"),
          body: SizedBox(
            height: SizeHandler.getHegiht(context) * 0.9,
            child: Chat(
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
          ),
        );
      }),
    );
  }
}
