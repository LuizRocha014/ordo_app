import '../../domain/entities/timeline_event.dart';

class TimelineEventModel extends TimelineEvent {
  const TimelineEventModel({
    required super.id,
    required super.when,
    required super.description,
    required super.author,
    super.accent,
  });

  factory TimelineEventModel.fromJson(Map<String, dynamic> json) =>
      TimelineEventModel(
        id: json['id'] as String,
        when: DateTime.parse(json['when'] as String),
        description: json['description'] as String,
        author: json['author'] as String,
        accent: json['accent'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'when': when.toIso8601String(),
        'description': description,
        'author': author,
        'accent': accent,
      };
}
