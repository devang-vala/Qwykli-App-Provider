import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/auth_provider.dart';
import '../widgets/personal_info_page.dart';

class SignupFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get phone number from arguments
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final phoneNumber = args != null ? args['phoneNumber'] as String? : null;

    return ChangeNotifierProvider(
      create: (_) {
        final provider = ProviderRegistrationProvider();
        if (phoneNumber != null) {
          provider.setPhone(phoneNumber);
        }
        return provider;
      },
      child: PersonalInfoPage(),
    );
  }
}
