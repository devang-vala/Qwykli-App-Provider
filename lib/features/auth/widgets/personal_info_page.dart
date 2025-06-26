import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shortly_provider/core/network/network_config.dart';
import '../data/auth_provider.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'subcategory_page.dart';

const String kGoogleApiKey = "AIzaSyAlcxv4LvUepfvQWilRGizpaGAcEb4uG9g";

class PersonalInfoPage extends StatefulWidget {
  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> categories = [];
  bool loading = true;
  String fetchError = '';
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    setState(() {
      loading = true;
      fetchError = '';
    });
    try {
      final url = '${NetworkConfig.baseUrl}/categories';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          categories = List<Map<String, dynamic>>.from(
              data.where((cat) => cat['isActive'] == true));
          loading = false;
        });
      } else {
        setState(() {
          fetchError = 'Failed to load categories';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        fetchError = 'Error: $e';
        loading = false;
      });
    }
  }

  Future<void> _handlePressButton(
      BuildContext context, ProviderRegistrationProvider provider) async {
    try {
      Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        mode: Mode.overlay,
        language: "en",
        components: [Component(Component.country, "in")],
        types: ["establishment", "geocode"],
        strictbounds: false,
        onError: (PlacesAutocompleteResponse response) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${response.errorMessage}")),
          );
        },
      );

      if (p != null && p.placeId != null) {
        provider.setSalonAddress(p.description ?? "");
        try {
          final places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
          final detail = await places.getDetailsByPlaceId(p.placeId!);

          if (detail.status == "OK" &&
              detail.result.geometry?.location != null) {
            final loc = detail.result.geometry!.location;
            provider.setSalonLocation([loc.lng, loc.lat]);
            if (_mapController != null) {
              await _mapController!.animateCamera(
                  CameraUpdate.newLatLng(LatLng(loc.lat, loc.lng)));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Could not get location details")),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error getting location details")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error opening places search")),
      );
    }
  }

  void _onNext(BuildContext context, ProviderRegistrationProvider provider) {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: provider,
            child: SubcategoryPage(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderRegistrationProvider>(context);
    final isSalonSelected = provider.categories.any((catId) {
      final cat =
          categories.firstWhere((c) => c['_id'] == catId, orElse: () => {});
      return (cat['name'] ?? '').toString().toLowerCase().contains('salon');
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Info'),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24, left: 8, right: 8, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: provider.name,
                onChanged: provider.setName,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Name is required' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                initialValue: provider.email,
                onChanged: provider.setEmail,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email is required';
                  if (!RegExp(r'^\S+@\S+\.\S+').hasMatch(v))
                    return 'Invalid email';
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                initialValue: provider.password,
                onChanged: provider.setPassword,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) =>
                    v == null || v.length < 6 ? 'Min 6 characters' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                initialValue: provider.confirmPassword,
                onChanged: provider.setConfirmPassword,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (v) =>
                    v != provider.password ? 'Passwords do not match' : null,
              ),
              SizedBox(height: 20),
              Text('Select Categories',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              if (loading)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
              else if (fetchError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(fetchError, style: TextStyle(color: Colors.red)),
                )
              else
                Column(
                  children: categories.map((cat) {
                    final isSelected = provider.categories.contains(cat['_id']);
                    return CheckboxListTile(
                      title: Text(cat['name'] ?? ''),
                      value: isSelected,
                      onChanged: (_) {
                        final newCats = List<String>.from(provider.categories);
                        if (isSelected) {
                          newCats.remove(cat['_id']);
                        } else {
                          newCats.add(cat['_id']);
                        }
                        provider.setCategories(newCats);
                      },
                    );
                  }).toList(),
                ),
              if (isSalonSelected) ...[
                Divider(),
                SwitchListTile(
                  title: Text('I have a salon'),
                  value: provider.hasSalon,
                  onChanged: provider.setHasSalon,
                ),
                if (provider.hasSalon) ...[
                  GestureDetector(
                    onTap: () => _handlePressButton(context, provider),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller:
                            TextEditingController(text: provider.salonAddress),
                        decoration: InputDecoration(
                          labelText: 'Salon Address (tap to search)',
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  const Text(
                    'Place dart on your salon location in map:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: provider.salonLocation != null
                            ? LatLng(provider.salonLocation![1],
                                provider.salonLocation![0])
                            : const LatLng(28.6139, 77.2090),
                        zoom: 15,
                      ),
                      markers: provider.salonLocation != null
                          ? {
                              Marker(
                                markerId: const MarkerId('salon'),
                                position: LatLng(provider.salonLocation![1],
                                    provider.salonLocation![0]),
                                draggable: true,
                                onDragEnd: (pos) {
                                  provider.setSalonLocation(
                                      [pos.longitude, pos.latitude]);
                                },
                              ),
                            }
                          : {},
                      onTap: (pos) {
                        provider
                            .setSalonLocation([pos.longitude, pos.latitude]);
                      },
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                    ),
                  ),
                  if (provider.salonLocation != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                          'Selected Location: ${provider.salonLocation![1]}, ${provider.salonLocation![0]}'),
                    ),
                  SizedBox(height: 24),
                  TextFormField(
                    initialValue: provider.salonCompleteAddress,
                    onChanged: provider.setSalonCompleteAddress,
                    decoration: InputDecoration(
                      labelText: 'Complete Salon Address',
                      hintText:
                          'Enter full address including landmark, street, etc.',
                    ),
                    validator: (v) {
                      if (provider.hasSalon && (v == null || v.isEmpty)) {
                        return 'Complete salon address is required';
                      }
                      return null;
                    },
                  ),
                ]
              ],
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => _onNext(context, provider),
                    child: Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
