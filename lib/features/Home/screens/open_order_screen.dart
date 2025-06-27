// ================= DEBUGGING OPEN ORDER SCREEN ====================
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/features/Home/screens/order_details_screen.dart';
import 'package:shortly_provider/features/Home/screens/saloon_order_detail_screen.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';
import 'package:shortly_provider/l10n/app_localizations.dart';
import 'package:shortly_provider/core/network/network_config.dart';
import 'package:shortly_provider/core/services/auth_service.dart';

// Simplify the model classes to prevent parsing errors
class Booking {
  final String id;
  final String customerName;
  final String customerPhone;
  final String address;
  final List<String> serviceNames;
  final String locationType;
  final double totalPrice;
  final String scheduledDate;
  final String scheduledTime;
  final String status;
  final double? distanceKm;
  final bool isWithinRadius;

  Booking({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.address,
    required this.serviceNames,
    required this.locationType,
    required this.totalPrice,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.status,
    this.distanceKm,
    this.isWithinRadius = false,
  });

  // Custom factory method that's much more tolerant of field types
  static Booking fromDynamic(dynamic json) {
    // Debugging
    print("Processing booking JSON: ${json['_id']}");

    // Extract customer info
    String name = '';
    String phone = '';
    String address = '';

    try {
      // Try to get from userDetails
      if (json['userDetails'] != null) {
        var userDetails = json['userDetails'];
        name = _extractString(userDetails, 'name');
        phone = _extractString(userDetails, 'phone');
        address = _extractString(userDetails, 'address');
      }
      // Fallback to user if userDetails not available
      else if (json['user'] != null) {
        var user = json['user'];
        name = _extractString(user, 'name');
        phone = _extractString(user, 'phone');
      }
    } catch (e) {
      print("Error extracting user details: $e");
    }

    // Extract service names and location type
    List<String> serviceNames = [];
    String locationType = 'at_home'; // Default

    try {
      if (json['services'] is List) {
        var services = json['services'] as List;
        for (var service in services) {
          try {
            // Try to get service name
            String serviceName = '';

            if (service['serviceDetails'] != null) {
              serviceName = _extractString(service['serviceDetails'], 'name');
            } else if (service['service'] != null) {
              // If service is an object with name
              if (service['service'] is Map) {
                serviceName = _extractString(service['service'], 'name');
              }
            }

            if (serviceName.isNotEmpty) {
              serviceNames.add(serviceName);
            }

            // Get location type from first service
            if (locationType == 'at_home' && service['location_type'] != null) {
              locationType = _extractString(service, 'location_type');
            }
          } catch (e) {
            print("Error extracting service name: $e");
          }
        }
      }
    } catch (e) {
      print("Error processing services: $e");
    }

    // Extract distance info
    double? distance;
    bool isWithinRadius = false;

    try {
      if (json['distance'] != null) {
        var distanceObj = json['distance'];

        // Try to get kilometers
        if (distanceObj['kilometers'] != null) {
          var km = distanceObj['kilometers'];
          if (km is num) {
            distance = km.toDouble();
          } else if (km is String) {
            distance = double.tryParse(km);
          }
        }

        // Check if within radius
        if (distanceObj['isWithinRadius'] != null) {
          isWithinRadius = distanceObj['isWithinRadius'] == true;
        }
      } else if (json['distanceKm'] != null) {
        var km = json['distanceKm'];
        if (km is num) {
          distance = km.toDouble();
        } else if (km is String) {
          distance = double.tryParse(km);
        }
      }
    } catch (e) {
      print("Error extracting distance info: $e");
    }

    // Extract date and time
    String dateStr = '';
    String timeStr = '';

    try {
      if (json['scheduledDate'] != null) {
        dateStr = _extractString(json, 'scheduledDate');
      }

      if (json['scheduledTime'] != null) {
        timeStr = _extractString(json, 'scheduledTime');
      }
    } catch (e) {
      print("Error extracting date/time: $e");
    }

    return Booking(
      id: _extractString(json, '_id'),
      customerName: name,
      customerPhone: phone,
      address: address,
      serviceNames: serviceNames,
      locationType: locationType,
      totalPrice: _extractDouble(json, 'totalPrice'),
      scheduledDate: dateStr,
      scheduledTime: timeStr,
      status: _extractString(json, 'status'),
      distanceKm: distance,
      isWithinRadius: isWithinRadius,
    );
  }

