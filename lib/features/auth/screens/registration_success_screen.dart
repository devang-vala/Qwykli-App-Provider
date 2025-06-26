import 'package:flutter/material.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Registration Submitted'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
              SizedBox(height: 24),
              Text(
                'Registration successful!\nWe will review your documents and contact you soon.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
                child: Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
