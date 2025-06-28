import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shortly_provider/core/network/network_config.dart';
import 'package:shortly_provider/core/services/profile_service.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/route/app_pages.dart';

class AddServicesScreen extends StatefulWidget {
  const AddServicesScreen({Key? key}) : super(key: key);

  @override
  State<AddServicesScreen> createState() => _AddServicesScreenState();
}

class _AddServicesScreenState extends State<AddServicesScreen> {
  bool isLoading = true;
  String? error;
  List<dynamic> categories = [];
  List<dynamic> allServices = [];
  List<dynamic> filteredServices = [];
  List<dynamic> providerServices = [];
  String? selectedCategoryId;
  String? selectedServiceId;
  final TextEditingController priceController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  bool isAdding = false;
  String? addError;
  String? addSuccess;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      // Fetch categories - API returns a list directly
      final catRes =
          await http.get(Uri.parse('${NetworkConfig.baseUrl}/categories'));
      if (catRes.statusCode != 200)
        throw Exception('Failed to load categories');
      final catData = jsonDecode(catRes.body);
      categories = catData is List ? catData : [];

      // Fetch all services - API returns a list directly
      allServices = await ProfileService.getAllServices();

      // Fetch provider's current services
      providerServices = await ProfileService.getProviderServices();

      setState(() {
        isLoading = false;
        filteredServices = allServices;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _filterServicesByCategory(String? categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
      if (categoryId == null) {
        filteredServices = allServices;
      } else {
        // Filter services by category ID - handle both string and object category formats
        filteredServices = allServices.where((service) {
          final serviceCategory = service['category'];
          if (serviceCategory is Map) {
            return serviceCategory['_id'] == categoryId;
          } else if (serviceCategory is String) {
            return serviceCategory == categoryId;
          }
          return false;
        }).toList();
      }
      selectedServiceId = null;
    });
  }

  bool _isServiceAlreadyAdded(String serviceId) {
    // providerServices may have 'service' as an object or string
    return providerServices.any((ps) {
      final psService = ps['service'];
      if (psService is Map) {
        return psService['_id'] == serviceId;
      } else if (psService is String) {
        return psService == serviceId;
      }
      return false;
    });
  }

  Future<void> _addService() async {
    if (selectedServiceId == null ||
        priceController.text.isEmpty ||
        durationController.text.isEmpty) {
      setState(() {
        addError = 'Please select a service and enter price and duration.';
        addSuccess = null;
      });
      return;
    }
    if (_isServiceAlreadyAdded(selectedServiceId!)) {
      setState(() {
        addError = 'You have already added this service.';
        addSuccess = null;
      });
      return;
    }
    setState(() {
      isAdding = true;
      addError = null;
      addSuccess = null;
    });
    try {
      final price = double.tryParse(priceController.text);
      final duration = int.tryParse(durationController.text);
      if (price == null || duration == null)
        throw Exception('Invalid price or duration');
      final result = await ProfileService.addProviderService({
        'service': selectedServiceId,
        'price': price,
        'duration': duration,
      });
      // Refresh provider services after adding
      providerServices = await ProfileService.getProviderServices();
      setState(() {
        addSuccess = 'Service added successfully!';
        addError = null;
        isAdding = false;
      });
      priceController.clear();
      durationController.clear();
      selectedServiceId = null;
      // Optionally, pop or refresh
      // CustomNavigator.pushReplace(context, AppPages.profileScreen);
    } catch (e) {
      setState(() {
        addError = e.toString();
        addSuccess = null;
        isAdding = false;
      });
    }
  }

  Widget _buildProviderServicesList() {
    if (providerServices.isEmpty) {
      return const Text('You have not added any services yet.',
          style: TextStyle(color: Colors.grey));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your Added Services:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...providerServices.map((ps) {
          final service = ps['service'] is Map ? ps['service'] : null;
          final serviceName = service != null
              ? (service['name'] ?? '')
              : ps['service'].toString();
          final price = ps['price'] ?? '-';
          final duration = ps['duration'] ?? '-';
          final isActive = ps['isActive'] == true;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(serviceName),
              subtitle: Text('Price: $price, Duration: $duration min'),
              trailing: isActive
                  ? const Text('Active', style: TextStyle(color: Colors.green))
                  : const Text('Inactive', style: TextStyle(color: Colors.red)),
            ),
          );
        }).toList(),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  void dispose() {
    priceController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add Service')),
        body: Center(child: Text('Error: $error')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Add Service')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProviderServicesList(),
              const Text('Select Category',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedCategoryId,
                hint: const Text('Choose category'),
                items: categories.map<DropdownMenuItem<String>>((cat) {
                  return DropdownMenuItem<String>(
                    value: cat['_id'],
                    child: Text(cat['name'] ?? ''),
                  );
                }).toList(),
                onChanged: (val) => _filterServicesByCategory(val),
              ),
              const SizedBox(height: 16),
              const Text('Select Service',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedServiceId,
                hint: const Text('Choose service'),
                items: filteredServices.map<DropdownMenuItem<String>>((srv) {
                  final alreadyAdded = _isServiceAlreadyAdded(srv['_id']);
                  return DropdownMenuItem<String>(
                    value: alreadyAdded ? null : srv['_id'],
                    enabled: !alreadyAdded,
                    child: Row(
                      children: [
                        Text(srv['name'] ?? ''),
                        if (alreadyAdded)
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.check,
                                color: Colors.green, size: 16),
                          ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedServiceId = val;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Duration (minutes)'),
              ),
              const SizedBox(height: 24),
              if (addError != null)
                Text(addError!, style: const TextStyle(color: Colors.red)),
              if (addSuccess != null)
                Text(addSuccess!, style: const TextStyle(color: Colors.green)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isAdding ? null : _addService,
                  child: isAdding
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Add Service'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
