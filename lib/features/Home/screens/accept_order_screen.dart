// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shortly_provider/core/app_imports.dart';
import 'package:shortly_provider/core/network/network_config.dart';
import 'package:shortly_provider/core/services/auth_service.dart';
import 'package:shortly_provider/features/Home/screens/order_details_screen.dart';
import 'package:shortly_provider/features/Home/widget/send_confiirm.dart';
import 'package:shortly_provider/features/Home/widget/send_details_dialog_box.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

class AcceptOrderScreen extends StatefulWidget {
  const AcceptOrderScreen({super.key});

  @override
  State<AcceptOrderScreen> createState() => _AcceptOrderScreenState();
}

class _AcceptOrderScreenState extends State<AcceptOrderScreen> {
  bool _isLoading = true;
  String? _error;
  List<dynamic> _availableBookings = [];
  bool _isAccepting = false;
  bool _isRejecting = false;

  @override
  void initState() {
    super.initState();
    _fetchAvailableBookings();
  }

  Future<void> _fetchAvailableBookings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get auth token
      final authToken = await AuthService.getToken();

      if (authToken == null) {
        throw Exception("Not authenticated");
      }

      // Fetch available bookings
      final response = await http.get(
        Uri.parse('${NetworkConfig.baseUrl}/bookings/dashboard'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch available bookings");
      }

      final bookingsData = jsonDecode(response.body);

      // Filter for matching bookings only
      final matchingBookings = (bookingsData is List)
          ? bookingsData
              .where((booking) => booking['status'] == 'matching')
              .toList()
          : [];

      setState(() {
        _availableBookings = matchingBookings;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      print("Error fetching bookings: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _acceptBooking(String bookingId) async {
    setState(() {
      _isAccepting = true;
    });

    try {
      final authToken = await AuthService.getToken();

      if (authToken == null) {
        throw Exception("Not authenticated");
      }

      // Call API to accept booking
      final response = await http.post(
        Uri.parse('${NetworkConfig.baseUrl}/bookings/$bookingId/accept'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? "Failed to accept booking");
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking accepted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh bookings list
      _fetchAvailableBookings();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isAccepting = false;
      });
    }
  }

  Future<void> _rejectBooking(String bookingId) async {
    setState(() {
      _isRejecting = true;
    });

    try {
      final authToken = await AuthService.getToken();

      if (authToken == null) {
        throw Exception("Not authenticated");
      }

      // Call API to reject booking
      final response = await http.post(
        Uri.parse('${NetworkConfig.baseUrl}/bookings/$bookingId/reject'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? "Failed to reject booking");
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking rejected'),
          backgroundColor: Colors.orange,
        ),
      );

      // Refresh bookings list
      _fetchAvailableBookings();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isRejecting = false;
      });
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return "${date.day} ${months[date.month - 1]} ${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              CustomSpacers.height16,
              Text(
                'Error: $_error',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              CustomSpacers.height24,
              ElevatedButton(
                onPressed: _fetchAvailableBookings,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_availableBookings.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Available Bookings'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fetchAvailableBookings,
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inbox, size: 48, color: Colors.grey),
              CustomSpacers.height16,
              const Text(
                'No available bookings',
                style: TextStyle(color: Colors.grey),
              ),
              CustomSpacers.height24,
              ElevatedButton(
                onPressed: _fetchAvailableBookings,
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Available Bookings (${_availableBookings.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchAvailableBookings,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _availableBookings.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final booking = _availableBookings[index];
          final bool isWithinRadius = booking['distance'] != null &&
              (booking['distance']['isWithinRadius'] == true);

          return AcceptCardWidget(
            booking: booking,
            formatDate: _formatDate,
            onAccept: () => _acceptBooking(booking['_id']),
            onReject: () => _rejectBooking(booking['_id']),
            onViewDetails: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailsScreen(booking: booking),
                ),
              );
            },
            isWithinRadius: isWithinRadius,
            isAccepting: _isAccepting,
            isRejecting: _isRejecting,
          );
        },
      ),
    );
  }
}

class AcceptCardWidget extends StatelessWidget {
  final dynamic booking;
  final Function(String) formatDate;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onViewDetails;
  final bool isWithinRadius;
  final bool isAccepting;
  final bool isRejecting;

  const AcceptCardWidget({
    super.key,
    required this.booking,
    required this.formatDate,
    required this.onAccept,
    required this.onReject,
    required this.onViewDetails,
    this.isWithinRadius = false,
    this.isAccepting = false,
    this.isRejecting = false,
  });

