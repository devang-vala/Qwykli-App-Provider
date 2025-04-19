import 'package:flutter/material.dart';

class ApprovalScreen extends StatelessWidget {
  const ApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Shortly"),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Container(
            height: 200,
            // width: 200,
          
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Thanks for creating account",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Shortly will reach out to you after Approval !",
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
