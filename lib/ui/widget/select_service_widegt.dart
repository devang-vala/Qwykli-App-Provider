import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/features/Onboarding/data/signup_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectServicesWidget extends StatelessWidget {
  final Map<String, List<String>> services;

  const SelectServicesWidget({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProvider>(context);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppLocalizations.of(context)!.select_service,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        ...services.entries.map((entry) {
          final service = entry.key;
          final subServices = entry.value;
          final isExpanded = provider.expandedServices.contains(service);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 0.2),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(service,
                      style: const TextStyle(fontWeight: FontWeight.w400)),
                  trailing: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more),
                  onTap: () => provider.toggleExpansion(service),
                ),
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: subServices.map((sub) {
                        final selected = provider
                                .selectedSubServices[service]
                                ?.contains(sub) ??
                            false;
                        return CheckboxListTile(
                          title: Text(sub),
                          value: selected,
                          onChanged: (_) =>
                              provider.toggleSubService(service, sub),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
