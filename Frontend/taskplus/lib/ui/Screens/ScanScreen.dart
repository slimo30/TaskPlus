import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:taskplus/Controller/themeProvider.dart';

import 'package:taskplus/utils/colors.dart';
import 'package:taskplus/Controller/JoinWorkspace.dart';
import 'package:taskplus/Controller/JoinWorkspace.dart';
import 'package:taskplus/ui/Screens/HomePgaeScreen.dart';
import 'package:taskplus/ui/Widgets/Appbar.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final qKey = GlobalKey(debugLabel: 'QR');
  Barcode? code;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Scan", AppColor.blackColor, context),
      backgroundColor: AppColor.blackColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            bottom: 150,
            left: 0,
            right: 0,
            child: buildQrView(context),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: buildResult(context),
          ),
        ],
      ),
    );
  }

  Widget buildQrView(BuildContext context) {
    return QRView(
      key: qKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        cutOutSize: MediaQuery.of(context).size.width * 0.7,
        borderLength: 30,
        borderWidth: 30,
        borderColor: AppColor.greenColor,
        borderRadius: 20,
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((code) {
      setState(() {
        this.code = code;
      });
    });
  }

  Widget buildResult(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (code != null) {
          int statusCode = await joinWorkspace(code!.code!);

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
                bool isDarkMode =
                    Provider.of<ThemeProvider>(context).isDarkMode;
                return AlertDialog(
                  title: Text(
                    "Error",
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: !isDarkMode
                            ? AppColor.blackColor
                            : AppColor.whiteColor),
                  ),
                  content: Text(
                      "Failed to join workspace. Status code: $statusCode",
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          color: !isDarkMode
                              ? AppColor.blackColor
                              : AppColor.whiteColor)),
                  actions: <Widget>[
                    TextButton(
                      child: Text("OK",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: AppColor.redColor,
                          )),
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Close the dialog
                      },
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor:
                      isDarkMode ? AppColor.blackColor : AppColor.whiteColor,
                  elevation: 10,
                );
              },
            );
          }
        }
      },
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            color: AppColor.greenColor,
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Text(
            code != null ? 'Join' : 'Scan ...',
            style: GoogleFonts.inter(
                fontSize: 20,
                color: AppColor.whiteColor,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}
