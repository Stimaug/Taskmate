import 'package:flutter/foundation.dart';
import '../data/dummy_tasks.dart';
import '../models/task.dart';

enum TaskFilter { all, active, completed }

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = buildDummyTasks();
  String _searchQuery = '';
  TaskFilter _filter = TaskFilter.all;
  int _idCounter = 100;

  // ---------- Getter ----------
  String get searchQuery => _searchQuery;
  TaskFilter get filter => _filter;

  int get totalCount => _tasks.length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get activeCount => totalCount - completedCount;

  /// Daftar tugas setelah filter + pencarian diterapkan.
  List<Task> get visibleTasks {
    final query = _searchQuery.trim().toLowerCase();
    return _tasks.where((t) {
      final matchFilter = switch (_filter) {
        TaskFilter.all => true,
        TaskFilter.active => !t.isCompleted,
        TaskFilter.completed => t.isCompleted,
      };
      final matchSearch = query.isEmpty || t.title.toLowerCase().contains(query);
      return matchFilter && matchSearch;
    }).toList();
  }

  Task? getById(String id) {
    for (final t in _tasks) {
      if (t.id == id) return t;
    }
    return null;
  }

  // ---------- Search & Filter ----------
  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setFilter(TaskFilter value) {
    _filter = value;
    notifyListeners();
  }

  // ---------- CRUD ----------
  void addTask({
    required String title,
    required String description,
    required String category,
    required DateTime deadline,
    required String priority,
  }) {
    _idCounter++;
    _tasks.insert(
      0,
      Task(
        id: _idCounter.toString(),
        title: title.trim(),
        description: description.trim(),
        category: category,
        deadline: deadline,
        priority: priority,
        isCompleted: false,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void updateTask(
      String id, {
        required String title,
        required String description,
        required String category,
        required DateTime deadline,
        required String priority,
      }) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(
      title: title.trim(),
      description: description.trim(),
      category: category,
      deadline: deadline,
      priority: priority,
    );
    notifyListeners();
  }

  void toggleCompleted(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _tasks[index] =
        _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}