import 'package:flutter/material.dart';
import 'package:taskplus/Const/colors.dart';
import 'package:taskplus/View/Widgets/Appbar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          customAppBarwithoutleading("History", AppColor.blackColor, context),
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 800,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
