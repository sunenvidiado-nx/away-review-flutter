import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  const Review(
    this.id,
    this.createdBy,
    this.topic,
    this.duration,
    this.dramatics,
    this.emotionalImpact,
    this.aftermath,
    this.notes,
    this.createdAt,
  );

  final String id;
  final String createdBy;
  final int topic;
  final int duration;
  final int dramatics;
  final int emotionalImpact;
  final int aftermath;
  final String notes;
  final DateTime createdAt;

  factory Review.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return Review(
      doc.id,
      data['createdBy'] as String,
      data['topic'] as int,
      data['duration'] as int,
      data['dramatics'] as int,
      data['emotionalImpact'] as int,
      data['aftermath'] as int,
      data['notes'] as String,
      DateTime.parse(data['createdAt'] as String),
    );
  }

  factory Review.empty() => Review('', '', 0, 0, 0, 0, 0, '', DateTime.now());

  Map<String, dynamic> toFirestoreObject() {
    return {
      'createdBy': createdBy,
      'topic': topic,
      'duration': duration,
      'dramatics': dramatics,
      'emotionalImpact': emotionalImpact,
      'aftermath': aftermath,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Review copyWith({
    String? id,
    String? createdBy,
    int? topic,
    int? duration,
    int? dramatics,
    int? emotionalImpact,
    int? aftermath,
    String? notes,
    DateTime? createdAt,
  }) {
    return Review(
      id ?? this.id,
      createdBy ?? this.createdBy,
      topic ?? this.topic,
      duration ?? this.duration,
      dramatics ?? this.dramatics,
      emotionalImpact ?? this.emotionalImpact,
      aftermath ?? this.aftermath,
      notes ?? this.notes,
      createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Review &&
        other.id == id &&
        other.createdBy == createdBy &&
        other.topic == topic &&
        other.duration == duration &&
        other.dramatics == dramatics &&
        other.emotionalImpact == emotionalImpact &&
        other.aftermath == aftermath &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdBy.hashCode ^
        topic.hashCode ^
        duration.hashCode ^
        dramatics.hashCode ^
        emotionalImpact.hashCode ^
        aftermath.hashCode ^
        notes.hashCode ^
        createdAt.hashCode;
  }
}
