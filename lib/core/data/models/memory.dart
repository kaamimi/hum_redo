class Memory {
  final String id;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Primary content
  final String? note;
  final String? imageUrl;
  final String? voiceNoteUrl;

  // Additional metadata
  final String? audioUrl;
  final String? audioSource; // e.g. 'spotify', 'youtube','apple_music' ,'local'
  final dynamic doodle;

  // Organizational attribute
  final List<String>? tags;

  Memory({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.note,
    this.imageUrl,
    this.voiceNoteUrl,
    this.audioUrl,
    this.audioSource,
    this.doodle,
    this.tags,
  });

  // Create a copy with modified fields
  Memory copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? note,
    String? imageUrl,
    String? voiceNoteUrl,
    String? audioUrl,
    String? audioSource,
    dynamic doodle,
    List<String>? tags,
  }) {
    return Memory(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      note: note ?? this.note,
      imageUrl: imageUrl ?? this.imageUrl,
      voiceNoteUrl: voiceNoteUrl ?? this.voiceNoteUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      audioSource: audioSource ?? this.audioSource,
      doodle: doodle ?? this.doodle,
      tags: tags ?? this.tags,
    );
  }

  // Convert to JSON for storage/API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'note': note,
      'imageUrl': imageUrl,
      'voiceNoteUrl': voiceNoteUrl,
      'audioUrl': audioUrl,
      'audioSource': audioSource,
      'doodle': doodle,
      'tags': tags,
    };
  }

  // Create from JSON
  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      note: json['note'] as String?,
      imageUrl: json['imageUrl'] as String?,
      voiceNoteUrl: json['voiceNoteUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      audioSource: json['audioSource'] as String?,
      doodle: json['doodle'],
      tags: (json['tags'] as List?)?.cast<String>(),
    );
  }

  @override
  String toString() => 'Memory(id: $id, createdAt: $createdAt, note: $note)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Memory &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          createdAt == other.createdAt;

  @override
  int get hashCode => id.hashCode ^ createdAt.hashCode;
}
