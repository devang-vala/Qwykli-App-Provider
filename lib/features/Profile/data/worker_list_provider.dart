import 'package:flutter/material.dart';

class Worker {
  final String name;
  final String role;

  Worker({required this.name, required this.role});
}

class WorkerListProvider extends ChangeNotifier {
  final List<Worker> _workers = [];

  List<Worker> get workers => List.unmodifiable(_workers);

  bool addWorker(String name, String role) {
    if (name.trim().isEmpty || role.trim().isEmpty) return false;
    _workers.add(Worker(name: name, role: role));
    notifyListeners();
    return true;
  }

  void removeWorker(int index) {
    if (index >= 0 && index < _workers.length) {
      _workers.removeAt(index);
      notifyListeners();
    }
  }
}
