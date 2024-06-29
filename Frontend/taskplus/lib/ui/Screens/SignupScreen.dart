import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:taskplus/Controller/themeProvider.dart';
import 'package:taskplus/utils/TextStyle.dart';
import 'package:taskplus/utils/colors.dart';
import 'package:taskplus/Model/user.dart';
import 'package:taskplus/ui/Screens/LoginScreen.dart';
import 'package:taskplus/ui/Widgets/Button.dart';

import '../../Controller/Authentification.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordverficationController =
      TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscurePasswordver = true;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordverficationController.dispose();
    fullnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColor.blackColor : AppColor.backgroundColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: 2000,
          width: double.infinity,
          child: Stack(
            children: [
              const Positioned(
                child: Image(
                  image: AssetImage(
                    'assets/images/bg1.png',
                  ),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 250,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
                child: Container(
                  color: isDarkMode
                      ? AppColor.darkModeBackgroundColor
                      : AppColor.whiteColor,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              "Sign Up",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: !isDarkMode
                                    ? AppColor.blackColor
                                    : AppColor.whiteColor,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              key: const Key('full_name_field'),
                              controller: fullnameController,
                              decoration: InputDecoration(
                                labelText: 'Full name',
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
                                prefixIcon: const Icon(Icons.person,
                                    color: AppColor.iconsColor),
                              ),
                            ),
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
                            const SizedBox(
                              height: 20,
                            ),
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
                            TextFormField(
                              key: const Key('passwordver_field'),
                              controller: passwordverficationController,
                              obscureText: _obscurePasswordver,
                              decoration: InputDecoration(
                                labelText: 'Password verification',
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
                                      _obscurePasswordver =
                                          !_obscurePasswordver;
                                    });
                                  },
                                  child: Icon(
                                    _obscurePasswordver
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
                                if (fullnameController.text.isEmpty ||
                                    passwordverficationController
                                        .text.isEmpty ||
                                    passwordController.text.isEmpty ||
                                    emailController.text.isEmpty ||
                                    passwordverficationController
                                        .text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Please fill all the fields'),
                                    ),
                                  );
                                  return;
                                }
                                AuthenticationService authServicesignup =
                                    AuthenticationService();

                                if (!validateEmail(emailController.text)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Enter a valid email'),
                                    ),
                                  );
                                  return;
                                }

                                if (passwordController.text !=
                                    passwordverficationController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Passwords do not match'),
                                    ),
                                  );
                                  return;
                                }

                                User2 user = User2(
                                  username: emailController.text,
                                  password: passwordController.text,
                                  name: fullnameController.text,
                                );

                                // Call the signup method
                                int statusCode =
                                    await authServicesignup.signup(user);
                                if (statusCode == 201) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Sign up successful'),
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Sign up failed'),
                                    ),
                                  );
                                }
                              },
                              text: "Sign Up",
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              child: Text.rich(
                                TextSpan(
                                  text: "Already have an account? ",
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: !isDarkMode
                                        ? AppColor.blackColor
                                        : AppColor.whiteColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Login!",
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: !isDarkMode
                                            ? AppColor.blackColor
                                            : AppColor.whiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ));
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
