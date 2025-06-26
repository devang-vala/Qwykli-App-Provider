import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/auth_provider.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'document_page.dart';

const String kGoogleApiKey = "AIzaSyAlcxv4LvUepfvQWilRGizpaGAcEb4uG9g";

class ServiceAreaPage extends StatefulWidget {
  @override
  State<ServiceAreaPage> createState() => _ServiceAreaPageState();
}

class _ServiceAreaPageState extends State<ServiceAreaPage> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _handleAddArea(
      BuildContext context, ProviderRegistrationProvider provider) async {
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
              provider.setServiceAreas([
                ...provider.serviceAreas,
                ServiceArea(
                    name: areaName, city: city, coordinates: [loc.lng, loc.lat])
              ]);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Added service area: $areaName")),
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

  void _onNext(BuildContext context, ProviderRegistrationProvider provider) {
    if (provider.serviceAreas.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: provider,
            child: DocumentPage(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one service area.')),
      );
    }
  }

  void _onBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderRegistrationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Service Areas'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _onBack(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleAddArea(context, provider),
        icon: Icon(Icons.add_location_alt),
        label: Text('Add Area'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _onBack(context),
                      icon: Icon(Icons.arrow_back),
                      label: Text('Back'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _onNext(context, provider),
                      icon: Icon(Icons.arrow_forward),
                      label: Text('Next'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Add Service Areas',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 8),
                if (provider.serviceAreas.isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_off,
                            size: 64, color: Colors.grey.shade300),
                        SizedBox(height: 16),
                        Text(
                          'No service areas added yet.\nTap the "+" button to add locations.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ...provider.serviceAreas.asMap().entries.map((entry) {
                  final i = entry.key;
                  final area = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on, color: Colors.blue),
                            SizedBox(height: 8),
                            TextFormField(
                              initialValue: area.name,
                              decoration: InputDecoration(
                                labelText: 'Area Name',
                                helperText: 'e.g. Connaught Place',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Area name required';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                final newAreas = List<ServiceArea>.from(
                                    provider.serviceAreas);
                                newAreas[i] = ServiceArea(
                                  name: val,
                                  city: area.city,
                                  coordinates: area.coordinates,
                                );
                                provider.setServiceAreas(newAreas);
                              },
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              initialValue: area.city,
                              decoration: InputDecoration(
                                labelText: 'City',
                                helperText: 'e.g. Delhi',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'City required';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                final newAreas = List<ServiceArea>.from(
                                    provider.serviceAreas);
                                newAreas[i] = ServiceArea(
                                  name: area.name,
                                  city: val,
                                  coordinates: area.coordinates,
                                );
                                provider.setServiceAreas(newAreas);
                              },
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Tooltip(
                                  message: 'Remove area',
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      final newAreas = List<ServiceArea>.from(
                                          provider.serviceAreas);
                                      newAreas.removeAt(i);
                                      provider.setServiceAreas(newAreas);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Removed service area: ${area.name}")),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Coordinates: ${area.coordinates[1].toStringAsFixed(6)}, ${area.coordinates[0].toStringAsFixed(6)}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
