import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskplus/Const/TextStyle.dart';
import 'package:taskplus/Const/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/images/Logo.png'),
                ),
                SizedBox(
                  height: 30,
                ),
                Image(
                  image: AssetImage('assets/images/Get Started.png'),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Welcome back! Dive into productivity with our checklist app. Log in for easy task management. Your checklist journey begins now!",
                  style: Regular15,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: AppColor.whiteColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text("Login", style: semiBold18),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              key: Key('email_field'),
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide:
                                        BorderSide(color: AppColor.blackColor)),
                                filled: true,
                                fillColor: AppColor.secondColor,
                                labelStyle:
                                    TextStyle(color: AppColor.iconsColor),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                prefixIcon: Icon(Icons.email,
                                    color: AppColor.iconsColor),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              key: Key('password_field'),
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide:
                                        BorderSide(color: AppColor.blackColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide:
                                        BorderSide(color: AppColor.blackColor)),
                                filled: true,
                                fillColor: AppColor.secondColor,
                                labelStyle:
                                    TextStyle(color: AppColor.iconsColor),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                prefixIcon: Icon(Icons.lock,
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
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.greenColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                minimumSize: Size(150, 40),
                              ),
                              child: Text(
                                'Login',
                                style: RegularWhite15,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text.rich(
                              TextSpan(
                                text: "Don't have an account? ",
                                style: Regular12,
                                children: [
                                  TextSpan(
                                    text: "Sign up!",
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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
