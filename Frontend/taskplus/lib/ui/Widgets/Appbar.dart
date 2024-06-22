import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskplus/utils/colors.dart';

AppBar customAppBar(
    String titleText, Color containerColor, BuildContext context) {
  return AppBar(
    toolbarHeight: 80,
    backgroundColor: AppColor.blackColor,
    title: Text(
      titleText,
      style: GoogleFonts.inter(
        fontSize: 23,
        fontWeight: FontWeight.w700,
        color: AppColor.greenColor,
      ),
    ),
    centerTitle: true,
    leading: Row(
      children: [
        SizedBox(width: 40),
        Container(
          child: GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context); // Navigate back if possible
              } else {
                print("There is no route to pop.");
              }
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColor.greenColor,
              size: 30,
            ),
          ),
        ),
      ],
    ),
    leadingWidth: 100,
  );
}

AppBar customAppBarwithoutleading(
    String titleText, Color containerColor, BuildContext context) {
  return AppBar(
    toolbarHeight: 80,
    backgroundColor: AppColor.blackColor,
    title: Text(
      titleText,
      style: GoogleFonts.inter(
        fontSize: 23,
        fontWeight: FontWeight.w700,
        color: AppColor.greenColor,
      ),
    ),
    centerTitle: true,
  );
}

AppBar customAppBarWithoutLeadingWithActions(String titleText,
    Color containerColor, BuildContext context, Function() onSettingsPressed) {
  return AppBar(
    toolbarHeight: 80,
    backgroundColor: AppColor.blackColor,
    title: Text(
      titleText,
      style: GoogleFonts.inter(
        fontSize: 23,
        fontWeight: FontWeight.w700,
        color: AppColor.greenColor,
      ),
    ),
    centerTitle: true,
    automaticallyImplyLeading: false, // This line removes the leading arrow
    actions: [
      IconButton(
        onPressed: onSettingsPressed,
        icon: Icon(
          Icons.settings,
          color: AppColor.whiteColor,
        ),
      ),
    ],
  );
}
