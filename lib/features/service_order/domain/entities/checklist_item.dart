class ChecklistItem {
  final String id;
  final String label;
  final bool done;
  final int photoCount;

  const ChecklistItem({
    required this.id,
    required this.label,
    this.done = false,
    this.photoCount = 0,
  });

  ChecklistItem copyWith({
    bool? done,
    int? photoCount,
  }) {
    return ChecklistItem(
      id: id,
      label: label,
      done: done ?? this.done,
      photoCount: photoCount ?? this.photoCount,
    );
  }
}
