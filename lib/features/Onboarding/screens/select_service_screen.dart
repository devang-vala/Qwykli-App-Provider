import 'package:flutter/material.dart';
import 'package:shortly_provider/core/app_imports.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

void main() => runApp(MaterialApp(home: PriceSelectionPage()));

class PriceSelectionPage extends StatefulWidget {
  @override
  _PriceSelectionPageState createState() => _PriceSelectionPageState();
}

class _PriceSelectionPageState extends State<PriceSelectionPage> {
  final List<String> services = [
    'AC',
    'Fridge',
    'Washing Machine',
    'Fan',
    'Cooler',
    'TV',
  ];

  Map<String, List<Map<String, String>>> serviceDetails = {};

  void _openServiceDialog(String service) {
    showDialog(
      context: context,
      builder: (context) {
        return ServiceDialog(
          service: service,
          existingDetails: serviceDetails[service] ?? [],
          onUpdate: (updatedDetails) {
            setState(() {
              serviceDetails[service] = updatedDetails;
            });
          },
        );
      },
    );
  }

  Widget _buildServiceCard(String service) {
    final hasDetails = serviceDetails.containsKey(service);
    return GestureDetector(
      onTap: () => _openServiceDialog(service),
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 237, 237, 237),
          borderRadius: BorderRadius.circular(12)
        ),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(service, style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w500)),
              hasDetails
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.radio_button_unchecked, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Select Services' , style: TextStyle(fontSize: 20),)),
      body: ListView(
        children: services.map(_buildServiceCard).toList(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          dHeight: 50.h,
          bgColor: Colors.blue,
          strButtonText: "Continue", buttonAction: (){})
      ),
    );
  }
}

class ServiceDialog extends StatefulWidget {
  final String service;
  final List<Map<String, String>> existingDetails;
  final Function(List<Map<String, String>>) onUpdate;

  ServiceDialog({
    required this.service,
    required this.existingDetails,
    required this.onUpdate,
  });

  @override
  _ServiceDialogState createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<ServiceDialog> {
  List<Map<String, String>> details = [];

  @override
  void initState() {
    super.initState();
    details = List.from(widget.existingDetails);
  }

  void _addNewDetail() {
    String? newName;
    String? newPrice;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Service Detail" , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w500),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Service Name"),
                onChanged: (value) => newName = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                onChanged: (value) => newPrice = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Add"),
              onPressed: () {
                if (newName != null && newPrice != null) {
                  setState(() {
                    details.add({"name": newName!, "price": newPrice!});
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailTile(Map<String, String> detail) {
    return Card(
      color: Colors.grey[100],
      child: ListTile(
        title: Text('${detail["name"]}: ₹${detail["price"]}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("For ${widget.service}" , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w500 ),),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ...details.map(_buildDetailTile),
           CustomSpacers.height12,
            GestureDetector(
              onTap: _addNewDetail,
              child: Column(
                children: [
                  CircleAvatar( radius: 15, child: Icon(Icons.add )),
                  CustomSpacers.height6,
                  Text("Add other"),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            widget.onUpdate(details);
            Navigator.pop(context);
          },
          child: Text("Continue"),
        ),
      ],
    );
  }
}
