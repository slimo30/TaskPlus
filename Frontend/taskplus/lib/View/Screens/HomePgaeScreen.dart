import 'package:flutter/material.dart';
import 'package:taskplus/Const/colors.dart';
import 'package:taskplus/View/Screens/HistoryScreen.dart';
import 'package:taskplus/View/Screens/InviteScreen.dart';
import 'package:taskplus/View/Screens/MissionsScreen.dart';
import 'package:taskplus/View/Screens/MyTasksScreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blackColor,
      body: Stack(
        children: [
          _getBody(_selectedIndex),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 70,
              color: AppColor.blackColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildNavItem(Icons.assignment, 'Missions', 0),
                  _buildNavItem(Icons.assignment_turned_in, 'My tasks', 1),
                  _buildNavItem(Icons.history, 'History', 2),
                  _buildNavItem(Icons.person_add, 'Invite', 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        _onItemTapped(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: index == _selectedIndex
                ? AppColor.greenColor
                : AppColor.secondColor,
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: index == _selectedIndex
                  ? AppColor.greenColor
                  : AppColor.secondColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return const MissionsScreen();
      case 1:
        return const MyTasksScreen();
      case 2:
        return const HistoryScreen();
      case 3:
        return const InviteScreen();
      default:
        return const MissionsScreen();
    }
  }
}
