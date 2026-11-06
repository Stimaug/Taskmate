class Task {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime deadline;
  final String priority; // High, Medium, Low
  final bool isCompleted;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.deadline,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
  });

  Task copyWith({
    String? title,
    String? description,
    String? category,
    DateTime? deadline,
    String? priority,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}