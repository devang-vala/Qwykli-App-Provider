import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shortly_provider/core/network/network_config.dart';
import '../data/auth_provider.dart';
// Import the next page (to be created)
import 'service_area_page.dart';

class SubcategoryPage extends StatefulWidget {
  @override
  State<SubcategoryPage> createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> {
  Map<String, List<Map<String, dynamic>>> subcategoriesByCategory = {};
  Map<String, String> categoryNames = {}; // catId -> name
  bool loading = false;
  String fetchError = '';
  List<String> _lastFetchedCategories = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAllSubcategoriesAndNames();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider =
        Provider.of<ProviderRegistrationProvider>(context, listen: false);
    if (!listEquals(provider.categories, _lastFetchedCategories)) {
      _fetchAllSubcategoriesAndNames();
    }
  }

  Future<void> _fetchAllSubcategoriesAndNames() async {
    final provider =
        Provider.of<ProviderRegistrationProvider>(context, listen: false);
    final selectedCategories = provider.categories;
    setState(() {
      loading = true;
      fetchError = '';
    });
    try {
      Map<String, List<Map<String, dynamic>>> result = {};
      Map<String, String> names = {};
      for (final catId in selectedCategories) {
        // Fetch category details (for name)
        final catUrl = '${NetworkConfig.baseUrl}/categories/$catId';
        final catResp = await http.get(Uri.parse(catUrl));
        if (catResp.statusCode == 200) {
          final catData = jsonDecode(catResp.body);
          names[catId] = catData['name'] ?? catId;
        } else {
          names[catId] = catId;
        }
        // Fetch subcategories
        final url = '${NetworkConfig.baseUrl}/categories/$catId/subcategories';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          result[catId] = List<Map<String, dynamic>>.from(data);
        } else {
          result[catId] = [];
        }
      }
      setState(() {
        subcategoriesByCategory = result;
        categoryNames = names;
        loading = false;
        _lastFetchedCategories = List<String>.from(selectedCategories);
      });
    } catch (e) {
      setState(() {
        fetchError = 'Error: $e';
        loading = false;
      });
    }
  }

  void _toggleSubcategory(
      String catId, String subId, ProviderRegistrationProvider provider) {
    final current = provider.selectedSubcategories[catId] ?? [];
    final updated = List<String>.from(current);
    if (updated.contains(subId)) {
      updated.remove(subId);
    } else {
      updated.add(subId);
    }
    final newMap =
        Map<String, List<String>>.from(provider.selectedSubcategories);
    newMap[catId] = updated;
    provider.setSelectedSubcategories(newMap);
  }

  void _onNext(BuildContext context, ProviderRegistrationProvider provider) {
    // Validation: every selected category must have at least one subcategory
    bool valid = true;
    for (final catId in provider.categories) {
      if (provider.selectedSubcategories[catId] == null ||
          provider.selectedSubcategories[catId]!.isEmpty) {
        valid = false;
        break;
      }
    }
    if (valid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: provider,
            child: ServiceAreaPage(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Please select at least one subcategory for each category.')),
      );
    }
  }

  void _onBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderRegistrationProvider>(context);
    final selectedCategories = provider.categories;
    final missing = selectedCategories
        .where((catId) =>
            provider.selectedSubcategories[catId] == null ||
            provider.selectedSubcategories[catId]!.isEmpty)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Subcategories'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _onBack(context),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : fetchError.isNotEmpty
              ? Center(
                  child: Text(fetchError, style: TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (selectedCategories.isEmpty)
                        Text('No categories selected.'),
                      if (missing.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Please select at least one subcategory for: ${missing.map((id) => categoryNames[id] ?? id).join(", ")}',
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      for (final catId in selectedCategories)
  ExpansionTile(
    title: Text(
      categoryNames[catId] ?? catId,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: missing.contains(catId) ? Colors.orange : null,
      ),
    ),
    children: [
      if (subcategoriesByCategory[catId]?.isNotEmpty == true)
        ...subcategoriesByCategory[catId]!.map((sub) {
          final subId = sub['_id'] ?? '';
          final subName = sub['name'] ?? '';
          final isChecked = provider
                  .selectedSubcategories[catId]
                  ?.contains(subId) ??
              false;
          return CheckboxListTile(
            title: Text(subName),
            value: isChecked,
            onChanged: (_) =>
                _toggleSubcategory(catId, subId, provider),
          );
        }).toList()
      else
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(
            'No subcategories available.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
    ],
  ),

                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () => _onBack(context),
                            child: Text('Back'),
                          ),
                          ElevatedButton(
                            onPressed: () => _onNext(context, provider),
                            child: Text('Next'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
