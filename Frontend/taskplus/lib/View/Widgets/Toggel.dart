import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskplus/Const/TextStyle.dart';
import 'package:taskplus/Const/colors.dart';
import 'package:taskplus/View/Screens/CreateWoekspaceScreeen.dart';
import 'package:taskplus/View/Screens/JoinScreen.dart';
import 'package:taskplus/View/Widgets/Button.dart';

class ToggleLabelContainer extends StatefulWidget {
  final String label1;
  final String label2;

  const ToggleLabelContainer({
    super.key,
    required this.label1,
    required this.label2,
  });

  @override
  _ToggleLabelContainerState createState() => _ToggleLabelContainerState();
}

class _ToggleLabelContainerState extends State<ToggleLabelContainer> {
  int _selectedIndex = 0;
  TextEditingController controller =
      TextEditingController(); // Create a TextEditingController

  void pasteFromClipboard() async {
    // Retrieve text from clipboard
    String? clipboardText =
        (await Clipboard.getData(Clipboard.kTextPlain))?.text.toString();
    if (clipboardText != null) {
      // Set the retrieved text to the text field
      controller.text = clipboardText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColor.blackColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 0
                            ? AppColor.greenColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.label1,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _selectedIndex == 0
                              ? Colors.white
                              : AppColor.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 1
                            ? AppColor.greenColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.label2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _selectedIndex == 1
                              ? Colors.white
                              : AppColor.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _selectedIndex == 0
            // ?
            ? JoinScreenContainer()
            : CreateWorkspaceScreen(),
      ],
    );
  }
}
