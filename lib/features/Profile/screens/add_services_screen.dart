import 'package:shortly_provider/core/app_imports.dart';
import 'package:shortly_provider/core/constants/app_data.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/ui/widget/select_service_widegt.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/features/auth/data/signup_provider.dart';
import 'package:shortly_provider/core/services/profile_service.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  List<dynamic> myServices = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final services = await ProfileService.getProviderServices();
      setState(() {
        myServices = services;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _removeService(String serviceId) async {
    setState(() {
      isLoading = true;
    });
    try {
      await ProfileService.removeProviderService(serviceId);
      await _fetchServices();
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAddServiceDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AddServiceDialog(
          onServiceAdded: _fetchServices,
          myServices: myServices,
        );
      },
    );
  }

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
          "Add Services",
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddServiceDialog,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : myServices.isEmpty
                  ? Center(child: Text('No services added yet.'))
                  : ListView.builder(
                      itemCount: myServices.length,
                      itemBuilder: (context, index) {
                        final service = myServices[index];
                        final serviceData = service['service'];
                        String serviceName;
                        if (serviceData is Map &&
                            serviceData.containsKey('name')) {
                          serviceName = serviceData['name'] ?? 'Service';
                        } else if (serviceData is String) {
                          serviceName = serviceData;
                        } else {
                          // Debug print for unexpected type
                          print(
                              'Unexpected type for service[\'service\']: \\${serviceData.runtimeType}');
                          serviceName = 'Service';
                        }
                        final price = service['price']?.toString() ?? '';
                        final duration = service['duration']?.toString() ?? '';
                        return ListTile(
                          title: Text(serviceName),
                          subtitle: Text('₹$price | $duration min'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _removeService(service['_id'] ?? ''),
                          ),
                        );
                      },
                    ),
    );
  }
}

class AddServiceDialog extends StatefulWidget {
  final VoidCallback onServiceAdded;
  final List<dynamic> myServices;
  const AddServiceDialog(
      {Key? key, required this.onServiceAdded, required this.myServices})
      : super(key: key);

  @override
  State<AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends State<AddServiceDialog> {
  List<dynamic> availableServices = [];
  String? selectedServiceId;
  String price = '';
  String duration = '';
  bool isLoading = true;
  String? error;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchAvailableServices();
  }

  Future<void> _fetchAvailableServices() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final allServices = await ProfileService.getAllServices();
      final myServiceIds = widget.myServices
          .map((s) {
            final serviceData = s['service'];
            if (serviceData is Map && serviceData.containsKey('_id')) {
              return serviceData['_id'];
            } else if (serviceData is String) {
              return serviceData;
            } else {
              print(
                  'Unexpected type for s[\'service\'] in AddServiceDialog: \\${serviceData.runtimeType}');
              return null;
            }
          })
          .where((id) => id != null)
          .toSet();
      setState(() {
        availableServices =
            allServices.where((s) => !myServiceIds.contains(s['_id'])).toList();
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addService() async {
    if (selectedServiceId == null || price.isEmpty || duration.isEmpty) return;
    setState(() {
      isSubmitting = true;
      error = null;
    });
    try {
      await ProfileService.addProviderService({
        'service': selectedServiceId,
        'price': double.tryParse(price) ?? 0,
        'duration': int.tryParse(duration) ?? 0,
      });
      widget.onServiceAdded();
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Service'),
      content: isLoading
          ? SizedBox(
              height: 100, child: Center(child: CircularProgressIndicator()))
          : error != null
              ? Text(error!)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedServiceId,
                      items: availableServices
                          .map((s) => DropdownMenuItem<String>(
                                value: s['_id']?.toString() ?? '',
                                child: Text(s['name'] ?? ''),
                              ))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => selectedServiceId = val),
                      decoration: InputDecoration(labelText: 'Service'),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Price (₹)'),
                      onChanged: (val) => setState(() => price = val),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Duration (min)'),
                      onChanged: (val) => setState(() => duration = val),
                    ),
                  ],
                ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isSubmitting ||
                  selectedServiceId == null ||
                  price.isEmpty ||
                  duration.isEmpty
              ? null
              : _addService,
          child: isSubmitting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : Text('Add'),
        ),
      ],
    );
  }
}
