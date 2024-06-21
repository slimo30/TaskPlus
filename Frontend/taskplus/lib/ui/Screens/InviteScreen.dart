import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:taskplus/Controller/themeProvider.dart';

import 'package:taskplus/ui/Widgets/Appbar.dart';
import 'package:taskplus/ui/Widgets/Button.dart';
import 'package:mailer/mailer.dart';
import 'package:taskplus/utils/TextStyle.dart';
import 'package:taskplus/utils/colors.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({Key? key}) : super(key: key);

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  final TextEditingController emailController = TextEditingController();
  String data = " test";
  Future<void> sendInvitation(String email, String data) async {
    final smtpServer = gmail('islamwork30@gmail.com', 'fubp qfmf ycrm ksyl');

    final message = Message()
      ..from = Address('slimanework30@gmail.com', 'Slimane Houach')
      ..recipients.add(email)
      ..subject = 'Invitation to TaskPlus'
      ..html = """
    <div style="font-family: Arial, sans-serif; padding: 20px; color: #333;">
      <h1 style="color: #333;">Welcome to TaskPlus!</h1>
      <p style="font-size: 18px;">You have been invited to join TaskPlus. Use the following invitation code to complete your registration:</p>
      <div style="font-size: 24px; color: #2a9d8f; font-weight: bold; margin: 20px 0;">$data</div>
      <p style="font-size: 18px;">We're excited to have you on board.</p>
      <p style="font-size: 18px;">Best,</p>
      <p style="font-size: 18px;">Slimane Houach</p>
    </div>
  """;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invitation sent successfully'),
        ),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send invitation'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar:
          customAppBarwithoutleading("Invite", AppColor.blackColor, context),
      backgroundColor:
          isDarkMode ? AppColor.blackColor : AppColor.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      color: !isDarkMode
                          ? AppColor.whiteColor
                          : AppColor.darkModeBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text("Invite Member",
                                    style: GoogleFonts.inter(
                                      color: !isDarkMode
                                          ? AppColor.blackColor
                                          : AppColor.whiteColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      // Semi-bold (w600)
                                    )),
                                const SizedBox(height: 20),
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
                                          color: AppColor.blackColor),
                                    ),
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
                                CustomElevatedButton(
                                  onPressed: () {
                                    if (emailController.text.isNotEmpty) {
                                      sendInvitation(
                                          emailController.text, data);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Please enter an email',
                                            style: GoogleFonts.inter(
                                              color: !isDarkMode
                                                  ? AppColor.blackColor
                                                  : AppColor.whiteColor,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  text: 'Invite',
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Scan Qr code",
                  style: GoogleFonts.inter(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color:
                        !isDarkMode ? AppColor.blackColor : AppColor.whiteColor,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: QrImageView(
                    data: data,
                    version: QrVersions.auto,
                    size: 230,
                    backgroundColor: Colors.white,
                    gapless: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
