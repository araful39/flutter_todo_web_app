class Todo {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] ?? json['_id'] ?? json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}