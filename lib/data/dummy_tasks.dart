import '../models/task.dart';

const List<String> taskCategories = ['Kuliah', 'Praktikum', 'Organisasi', 'Pribadi'];
const List<String> taskPriorities = ['High', 'Medium', 'Low'];

List<Task> buildDummyTasks() {
  final now = DateTime.now();
  return [
    Task(
      id: '1',
      title: 'Membuat Laporan PBL',
      description: 'Susun laporan akhir proyek PBL.',
      category: 'Kuliah',
      deadline: now.add(const Duration(days: 3)),
      priority: 'High',
      isCompleted: false,
      createdAt: now.subtract(const Duration(days: 2)),
    ),
    Task(
      id: '2',
      title: 'Mengerjakan Tugas Flutter',
      description: 'Selesaikan aplikasi TaskMate untuk ATS praktikum.',
      category: 'Praktikum',
      deadline: now.add(const Duration(days: 2)),
      priority: 'High',
      isCompleted: false,
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    Task(
      id: '3',
      title: 'Membaca Materi Database',
      description: 'Pelajari bab normalisasi dan relasi antar tabel.',
      category: 'Kuliah',
      deadline: now.subtract(const Duration(days: 1)),
      priority: 'Medium',
      isCompleted: true,
      createdAt: now.subtract(const Duration(days: 5)),
    ),
    Task(
      id: '4',
      title: 'Membuat Presentasi',
      description: 'Siapkan slide presentasi kegiatan organisasi.',
      category: 'Organisasi',
      deadline: now.add(const Duration(days: 7)),
      priority: 'Low',
      isCompleted: false,
      createdAt: now.subtract(const Duration(days: 3)),
    ),
  ];
}