class TimelineEvent {
  final String id;
  final DateTime when;
  final String description;
  final String author;
  final bool accent;

  const TimelineEvent({
    required this.id,
    required this.when,
    required this.description,
    required this.author,
    this.accent = false,
  });
}
