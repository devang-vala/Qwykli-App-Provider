import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/features/Onboarding/data/signup_provider.dart';

class SelectServicesWidget extends StatefulWidget {
  final Map<String, List<String>> categoryToServices;

  const SelectServicesWidget({super.key, required this.categoryToServices});

  @override
  State<SelectServicesWidget> createState() => _SelectServicesWidgetState();
}

class _SelectServicesWidgetState extends State<SelectServicesWidget> {
  bool categoryDropdownExpanded = false;
  bool serviceDropdownExpanded = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProvider>(context);

    // All services under selected categories
    final availableServices = provider.selectedCategories
        .expand((cat) => widget.categoryToServices[cat] ?? [])
        .toSet()
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// --- CATEGORY SELECTION ---
        const Text("Select Categories",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        GestureDetector(
          onTap: () {
            setState(() {
              categoryDropdownExpanded = !categoryDropdownExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  provider.selectedCategories.isEmpty
                      ? "Select categories"
                      : provider.selectedCategories.join(", "),
                )),
                Icon(categoryDropdownExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),

        if (categoryDropdownExpanded)
          Column(
            children: widget.categoryToServices.keys.map((category) {
              final isSelected =
                  provider.selectedCategories.contains(category);
              return CheckboxListTile(
                title: Text(category),
                value: isSelected,
                onChanged: (_) => provider.toggleCategory(category),
              );
            }).toList(),
          ),

        const SizedBox(height: 24),

        /// --- SERVICE SELECTION ---
        const Text("Select Services",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        GestureDetector(
          onTap: () {
            setState(() {
              serviceDropdownExpanded = !serviceDropdownExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  provider.selectedServices.isEmpty
                      ? "Select services"
                      : provider.selectedServices.join(", "),
                )),
                Icon(serviceDropdownExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),

        if (serviceDropdownExpanded)
          Column(
            children: availableServices.map((service) {
              final selected = provider.selectedServices.contains(service);
              return CheckboxListTile(
                title: Text(service),
                value: selected,
                onChanged: (_) => provider.toggleService(service),
              );
            }).toList(),
          ),

        const SizedBox(height: 10),
      ],
    ); 
  }
}
