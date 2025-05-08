import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendConfirmDialogBox extends StatefulWidget {
  const SendConfirmDialogBox({super.key});

  @override
  State<SendConfirmDialogBox> createState() => _SendConfirmDialogBoxState();
}

class _SendConfirmDialogBoxState extends State<SendConfirmDialogBox> {
  final timeController = TextEditingController();

  List<Map<String, String>> providers = [
    {"name": "Ayush", "contact": "1234567890"},
    {"name": "Prashant", "contact": "9876543210"},
    {"name": "Add other", "contact": ""},
  ];

  String? selectedProviderName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timeController.text = "3:00 PM - 4:00 PM";
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Top header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      AppLocalizations.of(context)!.providerdetails,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                /// Dropdown to select provider
                // DropdownButtonFormField<String>(
                //   value: selectedProviderName,
                //   decoration: InputDecoration(
                //     labelText: "Select Provider",
                //     filled: true,
                //     fillColor: Colors.grey[200],
                //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                //   ),
                //   items: providers.map((provider) {
                //     return DropdownMenuItem<String>(
                //       value: provider["name"],
                //       child: Text(provider["name"]!),
                //     );
                //   }).toList(),
                //   onChanged: (value) {
                //     if (value == "Add other") {
                //       _showAddProviderDialog();
                //     } else {
                //       setState(() {
                //         selectedProviderName = value;
                //       });
                //     }
                //   },
                // ),

                const SizedBox(height: 16),

                /// Time of Visit Field
                _buildTextField("Time of visit", timeController),
                const SizedBox(height: 24),

                /// Send Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Logic to use selectedProviderName & timeController.text
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A3D91),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      "Confirm",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddProviderDialog() {
    final nameController = TextEditingController();
    final contactController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Add New Provider",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.name,
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contactController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.contact,
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    contactController.text.isNotEmpty) {
                  setState(() {
                    providers.insert(
                      providers.length - 1,
                      {
                        "name": nameController.text,
                        "contact": contactController.text,
                      },
                    );
                    selectedProviderName = nameController.text;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
