import 'package:flutter/material.dart';
import 'package:shortly_provider/route/custom_navigator.dart';

class NotificationItem {
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;

  NotificationItem({
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
  });
}

enum NotificationType { order, closed, receipt }

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> notifications = [
    NotificationItem(
      title: "New Order Received",
      message: "Order #12345 has been placed.",
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      type: NotificationType.order,
    ),
    NotificationItem(
      title: "Order Closed",
      message: "Order #12299 has been successfully closed.",
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      type: NotificationType.closed,
    ),
    NotificationItem(
      title: "Receipt Generated",
      message: "Receipt for Order #12299 has been generated.",
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.receipt,
    ),
  ];

  void removeNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  IconData getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Icons.shopping_cart;
      case NotificationType.closed:
        return Icons.check_circle;
      case NotificationType.receipt:
        return Icons.receipt_long;
    }
  }

  Color getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Colors.blueAccent;
      case NotificationType.closed:
        return Colors.green;
      case NotificationType.receipt:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: GestureDetector(
            onTap: () {
              CustomNavigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          "Notifications",
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: notifications.isEmpty
          ? const Center(child: Text("No notifications yet!"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          getColorForType(item.type).withOpacity(0.2),
                      child: Icon(
                        getIconForType(item.type),
                        color: getColorForType(item.type),
                      ),
                    ),
                    title: Text(item.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.message),
                        const SizedBox(height: 4),
                        Text(
                          "${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')} • ${item.timestamp.day}/${item.timestamp.month}/${item.timestamp.year}",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => removeNotification(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
