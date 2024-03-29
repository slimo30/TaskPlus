import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:taskplus/Const/colors.dart';
import 'package:taskplus/Controller/JoinWorkspace.dart';
import 'package:taskplus/Controller/JoinWorkspace.dart';
import 'package:taskplus/View/Screens/HomePgaeScreen.dart';
import 'package:taskplus/View/Widgets/Appbar.dart';

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
          await joinWorkspace(code!.code!);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MyHomePage()));
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
