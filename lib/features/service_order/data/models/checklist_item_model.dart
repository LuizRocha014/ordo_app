import '../../domain/entities/checklist_item.dart';

class ChecklistItemModel extends ChecklistItem {
  const ChecklistItemModel({
    required super.id,
    required super.label,
    super.done,
    super.photoCount,
  });

  factory ChecklistItemModel.fromJson(Map<String, dynamic> json) =>
      ChecklistItemModel(
        id: json['id'] as String,
        label: json['label'] as String,
        done: json['done'] as bool? ?? false,
        photoCount: json['photoCount'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'done': done,
        'photoCount': photoCount,
      };

  factory ChecklistItemModel.fromEntity(ChecklistItem c) => ChecklistItemModel(
        id: c.id,
        label: c.label,
        done: c.done,
        photoCount: c.photoCount,
      );
}
