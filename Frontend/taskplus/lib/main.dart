import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskplus/Const/colors.dart';
import 'package:taskplus/Controller/Authentification.dart';
import 'package:taskplus/View/Screens/HomePgaeScreen.dart';
import 'package:taskplus/View/Screens/InviteScreen.dart';
import 'package:taskplus/View/Screens/LoginScreen.dart';
import 'package:taskplus/View/Screens/ScanScreen.dart';
import 'package:taskplus/View/Screens/SignupScreen.dart';
import 'package:taskplus/View/Screens/workspaceScreen.dart';
import 'package:taskplus/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await removeAllInfoFromPrefs();
  String? token = await getTokenFromPrefs();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(token: token));
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
