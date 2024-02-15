import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Review {
  const Review(
    this.id,
    this.title,
    this.createdByEmail,
    this.topic,
    this.duration,
    this.dramatics,
    this.emotionalImpact,
    this.aftermath,
    this.notes,
    this.createdAt,
  );

  final String id;
  final String title;
  final String createdByEmail;
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
      data['title'] as String,
      data['createdByEmail'] as String,
      data['topic'] as int,
      data['duration'] as int,
      data['dramatics'] as int,
      data['emotionalImpact'] as int,
      data['aftermath'] as int,
      data['notes'] as String,
      DateTime.parse(data['createdAt'] as String),
    );
  }

  factory Review.empty() =>
      Review('', '', '', 0, 0, 0, 0, 0, '', DateTime.now());

  double get average {
    final total = topic + duration + dramatics + emotionalImpact + aftermath;
    return (total / 5);
  }

  String get createdAtFormatted {
    final now = DateTime.now();

    if (createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day) {
      return 'Today at ${DateFormat.jm().format(createdAt.toLocal())}';
    }

    return DateFormat.yMMMd().format(createdAt.toLocal());
  }

  Map<String, dynamic> toFirestoreObject() {
    return {
      'title': title,
      'createdByEmail': createdByEmail,
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
    String? title,
    String? createdByEmail,
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
      title ?? this.title,
      createdByEmail ?? this.createdByEmail,
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
        other.title == title &&
        other.createdByEmail == createdByEmail &&
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
        title.hashCode ^
        createdByEmail.hashCode ^
        topic.hashCode ^
        duration.hashCode ^
        dramatics.hashCode ^
        emotionalImpact.hashCode ^
        aftermath.hashCode ^
        notes.hashCode ^
        createdAt.hashCode;
  }
}
