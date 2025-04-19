import 'package:flutter/material.dart';
import 'package:shortly_provider/route/custom_navigator.dart';

class WorkerListScreen extends StatefulWidget {
  const WorkerListScreen({super.key});

  @override
  State<WorkerListScreen> createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  List<Worker> workers = [];

  void _showAddWorkerDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController contactController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Worker"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(labelText: 'Contact'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final contact = contactController.text.trim();
              if (name.isNotEmpty && contact.isNotEmpty) {
                setState(() {
                  workers.add(Worker(name: name, contact: contact));
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerCard(Worker worker) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.person, color: Colors.blue),
        title: Text(
          worker.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(worker.contact,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
        trailing: Icon(
          Icons.verified,
          size: 30,
        ),
      ),
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
          "Worker List",
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: workers.isEmpty
          ? const Center(child: Text("No workers added yet."))
          : ListView.builder(
              itemCount: workers.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildWorkerCard(workers[index]),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWorkerDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Worker {
  final String name;
  final String contact;

  Worker({required this.name, required this.contact});
}
