import 'package:flutter/material.dart';

class PriceSelectionPage extends StatefulWidget {
  const PriceSelectionPage({super.key});

  @override
  State<PriceSelectionPage> createState() => _PriceSelectionPageState();
}

class _PriceSelectionPageState extends State<PriceSelectionPage> {
  final List<String> categories = ['AC', 'Washing Machine', 'Microwave', 'Inverter'];
  final Map<String, List<Map<String, dynamic>>> servicesMap = {
    'AC': [
      {'name': 'Book a Visit', 'price': 199},
      {'name': 'Split AC Installation', 'price': 399},
    ],
    'Washing Machine': [
      {'name': 'Drum Repair', 'price': 299},
    ],
    'Microwave': [
      {'name': 'Fuse Replacement', 'price': 149},
    ],
    'Inverter': [
      {'name': 'Battery Replacement', 'price': 499},
    ],
  };

  String selectedCategory = 'AC';

  void _editPriceDialog(int index) {
    final controller = TextEditingController(
      text: servicesMap[selectedCategory]![index]['price'].toString(),
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Edit Price'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'New Price (Rs)',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newPrice = int.tryParse(controller.text);
                if (newPrice != null) {
                  setState(() {
                    servicesMap[selectedCategory]![index]['price'] = newPrice;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedServices = servicesMap[selectedCategory]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Sheet' , style: TextStyle(color: Colors.white ,fontWeight: FontWeight.w500 , fontSize: 20),),
        backgroundColor: Colors.black,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Category selector
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            /// Services list
            Expanded(
              child: ListView.builder(
                itemCount: selectedServices.length,
                itemBuilder: (context, index) {
                  final service = selectedServices[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Service Card
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(service['name']),
                                Text('Rs ${service['price']}'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        /// Edit Price Button
                        ElevatedButton(
                          onPressed: () => _editPriceDialog(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          ),
                          child: const Text(
                            'Edit Price',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
