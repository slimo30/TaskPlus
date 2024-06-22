import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskplus/Controller/themeProvider.dart';
import 'package:taskplus/utils/TextStyle.dart';
import 'package:taskplus/utils/colors.dart';
import 'package:taskplus/utils/link.dart';
import 'package:taskplus/Controller/Authentification.dart';
import 'package:taskplus/Controller/MmberServices.dart';
import 'package:taskplus/Model/Member.dart';
import 'package:taskplus/Model/user.dart';
import 'package:taskplus/ui/Screens/HomePgaeScreen.dart';
import 'package:taskplus/ui/Screens/InviteScreen.dart';
import 'package:taskplus/ui/Screens/SignupScreen.dart';
import 'package:taskplus/ui/Screens/workspaceScreen.dart';
import 'package:taskplus/ui/Widgets/Button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.requestPermission();

    _firebaseMessaging.getToken().then((token) async {
      print("Device Token: $token");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('device_token', token!);
    });
  }

  @override
  void dispose() {
    // Dispose of the text editing controllers
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  bool _obscurePassword = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColor.blackColor : AppColor.backgroundColor,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                const Image(
                  image: AssetImage('assets/images/Logo.png'),
                ),
                const SizedBox(
                  height: 30,
                ),
                Image(
                  image: AssetImage(!isDarkMode
                      ? 'assets/images/Get Started.png'
                      : 'assets/images/Get Started2.png'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Welcome back! Dive into productivity with our checklist app. Log in for easy task management. Your checklist journey begins now!",
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color:
                        !isDarkMode ? AppColor.blackColor : AppColor.whiteColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: !isDarkMode
                      ? AppColor.whiteColor
                      : AppColor.darkModeBackgroundColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text("Login",
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: !isDarkMode
                                      ? AppColor.blackColor
                                      : AppColor.whiteColor,
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              key: const Key('email_field'),
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                        color: AppColor.blackColor)),
                                filled: true,
                                fillColor: AppColor.secondColor,
                                labelStyle: GoogleFonts.inter(
                                    color: AppColor.iconsColor),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                prefixIcon: const Icon(Icons.email,
                                    color: AppColor.iconsColor),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              key: const Key('password_field'),
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                        color: AppColor.blackColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                        color: AppColor.blackColor)),
                                filled: true,
                                fillColor: AppColor.secondColor,
                                labelStyle: GoogleFonts.inter(
                                    color: AppColor.iconsColor),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                prefixIcon: const Icon(Icons.lock,
                                    color: AppColor.iconsColor),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  child: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppColor.iconsColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomElevatedButton(
                              onPressed: () async {
                                AuthenticationService authService =
                                    AuthenticationService();
                                if (!validateEmail(emailController.text)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Enter a valid email'),
                                    ),
                                  );
                                  return;
                                }

                                User user = User(
                                  username: emailController.text,
                                  password: passwordController.text,
                                );

                                final response = await authService.login(user);

                                if (response == null ||
                                    !response.containsKey('token')) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Login failed')),
                                  );
                                  return;
                                }

                                int id = await getMemberIdFromPrefs();
                                MemberService memberService =
                                    MemberService(baseUrl: baseurl);
                                Member member =
                                    await memberService.getMember(id);

                                Member newmember = Member(
                                  id: member.id,
                                  // password: member.password,
                                  username: member.username,
                                  superuser: member.superuser,
                                  name: member.name,
                                  deviceToken: await getDeviceTokenFromPrefs(),
                                  workspace: member.workspace,
                                );

                                await memberService.updateMember(newmember);

                                if (member.workspace != null) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage()),
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            WorkspaceScreen()),
                                  );
                                }
                              },
                              text: 'Login',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              child: Text.rich(
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: !isDarkMode
                                        ? AppColor.blackColor
                                        : AppColor.whiteColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Sign up!",
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen(),
                                    ));
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool validateEmail(String email) {
  final RegExp regex =
      RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
  return regex.hasMatch(email);
}
