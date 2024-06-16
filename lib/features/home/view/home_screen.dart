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
  const HomeScreen({super.key});

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
                        SizedBox(height: SizeHandler.getHegiht(context) * 0.6),
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