  @override
  Widget build(BuildContext context) {
    // Extract booking details
    final String id = booking['_id'] ?? '';

    // Get service info
    final services = booking['services'] ?? [];
    String serviceType = 'Service';
    String locationType = 'At Home';

    if (services is List && services.isNotEmpty) {
      final service = services[0];
      final serviceDetails = service['serviceDetails'];

      if (serviceDetails != null) {
        serviceType = serviceDetails['name'] ?? 'Service';
      }

      locationType =
          service['location_type'] == 'at_home' ? 'At Home' : 'At Salon';
    }

    // Get address
    String address = '';
    if (booking['userDetails'] != null) {
      address = booking['userDetails']['address'] ?? '';
    }

    // Get date and time
    String date = booking['scheduledDate'] != null
        ? formatDate(booking['scheduledDate'])
        : '';
    String time = booking['scheduledTime'] ?? '';

    // Get distance info
    double? distanceKm;
    if (booking['distance'] != null &&
        booking['distance']['kilometers'] != null) {
      try {
        if (booking['distance']['kilometers'] is num) {
          distanceKm = (booking['distance']['kilometers'] as num).toDouble();
        } else {
          distanceKm =
              double.tryParse(booking['distance']['kilometers'].toString());
        }
      } catch (e) {
        print('Error parsing distance: $e');
      }
    } else if (booking['distanceKm'] != null) {
      try {
        if (booking['distanceKm'] is num) {
          distanceKm = (booking['distanceKm'] as num).toDouble();
        } else {
          distanceKm = double.tryParse(booking['distanceKm'].toString());
        }
      } catch (e) {
        print('Error parsing distance: $e');
      }
    }

    final bool isExactMatch = booking['distance'] != null &&
        booking['distance']['exactMatch'] == true;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Header with service type and location type
          _buildHeader(serviceType, locationType, isExactMatch, isWithinRadius),

          CustomSpacers.height12,

          // Customer info
          _buildCustomerInfo(),

          // Location
          _buildRowTile(Icons.location_on, address),

          // Date and time
          _buildRowTile(Icons.calendar_today, "$date • $time"),

          // Distance badge
          if (distanceKm != null)
            _buildDistanceBadge(distanceKm, isWithinRadius, isExactMatch),

          CustomSpacers.height10,

          // View details button
          _buildViewDetailsButton(context),

          CustomSpacers.height10,

          // Accept/Reject buttons
          _buildActionsButton(context),

          CustomSpacers.height16,
        ],
      ),
    );
  }

  Widget _buildHeader(String serviceType, String locationType,
      bool isExactMatch, bool isWithinRadius) {
    return Container(
      decoration: BoxDecoration(
        color: isExactMatch
            ? Colors.green.shade800
            : isWithinRadius
                ? Colors.green.shade600
                : Colors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              serviceType,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              if (isExactMatch || isWithinRadius)
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Colors.white70,
                ),
              if (isExactMatch || isWithinRadius) const SizedBox(width: 4),
              Text(
                locationType,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo() {
    // Extract customer details
    String customerName = '';
    String customerPhone = '';

    if (booking['userDetails'] != null) {
      customerName = booking['userDetails']['name'] ?? '';
      customerPhone = booking['userDetails']['phone'] ?? '';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:
                isWithinRadius ? Colors.green.shade100 : Colors.blue.shade100,
            radius: 20,
            child: Text(
              customerName.isNotEmpty ? customerName[0].toUpperCase() : '?',
              style: TextStyle(
                color: isWithinRadius
                    ? Colors.green.shade800
                    : Colors.blue.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CustomSpacers.width12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                if (customerPhone.isNotEmpty)
                  Text(
                    customerPhone,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowTile(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[800]),
          CustomSpacers.width12,
          Flexible(
            child: Text(title, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceBadge(
      double distanceKm, bool isWithinRadius, bool isExactMatch) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isExactMatch
              ? Colors.green.shade100
              : isWithinRadius
                  ? Colors.green.shade50
                  : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExactMatch
                ? Colors.green.shade300
                : isWithinRadius
                    ? Colors.green.shade200
                    : Colors.blue.shade200,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isExactMatch
                  ? Icons.check_circle
                  : isWithinRadius
                      ? Icons.check_circle
                      : Icons.location_on,
              size: 16,
              color: isExactMatch
                  ? Colors.green.shade800
                  : isWithinRadius
                      ? Colors.green.shade700
                      : Colors.blue.shade700,
            ),
            CustomSpacers.width6,
            Text(
              isExactMatch
                  ? 'Exact match!'
                  : isWithinRadius
                      ? 'Within Your Area'
                      : '${distanceKm.toStringAsFixed(1)} km away',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isExactMatch
                    ? Colors.green.shade800
                    : isWithinRadius
                        ? Colors.green.shade700
                        : Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewDetailsButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey.shade800,
            side: BorderSide(color: Colors.grey.shade300),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: onViewDetails,
          child: const Text('View Details'),
        ),
      ),
    );
  }

  Widget _buildActionsButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              strButtonText: isAccepting ? "Accepting..." : "Accept",
              dHeight: 40,
              bIcon: !isAccepting,
              bIconLeft: true,
              buttonIcon: const Icon(Icons.check_circle),
              bgColor: isWithinRadius
                  ? const Color(0xFF4CAF50)
                  : const Color.fromARGB(167, 76, 175, 79),
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              // Fix: Handle nullable VoidCallback
              buttonAction: isAccepting || isRejecting ? () {} : onAccept,
            ),
          ),
          CustomSpacers.width14,
          Expanded(
            child: CustomButton(
              strButtonText: isRejecting ? "Rejecting..." : "Reject",
              dHeight: 40,
              bIcon: !isRejecting,
              bIconLeft: true,
              buttonIcon: const Icon(Icons.close, color: Colors.white),
              bgColor: const Color.fromARGB(195, 255, 82, 82),
              textStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
              // Fix: Handle nullable VoidCallback
              buttonAction: isAccepting || isRejecting ? () {} : onReject,
            ),
          ),
        ],
      ),
    );
  }
}
