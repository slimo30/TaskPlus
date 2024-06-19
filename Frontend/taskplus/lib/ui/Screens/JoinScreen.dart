import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskplus/utils/colors.dart';
import 'package:taskplus/Controller/JoinWorkspace.dart';
import 'package:taskplus/ui/Screens/HomePgaeScreen.dart';
import 'package:taskplus/ui/Screens/ScanScreen.dart';
import 'package:taskplus/ui/Widgets/Button.dart';

class JoinScreenContainer extends StatefulWidget {
  const JoinScreenContainer({super.key});

  @override
  _JoinScreenContainerState createState() => _JoinScreenContainerState();
}

class _JoinScreenContainerState extends State<JoinScreenContainer> {
  final TextEditingController _controller = TextEditingController();

  void pasteFromClipboard() async {
    String? clipboardText =
        (await Clipboard.getData(Clipboard.kTextPlain))?.text.toString();
    if (clipboardText != null) {
      _controller.text = clipboardText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text("Enter the workspace code found in your email",
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              )),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: AppColor.blackColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColor.whiteColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      color: AppColor.blackColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: GoogleFonts.inter(
                        color: AppColor.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      cursorColor: AppColor.greenColor,
                      decoration: InputDecoration(
                        hintText: 'Enter invitation code',
                        hintStyle: GoogleFonts.inter(
                          color: AppColor.whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 0),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: AppColor.blackColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColor.blackColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      pasteFromClipboard();
                    },
                    icon: const Icon(
                      Icons.content_paste,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CustomElevatedButton(
            onPressed: () async {
              int statusCode = await joinWorkspace(_controller.text);

              if (statusCode == 200) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: Text(
                        "Error",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      content: Text(
                          "Failed to join workspace. Status code: $statusCode",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.black,
                          )),
                      actions: <Widget>[
                        TextButton(
                          child: Text("OK",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: AppColor.redColor,
                              )),
                          onPressed: () {
                            Navigator.of(dialogContext)
                                .pop(); // Close the dialog
                          },
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white,
                      elevation: 10,
                    );
                  },
                );
              }
            },
            text: "Join",
          ),
          const SizedBox(height: 10),
          Text(
            "Or",
            style: GoogleFonts.inter(
              fontSize: 50,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text("Enter the workspace code found in your email",
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              )),
          const Image(
            image: AssetImage('assets/images/scan.png'),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomIconElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScanScreen(),
                  ),
                );
              },
              text: "Scan",
              icon: Icons.play_circle)
        ],
      ),
    );
  }
}
