import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GetHelpScreen extends StatelessWidget {
  const GetHelpScreen({Key? key}) : super(key: key);

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$text copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Help'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Need assistance? Contact our support team:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            _buildContactCard(
              context,
              'Support',
              '9569664127',
            ),
            const SizedBox(height: 20),
            _buildContactCard(
              context,
              'Support',
              '6207296876',
            ),
            const SizedBox(height: 40),
            
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, String title, String phoneNumber) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    phoneNumber,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy, color: Colors.blue),
              onPressed: () => _copyToClipboard(context, phoneNumber),
              tooltip: 'Copy number',
            ),
          ],
        ),
      ),
    );
  }
}