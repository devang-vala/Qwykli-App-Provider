// ================= CLEANED WORKER LIST SCREEN ====================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Profile/data/worker_list_provider.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

class WorkerListScreen extends StatelessWidget {
  const WorkerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkerListProvider(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("My Workers"  , style: TextStyle(color: Colors.white , fontWeight: FontWeight.w400 , fontSize: 18),),
          centerTitle: false,
        ),
        body: Consumer<WorkerListProvider>(
          builder: (context, provider, _) => Column(
            children: [
              Expanded(
                child: provider.workers.isEmpty
                    ? const Center(child: Text("No workers added yet."))
                    : ListView.builder(
                        itemCount: provider.workers.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) => Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: const Icon(Icons.badge),
                            title: Text(provider.workers[index].name),
                            subtitle: Text(provider.workers[index].role),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => provider.removeWorker(index),
                            ),
                          ),
                        ),
                      ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: CustomButton(
                  strButtonText: "Add Worker",
                  bgColor: Colors.black,
                  textStyle: const TextStyle(color: Colors.white),
                  buttonAction: () => _showAddWorkerDialog(context),
                  dHeight: 50.h,
                  dWidth: 200.w,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showAddWorkerDialog(BuildContext context) {
    final provider = Provider.of<WorkerListProvider>(context, listen: false);
    final nameController = TextEditingController();
    final roleController = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Add Worker"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                label: 'Enter worker name',
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Semantics(
                label: 'Enter worker role',
                child: TextField(
                  controller: roleController,
                  decoration: const InputDecoration(
                    hintText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(errorMessage!,
                    style: const TextStyle(color: Colors.red)),
              ]
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final role = roleController.text.trim();
                final added = provider.addWorker(name, role);
                if (added) {
                  Navigator.pop(context);
                } else {
                  setState(() => errorMessage = "Please fill in all fields.");
                }
              },
              child: const Text("Add"),
            )
          ],
        ),
      ),
    );
  }
}