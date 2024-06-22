import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskplus/utils/TextStyle.dart';
import 'package:taskplus/utils/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.greenColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        minimumSize: const Size(150, 40),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColor.whiteColor,
        ),
      ),
    );
  }
}

class CustomIconElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon; // New parameter for icon

  const CustomIconElevatedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.greenColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        minimumSize: const Size(150, 40),
      ),
      icon: Icon(icon, color: Colors.white), // Always provide an icon
      label: Text(text,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColor.whiteColor,
          )), // Always provide text
    );
  }
}