  // Helper method to safely extract strings from any field type
  static String _extractString(dynamic json, String key) {
    try {
      var value = json[key];
      if (value == null) return '';
      if (value is String) return value;
      if (value is num) return value.toString();
      if (value is bool) return value.toString();
      if (value is Map) {
        // If it's a map, try some common fields
        if (value['name'] != null) return value['name'].toString();
        if (value['_id'] != null) return value['_id'].toString();
        // Fall back to the whole object as string
        return value.toString();
      }
      // Fall back to general toString()
      return value.toString();
    } catch (e) {
      print("Error extracting string for key '$key': $e");
      return '';
    }
  }

  // Helper method to safely extract doubles
  static double _extractDouble(dynamic json, String key) {
    try {
      var value = json[key];
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    } catch (e) {
      print("Error extracting double for key '$key': $e");
      return 0.0;
    }
  }
}

class OpenOrderScreen extends StatefulWidget {
  const OpenOrderScreen({super.key});

  @override
  State<OpenOrderScreen> createState() => _OpenOrderScreenState();
}

class _OpenOrderScreenState extends State<OpenOrderScreen> {
  bool _isLoading = true;
  String? _error;
  List<Booking> _availableBookings = [];
  List<Booking> _assignedBookings = [];
  List<Booking> _completedBookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
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

      // First try raw data approach to see if we can even get the API data
      try {
        final response = await http.get(
          Uri.parse('${NetworkConfig.baseUrl}/bookings/dashboard'),
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
          },
        );

        print("API Response Status: ${response.statusCode}");

        if (response.statusCode == 200) {
          print("Successfully received data from API");

          // Try to parse the raw response to see the actual JSON structure
          try {
            final rawData = response.body;

            // First let's examine what we got - print a short sample
            if (rawData.length > 0) {
              print("First 100 chars of response: ${rawData.substring(0, min(100, rawData.length))}...");

              // Try to decode as JSON
              final jsonData = jsonDecode(rawData);

              // Check if it's a list or object
              if (jsonData is List) {
                print("Got a JSON array with ${jsonData.length} items");

                // Process each item with our simplified approach
                _availableBookings = [];
                for (var item in jsonData) {
                  try {
                    _availableBookings.add(Booking.fromDynamic(item));
                  } catch (e) {
                    print("Error parsing booking item: $e");
                  }
                }
                print("Successfully parsed ${_availableBookings.length} bookings");
              }
              else if (jsonData is Map) {
                print("Got a JSON object with keys: ${jsonData.keys.join(', ')}");

                // Check if it has a data array
                if (jsonData['data'] is List) {
                  final dataArray = jsonData['data'] as List;
                  print("Found data array with ${dataArray.length} items");

                  // Process each item with our simplified approach
                  _availableBookings = [];
                  for (var item in dataArray) {
                    try {
                      _availableBookings.add(Booking.fromDynamic(item));
                    } catch (e) {
                      print("Error parsing booking item: $e");
                    }
                  }
                  print("Successfully parsed ${_availableBookings.length} bookings");
                }
              }
            } else {
              print("Received empty response");
            }
          } catch (e) {
            print("Error processing API response: $e");
          }
        } else {
          print("Error response: ${response.body}");
        }
      } catch (e) {
        print("Exception making API call: $e");
      }

      // Try to fetch assigned bookings too
      try {
        final assignedRes = await http.get(
          Uri.parse('${NetworkConfig.baseUrl}/bookings/provider'),
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
          },
        );

        if (assignedRes.statusCode == 200) {
          final jsonData = jsonDecode(assignedRes.body);

          final allAssignedBookings = <Booking>[];

          if (jsonData is List) {
            for (var item in jsonData) {
              try {
                allAssignedBookings.add(Booking.fromDynamic(item));
              } catch (e) {
                print("Error parsing assigned booking: $e");
              }
            }
          }

          // Split into active and completed bookings
          _assignedBookings = allAssignedBookings
              .where((booking) => ['assigned', 'confirmed', 'in_progress'].contains(booking.status))
              .toList();

          _completedBookings = allAssignedBookings
              .where((booking) => ['completed', 'cancelled'].contains(booking.status))
              .toList();

          print("Successfully parsed ${_assignedBookings.length} assigned bookings and ${_completedBookings.length} completed bookings");
        } else {
          print("Error fetching assigned bookings: ${assignedRes.statusCode} - ${assignedRes.body}");
        }
      } catch (e) {
        print("Error fetching assigned bookings: $e");
        // Don't throw here, we still want to show available bookings
      }

    } catch (e) {
      print("Error fetching bookings: $e");
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Helper method to get the smaller of two integers
  int min(int a, int b) => a < b ? a : b;

  // Format date
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day} ${_getMonthName(date.month)} ${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  // Helper method to get month name
  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
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
              Text('Error: $_error',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              CustomSpacers.height24,
              ElevatedButton(
                onPressed: _fetchBookings,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Display all bookings (available, assigned, and completed)
    final allBookings = [..._availableBookings, ..._assignedBookings];

    if (allBookings.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inbox, size: 48, color: Colors.grey),
              CustomSpacers.height16,
              const Text('No bookings available',
                style: TextStyle(color: Colors.grey),
              ),
              CustomSpacers.height24,
              ElevatedButton(
                onPressed: _fetchBookings,
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: allBookings.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) => BookingCardWidget(
          booking: allBookings[index],
          formatDate: _formatDate,
        ),
      ),
    );
  }
}

