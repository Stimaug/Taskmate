import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/dummy_tasks.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';

class TaskFormScreen extends StatefulWidget {
  /// null = mode tambah, terisi = mode edit
  final String? taskId;

  const TaskFormScreen({super.key, this.taskId});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String? _category;
  DateTime? _deadline;
  String? _priority = 'High'; // default sesuai wireframe

  // Dipakai untuk menampilkan error deadline & prioritas
  String? _deadlineError;
  String? _priorityError;

  bool get _isEdit => widget.taskId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final Task? task = context.read<TaskProvider>().getById(widget.taskId!);
      if (task != null) {
        _titleController.text = task.title;
        _descController.text = task.description;
        _category = task.category;
        _deadline = task.deadline;
        _priority = task.priority;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _deadline = picked;
        _deadlineError = null;
      });
    }
  }

  void _save() {
    FocusScope.of(context).unfocus();

    final formValid = _formKey.currentState!.validate();
    final deadlineError = Validators.deadline(_deadline);
    final priorityError = Validators.priority(_priority);

    setState(() {
      _deadlineError = deadlineError;
      _priorityError = priorityError;
    });

    if (!formValid || deadlineError != null || priorityError != null) return;

    final provider = context.read<TaskProvider>();
    if (_isEdit) {
      provider.updateTask(
        widget.taskId!,
        title: _titleController.text,
        description: _descController.text,
        category: _category!,
        deadline: _deadline!,
        priority: _priority!,
      );
    } else {
      provider.addTask(
        title: _titleController.text,
        description: _descController.text,
        category: _category!,
        deadline: _deadline!,
        priority: _priority!,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEdit ? 'Task berhasil diperbarui.' : 'Task berhasil ditambahkan.',
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Task' : 'Tambah Task',
            style: textTheme.titleLarge),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---------- Nama tugas ----------
                      Text('Nama Tugas', style: textTheme.titleMedium),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            hintText: 'Contoh: Laporan PBL'),
                        validator: Validators.taskTitle,
                      ),
                      const SizedBox(height: 16),

                      // ---------- Deskripsi ----------
                      Text('Deskripsi', style: textTheme.titleMedium),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                            hintText: 'Tulis deskripsi tugas'),
                      ),
                      const SizedBox(height: 16),

                      // ---------- Kategori ----------
                      Text('Kategori', style: textTheme.titleMedium),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _category,
                        hint: const Text('Pilih kategori'),
                        items: taskCategories
                            .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (value) => setState(() => _category = value),
                        validator: Validators.category,
                      ),
                      const SizedBox(height: 16),

                      // ---------- Deadline ----------
                      Text('Deadline', style: textTheme.titleMedium),
                      const SizedBox(height: 8),
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            errorText: _deadlineError,
                            suffixIcon:
                            const Icon(Icons.calendar_today_outlined),
                          ),
                          child: Text(
                            _deadline == null
                                ? 'Pilih tanggal (date picker)'
                                : DateFormat('dd/MM/yyyy').format(_deadline!),
                            style: TextStyle(
                              color: _deadline == null
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ---------- Prioritas ----------
                      Text('Prioritas', style: textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: taskPriorities.map((p) {
                          final selected = _priority == p;
                          return ChoiceChip(
                            label: Text(p),
                            selected: selected,
                            showCheckmark: false,
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.card,
                            side: BorderSide(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                            onSelected: (_) => setState(() {
                              _priority = p;
                              _priorityError = null;
                            }),
                          );
                        }).toList(),
                      ),
                      if (_priorityError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            _priorityError!,
                            style: const TextStyle(
                                color: AppColors.danger, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // ---------- Tombol simpan ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: ElevatedButton(
                onPressed: _save,
                child: Text(_isEdit ? 'Simpan Perubahan' : 'Save Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}