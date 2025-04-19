import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Onboarding/data/signup_provider.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class WorkingAreaScreen extends StatefulWidget {
  const WorkingAreaScreen({super.key});

  @override
  State<WorkingAreaScreen> createState() => _WorkingAreaScreenState();
}

class _WorkingAreaScreenState extends State<WorkingAreaScreen> {
  List<String> cities = ['Delhi', 'Noida', 'Gurgaon', 'Ghaziabad', 'Faridabad'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 63, 164),
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
          "Working Area",
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) => _buildCityTile(cities[index]),
      ),
      floatingActionButton: Consumer<SignupProvider>(
        builder: (context, provider, _) => FloatingActionButton(
          onPressed: () {
        
            _showLocationBottomSheet(provider);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildCityTile(String city) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.location_city, color: Colors.deepPurple),
        title: Text(city),
      ),
    );
  }


  void _showLocationBottomSheet(SignupProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchlocation,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
                onChanged: (value) {
                  provider.updateSearchQuery(value);
                  setModalState(() {});
                },
              ),
              CustomSpacers.height10,
              SizedBox(
                height: 350.h,
                child: ListView(
                  children: provider.filteredLocations.map((location) {
                    final selected =
                        provider.selectedLocations.contains(location);
                    return CheckboxListTile(
                      title: Text(location),
                      value: selected,
                      onChanged: (_) {
                        provider.toggleLocation(location);
                        setModalState(() {});
                      },
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Done"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
