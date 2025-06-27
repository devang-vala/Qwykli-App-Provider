import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/core/services/profile_service.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/auth/data/signup_provider.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/l10n/app_localizations.dart';

class WorkingAreaScreen extends StatefulWidget {
  const WorkingAreaScreen({super.key});

  @override
  State<WorkingAreaScreen> createState() => _WorkingAreaScreenState();
}

class _WorkingAreaScreenState extends State<WorkingAreaScreen> {
  List<dynamic> serviceAreas = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchServiceAreas();
  }

  Future<void> _fetchServiceAreas() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final areas = await ProfileService.getProviderServiceAreas();
      setState(() {
        serviceAreas = areas;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _addServiceArea() async {
    String areaName = '';
    String city = '';
    String lng = '';
    String lat = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Service Area'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Area Name'),
              onChanged: (v) => areaName = v,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'City'),
              onChanged: (v) => city = v,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.number,
              onChanged: (v) => lng = v,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.number,
              onChanged: (v) => lat = v,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (areaName.isEmpty ||
                  city.isEmpty ||
                  lng.isEmpty ||
                  lat.isEmpty) return;
              try {
                await ProfileService.addProviderServiceArea({
                  'areaName': areaName,
                  'city': city,
                  'coordinates': [
                    double.tryParse(lng) ?? 0,
                    double.tryParse(lat) ?? 0
                  ],
                });
                Navigator.pop(context);
                _fetchServiceAreas();
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to add area: $e')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _removeServiceArea(String areaId) async {
    try {
      await ProfileService.removeProviderServiceArea(areaId);
      _fetchServiceAreas();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove area: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 63, 164),
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: GestureDetector(
            onTap: () {
              CustomNavigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text(
          "Working Area",
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : serviceAreas.isEmpty
                  ? const Center(child: Text('No service areas added.'))
                  : ListView.builder(
                      itemCount: serviceAreas.length,
                      itemBuilder: (context, index) {
                        final area = serviceAreas[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                          child: ListTile(
                            leading: const Icon(Icons.location_city,
                                color: Colors.deepPurple),
                            title: Text(area['name'] ?? ''),
                            subtitle: Text(area['city'] ?? ''),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeServiceArea(area['_id']),
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addServiceArea,
        child: const Icon(Icons.add),
      ),
    );
  }
}
