import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/core/services/profile_service.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/auth/data/signup_provider.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/l10n/app_localizations.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

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
    try {
      Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        mode: Mode.overlay,
        language: "en",
        components: [Component(Component.country, "in")],
        types: [],
        strictbounds: false,
        radius: 10000,
        onError: (PlacesAutocompleteResponse response) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${response.errorMessage}")),
          );
        },
      );

      if (p != null) {
        final places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
        try {
          final detail = await places.getDetailsByPlaceId(p.placeId!);
          if (detail.status == "OK") {
            final loc = detail.result.geometry?.location;
            String areaName = '';
            String city = 'Delhi';
            for (var comp in detail.result.addressComponents) {
              if (comp.types.contains('sublocality_level_1') ||
                  comp.types.contains('sublocality') ||
                  comp.types.contains('neighborhood')) {
                areaName = comp.longName;
              }
              if (comp.types.contains('locality') ||
                  comp.types.contains('administrative_area_level_2')) {
                city = comp.longName;
              }
            }
            if (areaName.isEmpty) {
              areaName = p.description?.split(',')[0] ?? 'Unnamed Area';
            }
            if (loc != null) {
              // Show dialog to edit area name before saving
              String editedAreaName = areaName;
              await showDialog(
                context: context,
                builder: (context) {
                  final areaNameController =
                      TextEditingController(text: areaName);
                  return AlertDialog(
                    title: const Text('Confirm Service Area'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: areaNameController,
                          decoration:
                              const InputDecoration(labelText: 'Area Name'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: TextEditingController(text: city),
                          decoration: const InputDecoration(labelText: 'City'),
                          enabled: false,
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
                          editedAreaName = areaNameController.text.trim();
                          if (editedAreaName.isEmpty) return;
                          await ProfileService.addProviderServiceArea({
                            'areaName': editedAreaName,
                            'city': city,
                            'coordinates': [loc.lng, loc.lat],
                          });
                          Navigator.pop(context);
                          _fetchServiceAreas();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "Added service area: $editedAreaName")),
                          );
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Could not get location for selected place")),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("API Error: ${detail.status}")),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error getting place details: $e")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
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

const String kGoogleApiKey = "AIzaSyAlcxv4LvUepfvQWilRGizpaGAcEb4uG9g";
