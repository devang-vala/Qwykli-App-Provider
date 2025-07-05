class ProviderNotification {
  final String id;
  final String title;
  final String message;
  final String type;
  final Map<String, dynamic>? data;
  final DateTime createdAt;
  bool isRead;

  ProviderNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.data,
    required this.createdAt,
    this.isRead = false,
  });

  factory ProviderNotification.fromJson(Map<String, dynamic> json) {
    return ProviderNotification(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'system',
      data: json['data'],
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }
}

// Provider-specific notification types
const providerNotificationTypes = [
  'system',
  'booking',
  'payment',
  'provider_update',
  'service_request',
  'message',
  // Add more as needed
];
