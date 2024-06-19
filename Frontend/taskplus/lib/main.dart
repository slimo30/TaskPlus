import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskplus/ui/Screens/MissionDetailsScreen.dart';
import 'package:taskplus/utils/colors.dart';
import 'package:taskplus/Controller/Authentification.dart';
import 'package:taskplus/Controller/workspaceService.dart';
import 'package:taskplus/Model/workspca2.dart';
import 'package:taskplus/ui/Screens/HomePgaeScreen.dart';
import 'package:taskplus/ui/Screens/InviteScreen.dart';
import 'package:taskplus/ui/Screens/LoginScreen.dart';
import 'package:taskplus/ui/Screens/ScanScreen.dart';
import 'package:taskplus/ui/Screens/SignupScreen.dart';
import 'package:taskplus/ui/Screens/workspaceScreen.dart';
import 'package:taskplus/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await removeAllInfoFromPrefs();
  String? token = await getTokenFromPrefs();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(token: token));

  // Create a workspace
  // print('\nCreating workspace...');
  // try {
  //   var workspace = new Workspace2(name: "name", sector: "sector");
  //   await WorkspaceService.creatWorkspcae(workspace);
  //   print('Workspace created successfully');
  // } catch (e) {
  //   print('Error creating workspace: $e');
  // }
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({Key? key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.greenColor),
        useMaterial3: true,
      ),
      home: token == null ? LoginScreen() : MyHomePage(),

      //  MyHomePage(),
      //  ScanScreen(),
      // InviteScreen()
      // const LoginScreen(),
      // ScanScreen(),
      // const WorkspaceScreen(),
      // const SignupScreen(),
    );
  }
}
