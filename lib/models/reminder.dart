class Reminder {
  final String id;
  final String title;
  final String description;
  final String weather;
  final DateTime date;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.weather,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'weather': weather,
      'date': date.toIso8601String(),
    };
  }

  factory Reminder.fromMap(String id, Map<String, dynamic> map) {
    return Reminder(
      id: id,
      title: map['title'],
      description: map['description'],
      weather: map['weather'],
      date: DateTime.parse(map['date']),
    );
  }
}