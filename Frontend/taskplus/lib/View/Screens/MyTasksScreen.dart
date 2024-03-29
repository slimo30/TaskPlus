import 'package:flutter/material.dart';
import 'package:taskplus/Const/colors.dart';
import 'package:taskplus/View/Widgets/Appbar.dart';

class MyTasksScreen extends StatefulWidget {
  const MyTasksScreen({Key? key}) : super(key: key);

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarwithoutleading("My Tasks", AppColor.blackColor,
          context), // Changed the app bar title to "My Tasks"
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Container(
          height: 50,
          color: Colors.yellow,
        ),
      ),
    );
  }
}
