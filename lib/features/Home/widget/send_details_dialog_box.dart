import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SendDetailsDialogBox extends StatefulWidget {
  const SendDetailsDialogBox({super.key});

  @override
  State<SendDetailsDialogBox> createState() => _SendDetailsDialogBoxState();
}

class _SendDetailsDialogBoxState extends State<SendDetailsDialogBox> {
  final timeController = TextEditingController();

  List<Map<String, String>> providers = [
    {"name": "Ayush", "contact": "1234567890"},
    {"name": "Prashant", "contact": "9876543210"},
    {"name": "Add other", "contact": ""},
  ];

  String? selectedProviderName;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Dialog(
        backgroundColor: const Color.fromARGB(255, 255, 155, 188),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                      color: Colors.black,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green[100]),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)!.providerdetails,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                /// Dropdown to choose provider
                DropdownButtonFormField<String>(
                  value: selectedProviderName,
                  decoration: InputDecoration(
                    labelText: "Select Provider",
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: providers.map((provider) {
                    return DropdownMenuItem<String>(
                      value: provider["name"],
                      child: Text(provider["name"]!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == "Add other") {
                      _showAddProviderDialog();
                    } else {
                      setState(() {
                        selectedProviderName = value;
                      });
                    }
                  },
                ),

                SizedBox(height: 15),

                _buildTextField("Time of visit", timeController),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Handle selectedProviderName, timeController.text
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(AppLocalizations.of(context)!.senddetails,
                      style: TextStyle(color: Colors.black)),
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
          title: Text("Add New Provider"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.name,
                  // filled: true,
                  // fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: contactController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.contact,
                  // filled: true,
                  // fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    contactController.text.isNotEmpty) {
                  setState(() {
                    // Insert new provider before "Add other"
                    providers.insert(
                      providers.length - 1,
                      {
                        "name": nameController.text,
                        "contact": contactController.text
                      },
                    );
                    selectedProviderName = nameController.text;
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
