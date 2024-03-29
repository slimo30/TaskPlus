import 'package:flutter/material.dart';
import 'package:taskplus/Const/colors.dart';
import 'package:taskplus/Const/TextStyle.dart';
import 'package:taskplus/View/Widgets/Button.dart'; // Assuming this defines CustomElevatedButton

class CreateWorkspaceScreen extends StatefulWidget {
  const CreateWorkspaceScreen({super.key});

  @override
  _CreateWorkspaceScreenState createState() => _CreateWorkspaceScreenState();
}

class _CreateWorkspaceScreenState extends State<CreateWorkspaceScreen> {
  final TextEditingController companyNameController = TextEditingController();
  String? _selectedSector; // To store the selected sector

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          color: AppColor.whiteColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text("Create Workspace", style: semiBold18),
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
                          borderSide: const BorderSide(color: AppColor.blackColor),
                        ),
                        filled: true,
                        fillColor: AppColor.secondColor,
                        labelStyle: const TextStyle(color: AppColor.iconsColor),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        prefixIcon:
                            const Icon(Icons.business, color: AppColor.iconsColor),
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
                          borderSide: const BorderSide(color: AppColor.blackColor),
                        ),
                        filled: true,
                        fillColor: AppColor.secondColor,
                        labelStyle: const TextStyle(color: AppColor.iconsColor),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        prefixIcon:
                            const Icon(Icons.category, color: AppColor.iconsColor),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomElevatedButton(
                      onPressed: () {
                        // Handle create workspace action
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
    );
  }

  @override
  void dispose() {
    companyNameController.dispose();
    super.dispose();
  }
}
