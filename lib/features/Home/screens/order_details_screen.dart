// ================= ENHANCED ORDER DETAILS SCREEN ====================
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shortly_provider/core/network/network_config.dart';
import 'package:shortly_provider/core/services/auth_service.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatefulWidget {
  final dynamic booking; // Accept any type of booking object

  const OrderDetailsScreen({
    super.key,
    this.booking,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _isLoading = true;
  bool _isUpdatingStatus = false;
  String? _error;
  Map<String, dynamic>? _rawBookingData;

  // Booking details
  String _bookingId = '';
  String _customerName = '';
  String _customerPhone = '';
  String _customerAddress = '';
  String _scheduledDate = '';
  String _scheduledTime = '';
  List<Map<String, dynamic>> _services = [];
  double _totalPrice = 0;
  String _bookingStatus = '';
  double? _distanceKm;
  bool _isWithinRadius = false;
  List<double> _coordinates = [0, 0];

  @override
  void initState() {
    super.initState();
    _initializeBookingData();
  }

  void _initializeBookingData() {
    if (widget.booking != null) {
      // Process booking data based on the type
      if (widget.booking is Map<String, dynamic>) {
        // If it's already a Map (from API)
        _processBookingData(widget.booking);
      } else {
        // If it's a custom Booking class (from OpenOrderScreen)
        _processBookingFromCustomClass(widget.booking);
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      // No booking data provided, show error
      setState(() {
        _isLoading = false;
        _error = 'No booking information available';
      });
    }
  }

  void _processBookingFromCustomClass(dynamic booking) {
    // This handles the Booking object from OpenOrderScreen
    setState(() {
      _bookingId = booking.id ?? '';
      _customerName = booking.customerName ?? '';
      _customerPhone = booking.customerPhone ?? '';
      _customerAddress = booking.address ?? '';
      _scheduledDate = booking.scheduledDate ?? '';
      _scheduledTime = booking.scheduledTime ?? '';
      _bookingStatus = booking.status ?? '';
      _totalPrice = booking.totalPrice ?? 0.0;
      _distanceKm = booking.distanceKm;
      _isWithinRadius = booking.isWithinRadius ?? false;

      // Create service entries from serviceNames
      _services = booking.serviceNames.map<Map<String, dynamic>>((name) {
        return {
          'name': name,
          'price': booking.totalPrice / booking.serviceNames.length, // Approximate
          'location_type': booking.locationType ?? 'at_home',
        };
      }).toList();
    });
  }

  void _processBookingData(Map<String, dynamic> bookingData) {
    setState(() {
      _rawBookingData = bookingData;
      _bookingId = bookingData['_id'] ?? '';

      // Extract customer details
      final userDetails = bookingData['userDetails'];
      if (userDetails != null && userDetails is Map) {
        _customerName = userDetails['name'] ?? '';
        _customerPhone = userDetails['phone'] ?? '';
        _customerAddress = userDetails['address'] ?? '';
      } else if (bookingData['user'] != null && bookingData['user'] is Map) {
        final user = bookingData['user'];
        _customerName = user['name'] ?? '';
        _customerPhone = user['phone'] ?? '';
        _customerAddress = 'Address not available';
      }

      // Extract booking details
      _scheduledDate = _formatDate(bookingData['scheduledDate'] ?? '');
      _scheduledTime = bookingData['scheduledTime'] ?? '';
      _bookingStatus = bookingData['status'] ?? '';
      _totalPrice = _extractDouble(bookingData, 'totalPrice');

      // Extract location coordinates
      final location = bookingData['location'];
      if (location != null && location is Map && location['coordinates'] is List) {
        final coords = location['coordinates'] as List;
        if (coords.length == 2) {
          _coordinates = [
            (coords[0] is num) ? (coords[0] as num).toDouble() : 0.0,
            (coords[1] is num) ? (coords[1] as num).toDouble() : 0.0,
          ];
        }
      }

      // Extract distance info
      final distanceInfo = bookingData['distance'];
      if (distanceInfo != null && distanceInfo is Map) {
        if (distanceInfo['kilometers'] != null) {
          if (distanceInfo['kilometers'] is num) {
            _distanceKm = (distanceInfo['kilometers'] as num).toDouble();
          } else {
            _distanceKm = double.tryParse(distanceInfo['kilometers'].toString());
          }
        }
        _isWithinRadius = distanceInfo['isWithinRadius'] == true;
      } else if (bookingData['distanceKm'] != null) {
        if (bookingData['distanceKm'] is num) {
          _distanceKm = (bookingData['distanceKm'] as num).toDouble();
        } else {
          _distanceKm = double.tryParse(bookingData['distanceKm'].toString());
        }
      }

      // Extract services
      if (bookingData['services'] is List) {
        _services = (bookingData['services'] as List).map((service) {
          final serviceDetails = service['serviceDetails'];
          String serviceName = 'Service';
          if (serviceDetails != null && serviceDetails is Map) {
            serviceName = serviceDetails['name'] ?? 'Service';
          }

          String locationType = 'at_home';
          if (service['location_type'] != null) {
            locationType = service['location_type'];
          }

          double price = 0.0;
          if (service['price'] != null) {
            if (service['price'] is num) {
              price = (service['price'] as num).toDouble();
            } else {
              price = double.tryParse(service['price'].toString()) ?? 0.0;
            }
          }

          return {
            'name': serviceName,
            'price': price,
            'location_type': locationType,
          };
        }).toList().cast<Map<String, dynamic>>();
      }
    });
  }

  Future<void> _updateBookingStatus(String newStatus) async {
    setState(() {
      _isUpdatingStatus = true;
    });

    try {
      final authToken = await AuthService.getToken();
      if (authToken == null) {
        throw Exception('Not authenticated');
      }

      // Make API call to update booking status
      final response = await http.put(
        Uri.parse('${NetworkConfig.baseUrl}/bookings/$_bookingId/status'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': newStatus}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update booking status');
      }

      // Update local state
      setState(() {
        _bookingStatus = newStatus;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking marked as ${_getStatusDisplayText(newStatus)}'),
          backgroundColor: Colors.green,
        ),
      );

      // If status was updated to completed, navigate back after a delay
      if (newStatus == 'completed') {
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUpdatingStatus = false;
      });
    }
  }

  String _getStatusDisplayText(String status) {
    switch (status) {
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.replaceAll('_', ' ');
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final month = _getMonthName(date.month);
      return "${date.day} $month ${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  double _extractDouble(Map<String, dynamic>? json, String key) {
    if (json == null || !json.containsKey(key)) return 0.0;
    final value = json[key];
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  void _openMap() {
    if (_coordinates.length == 2) {
      final url = 'https://www.google.com/maps/dir/?api=1&destination=${_coordinates[1]},${_coordinates[0]}';
      launchUrl(Uri.parse(url));
    }
  }

  void _callCustomer() {
    if (_customerPhone.isNotEmpty) {
      launchUrl(Uri.parse('tel:$_customerPhone'));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: false,
          leading: const BackButton(color: Colors.white),
          title: const Text("Booking Details",
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: false,
          leading: const BackButton(color: Colors.white),
          title: const Text("Booking Details",
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $_error',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        leading: const BackButton(color: Colors.white),
        title: Text(
          "Booking #${_bookingId.substring(max(0, _bookingId.length - 6))}",
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Badge
              _buildStatusBadge(),
              const SizedBox(height: 20),

              // Appointment Details
              _buildSection(
                icon: Icons.calendar_today,
                title: "Appointment Details",
                child: _buildInfoGrid([
                  {"label": "Date", "value": _scheduledDate},
                  {"label": "Time", "value": _scheduledTime},
                ]),
              ),
              const SizedBox(height: 16),

              // Customer Details
              _buildSection(
                icon: Icons.person,
                title: "Customer Details",
                child: Column(
                  children: [
                    _buildInfoGrid([
                      {"label": "Name", "value": _customerName},
                      {"label": "Phone", "value": _customerPhone},
                    ]),
                    if (['assigned', 'confirmed', 'in_progress'].contains(_bookingStatus))
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.phone, color: Colors.green),
                            label: const Text("Call Customer"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                              side: BorderSide(color: Colors.green.shade200),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: _callCustomer,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Location
              _buildSection(
                icon: Icons.location_on,
                title: "Service Location",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(_customerAddress),
                    ),
                    Wrap(
                      spacing: 8,
                      children: [
                        if (_bookingStatus == 'matching')
                          _buildBadge(
                            label: "${_distanceKm?.toStringAsFixed(1) ?? '?'} km away",
                            color: Colors.blue.shade100,
                            textColor: Colors.blue.shade800,
                            icon: Icons.location_on,
                          ),
                        if (_bookingStatus == 'matching' && _isWithinRadius)
                          _buildBadge(
                            label: "Within your range",
                            color: Colors.green.shade100,
                            textColor: Colors.green.shade800,
                            icon: Icons.adjust,
                          ),
                      ],
                    ),
                    if (['assigned', 'confirmed', 'in_progress'].contains(_bookingStatus))
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.map, color: Colors.blue),
                            label: const Text("Open in Maps"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              side: BorderSide(color: Colors.blue.shade200),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: _openMap,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Services
              _buildSection(
                icon: Icons.design_services,
                title: "Services Requested",
                child: Column(
                  children: [
                    ..._services.map((service) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service['name'] ?? 'Service',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                _buildBadge(
                                  label: service['location_type'] == 'at_home' ? 'At Home' : 'At Salon',
                                  color: Colors.grey.shade100,
                                  textColor: Colors.grey.shade800,
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  fontSize: 11,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "₹${(service['price'] ?? 0).toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )).toList(),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "₹${_totalPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Action Buttons
              if (_bookingStatus == 'assigned')
                _buildActionButton(
                  label: "Start Job",
                  icon: Icons.local_shipping,
                  color: Colors.amber.shade600,
                  onPressed: () => _updateBookingStatus('in_progress'),
                  isLoading: _isUpdatingStatus,
                ),
              if (_bookingStatus == 'in_progress')
                _buildActionButton(
                  label: "Complete Job",
                  icon: Icons.check_circle,
                  color: Colors.green.shade600,
                  onPressed: () => _updateBookingStatus('completed'),
                  isLoading: _isUpdatingStatus,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    String statusText;

    switch (_bookingStatus) {
      case 'matching':
        bgColor = Colors.blue;
        statusText = 'Available';
        break;
      case 'assigned':
        bgColor = Colors.purple;
        statusText = 'Assigned';
        break;
      case 'confirmed':
        bgColor = Colors.green;
        statusText = 'Confirmed';
        break;
      case 'in_progress':
        bgColor = Colors.amber;
        statusText = 'In Progress';
        break;
      case 'completed':
        bgColor = Colors.teal;
        statusText = 'Completed';
        break;
      case 'cancelled':
        bgColor = Colors.red;
        statusText = 'Cancelled';
        break;
      default:
        bgColor = Colors.grey;
        statusText = _bookingStatus.replaceAll('_', ' ');
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        statusText,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color color,
    required Color textColor,
    IconData? icon,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    double fontSize = 12,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildInfoGrid(List<Map<String, String>> items) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(0.4),
        1: FlexColumnWidth(0.6),
      },
      children: items.map((item) => TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              item["label"] ?? "",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              item["value"] ?? "",
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      )).toList(),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: isLoading
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Icon(icon),
        label: Text(
          isLoading ? "Processing..." : label,
          style: const TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
      ),
    );
  }

  int max(int a, int b) => a > b ? a : b;
}