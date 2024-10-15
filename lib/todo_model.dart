class TodoModel {
  final DateTime time;
  final String title;
  final String description;
  const TodoModel({
    required this.time,
    required this.title,
    required this.description, required String des,
  });

  toJSON() {
    return {
      "time": time.toString(),
      "title": title,
      "description": description
    };
  }
}
