import 'package:shortly_provider/core/app_imports.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/route/app_pages.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAppHeader(),

              // Mobile Number Input
              _buildInputTextField(phoneController),
              CustomSpacers.height30,

              // Get Verification Code Button
              _buildVerificationButton(context, phoneController),

              // DONT HAVE ACCOUNT FUNCTIONALITY
              _buildDontHaveAccount(context),
            ],
          ),
        ),
      ),
    );
  }

  _buildAppHeader() => Column(
        children: [
          CustomSpacers.height70,
          Image.asset(
            AppIcons.app_logo,
            height: 100.h,
          ),
          CustomSpacers.height36,

          // Logo + App Name
          const Text(
            'Shortly',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          CustomSpacers.height8,
          const Text(
            'Get the best home services',
            style: TextStyle(fontSize: 16),
          ),
          CustomSpacers.height4,
          const Text(
            'Quick • Affordable • Trusted',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),

          CustomSpacers.height30,
        ],
      );

  _buildInputTextField(TextEditingController phoneController) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: 'Enter your mobile number',
              border: InputBorder.none,
            ),
          ),
        ),
      );

  _buildVerificationButton(
          BuildContext context, TextEditingController phoneController) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SizedBox(
          width: 300.w,
          child: ElevatedButton(
            onPressed: () {
              // Implement OTP sending logic
              CustomNavigator.pushReplace(
                context,
                AppPages.otpverification,
                arguments: {
                  "phoneNumber": phoneController.text,
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5D3FD3), // Purple
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Get Verification Code',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      );

  _buildDontHaveAccount(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "${AppLocalizations.of(context)!.donthaveanaccount} ",
            style: TextStyle(fontSize: 17.w, fontWeight: FontWeight.w300),
          ),
          GestureDetector(
            onTap: () {
              CustomNavigator.pushReplace(context, AppPages.signup);
            },
            child: Text(
              AppLocalizations.of(context)!.signup,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17.w,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ]),
      );
}
