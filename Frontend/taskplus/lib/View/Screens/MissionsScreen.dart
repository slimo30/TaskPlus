import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskplus/Const/TextStyle.dart';
import 'package:taskplus/Const/colors.dart';
import 'package:taskplus/View/Widgets/Appbar.dart';

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({Key? key}) : super(key: key);

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  String username = " Slimane";
  String workscpace = "Tekkolllab";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutLeadingWithActions(
          "Missions", AppColor.blackColor, context, () {}),
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              child: Column(children: [
                Container(
                  height: 100,
                  child: Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        width: MediaQuery.of(context).size.width * 0.55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColor.blackColor),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello , ${username}",
                              style: semiBold20,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image(
                                  image: AssetImage('assets/images/Logo.png'),
                                  width: 25,
                                ),
                                Text(
                                  "Start working at, ${workscpace}",
                                  style: Regular12,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          width: MediaQuery.of(context).size.width * 0.30,
                          decoration: BoxDecoration(
                            color: AppColor.greenColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.whiteColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: AppColor.greenColor,
                                    )),
                                SizedBox(
                                  height: 13,
                                ),
                                Text(
                                  "New Mission",
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.whiteColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
