import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:taskplus/Controller/Authentification.dart';
import 'package:taskplus/Controller/CreateWorkspace.dart';
import 'package:taskplus/Controller/themeProvider.dart';
import 'package:taskplus/Controller/workspaceService.dart';
import 'package:taskplus/ui/Screens/HomePgaeScreen.dart';
import 'package:taskplus/ui/Screens/MissionsScreen.dart';
import 'package:taskplus/utils/colors.dart';
import 'package:taskplus/utils/TextStyle.dart';
import 'package:taskplus/ui/Widgets/Button.dart'; // Assuming this defines CustomElevatedButton
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateWorkspaceScreen extends StatefulWidget {
  const CreateWorkspaceScreen({super.key});

  @override
  _CreateWorkspaceScreenState createState() => _CreateWorkspaceScreenState();
}

class _CreateWorkspaceScreenState extends State<CreateWorkspaceScreen> {
  final TextEditingController companyNameController = TextEditingController();
  String? _selectedSector; // To store the selected sector
  bool _isLoading = false; // To manage loading state

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              color: isDarkMode
                  ? AppColor.darkModeBackgroundColor
                  : AppColor.whiteColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text("Create Workspace",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: !isDarkMode
                                  ? AppColor.blackColor
                                  : AppColor.whiteColor,
                            )),
                        const SizedBox(height: 20),
                        TextFormField(
                          key: const Key('company_name_field'),
                          controller: companyNameController,
                          decoration: InputDecoration(
                            labelText: 'Company Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide:
                                  const BorderSide(color: AppColor.blackColor),
                            ),
                            filled: true,
                            fillColor: AppColor.secondColor,
                            labelStyle:
                                GoogleFonts.inter(color: AppColor.iconsColor),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            prefixIcon: const Icon(Icons.business,
                                color: AppColor.iconsColor),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: _selectedSector,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedSector = newValue;
                            });
                          },
                          items: <String>[
                            'Sector A',
                            'Sector B',
                            'Sector C',
                          ]
                              .map<DropdownMenuItem<String>>(
                                  (String value) => DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      ))
                              .toList(),
                          decoration: InputDecoration(
                            labelText: 'Sector',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide:
                                  const BorderSide(color: AppColor.blackColor),
                            ),
                            filled: true,
                            fillColor: AppColor.secondColor,
                            labelStyle:
                                GoogleFonts.inter(color: AppColor.iconsColor),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            prefixIcon: const Icon(Icons.category,
                                color: AppColor.iconsColor),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomElevatedButton(
                          onPressed: () async {
                            int memberId = await getMemberIdFromPrefs();
                            String companyName = companyNameController.text;
                            String? sector = _selectedSector;

                            if (companyName.isNotEmpty && sector != null) {
                              setState(() {
                                _isLoading = true; // Show loading indicator
                              });

                              try {
                                await createWorkspace(
                                    companyName, sector, memberId);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHomePage(),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to create workspace'),
                                  ),
                                );
                              } finally {
                                setState(() {
                                  _isLoading = false; // Hide loading indicator
                                });
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please fill all fields'),
                                ),
                              );
                            }
                          },
                          text: 'Create',
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(
              color: AppColor.greenColor,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    companyNameController.dispose();
    super.dispose();
  }
}
