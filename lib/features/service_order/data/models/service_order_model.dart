import '../../domain/entities/os_status.dart';
import '../../domain/entities/service_order.dart';
import 'checklist_item_model.dart';
import 'client_model.dart';
import 'timeline_event_model.dart';

class ServiceOrderModel extends ServiceOrder {
  const ServiceOrderModel({
    required super.id,
    required super.title,
    required super.category,
    required super.client,
    required super.problem,
    required super.status,
    required super.valueCents,
    required super.openedAt,
    required super.updatedAt,
    super.checklist,
    super.timeline,
    super.photoIds,
  });

  factory ServiceOrderModel.fromJson(Map<String, dynamic> json) {
    return ServiceOrderModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      client: ClientModel.fromJson(json['client'] as Map<String, dynamic>),
      problem: json['problem'] as String,
      status: OsStatus.fromId(json['status'] as String),
      valueCents: json['valueCents'] as int,
      openedAt: DateTime.parse(json['openedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      checklist: (json['checklist'] as List<dynamic>? ?? [])
          .map((e) => ChecklistItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      timeline: (json['timeline'] as List<dynamic>? ?? [])
          .map((e) => TimelineEventModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      photoIds:
          (json['photoIds'] as List<dynamic>? ?? []).cast<String>().toList(),
    );
  }

  factory ServiceOrderModel.fromEntity(ServiceOrder o) => ServiceOrderModel(
        id: o.id,
        title: o.title,
        category: o.category,
        client: ClientModel.fromEntity(o.client),
        problem: o.problem,
        status: o.status,
        valueCents: o.valueCents,
        openedAt: o.openedAt,
        updatedAt: o.updatedAt,
        checklist: o.checklist,
        timeline: o.timeline,
        photoIds: o.photoIds,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'client': ClientModel.fromEntity(client).toJson(),
        'problem': problem,
        'status': status.id,
        'valueCents': valueCents,
        'openedAt': openedAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'checklist': checklist
            .map((e) => ChecklistItemModel.fromEntity(e).toJson())
            .toList(),
        'timeline': timeline
            .map((e) => TimelineEventModel(
                  id: e.id,
                  when: e.when,
                  description: e.description,
                  author: e.author,
                  accent: e.accent,
                ).toJson())
            .toList(),
        'photoIds': photoIds,
      };
}
