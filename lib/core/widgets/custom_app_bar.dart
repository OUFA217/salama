import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salama/core/constants/colors_constants.dart';
import 'package:salama/core/constants/image_constants.dart';
import 'package:salama/core/size_handler/size_handler.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});
  final String title;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorsConstants.colorDefault,
      title: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.raleway(
                color: Colors.white,
                fontSize: SizeHandler.getHegiht(context) * 0.03),
          ),
          const Spacer(),
          CircleAvatar(
            radius: 25,
            backgroundColor: ColorsConstants.colorDefault,
            child: Hero(
              tag: "Logo",
              child: Image.asset(
                ImageConstants.logo,
                fit: BoxFit.fill,
              ),
            ),
          )
        ],
      ),
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false, // Remove the back button
    );
  }
}
