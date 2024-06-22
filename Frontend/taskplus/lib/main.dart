import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskplus/Controller/themeProvider.dart';
import 'package:taskplus/firbaseClass.dart';
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
  String? token = await getTokenFromPrefs();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool isDarkMode = prefs.getBool(themeKey) ?? false;
 await FirebaseApi().initNotifications();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(isDarkMode),
      child: MyApp(token: token),
    ),
  );
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
      themeMode: Provider.of<ThemeProvider>(context).isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
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