class BookingCardWidget extends StatelessWidget {
  final Booking booking;
  final Function(String) formatDate;

  const BookingCardWidget({
    super.key,
    required this.booking,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    // Determine booking type and mode
    String type = booking.serviceNames.isNotEmpty
        ? booking.serviceNames.first
        : 'Service';

    String mode = booking.locationType == 'at_home' ? 'At Home' : 'At Salon';

    return Semantics(
      label: '$type booking $mode on ${formatDate(booking.scheduledDate)}',
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            _buildCardTopBanner(type, mode),
            CustomSpacers.height14,
            _buildRowTile(Icons.location_on, booking.address),
            _buildRowTile(Icons.date_range, formatDate(booking.scheduledDate)),
            _buildRowTile(Icons.lock_clock, booking.scheduledTime),
            if (booking.status == 'matching')
              _buildStatusBadge(),
            CustomSpacers.height10,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      strButtonText: "View details",
                      dHeight: 40,
                      bIcon: true,
                      bIconLeft: true,
                      buttonIcon: const Icon(Icons.details_sharp),
                      bgColor: Colors.grey.shade200,
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      buttonAction: () {
                        // Determine which detail screen to show based on the booking type
                        final isAtSalon = booking.locationType != 'at_home';

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => isAtSalon
                                ? SaloonOrderDetailsScreen()
                                : OrderDetailsScreen(booking: booking),  // Pass booking data here
                          ),
                        );
                      },
                    ),
                  ),
                  CustomSpacers.width12,
                  Expanded(
                    child: CustomButton(
                      strButtonText: "Directions",
                      dHeight: 40,
                      bIcon: true,
                      bIconLeft: true,
                      buttonIcon: const Icon(Icons.directions, color: Colors.white),
                      bgColor: Colors.green.shade400,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      buttonAction: () {
                        // You would need location coordinates here
                      },
                    ),
                  ),
                ],
              ),
            ),
            CustomSpacers.height16,
          ],
        ),
      ),
    );
  }

  Widget _buildCardTopBanner(String type, String mode) => Container(
    decoration: const BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(type,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
        Text(mode, style: const TextStyle(color: Colors.white70)),
      ],
    ),
  );

  Widget _buildRowTile(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[800]),
          CustomSpacers.width10,
          Flexible(child: Text(title, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final isWithinRadius = booking.isWithinRadius;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isWithinRadius ? Colors.green.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWithinRadius ? Colors.green.shade200 : Colors.blue.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isWithinRadius ? Icons.check_circle : Icons.location_on,
            size: 16,
            color: isWithinRadius ? Colors.green.shade700 : Colors.blue.shade700,
          ),
          CustomSpacers.width6,
          Text(
            isWithinRadius
                ? 'Within Your Area'
                : '${booking.distanceKm?.toStringAsFixed(1) ?? "?"} km away',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isWithinRadius ? Colors.green.shade700 : Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }
}