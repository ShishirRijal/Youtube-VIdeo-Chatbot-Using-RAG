class VideoInfo {
  final String id;
  final String title;
  final String? thumbnailUrl;
  final DateTime indexedAt;
  final bool isIndexed;

  VideoInfo({
    required this.id,
    required this.title,
    this.thumbnailUrl,
    required this.indexedAt,
    required this.isIndexed,
  });

  // Default thumbnail URL based on video ID
  String get defaultThumbnailUrl =>
      'https://img.youtube.com/vi/$id/hqdefault.jpg';

  // For serializing to JSON for saving in preferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnailUrl': thumbnailUrl ?? defaultThumbnailUrl,
      'indexedAt': indexedAt.millisecondsSinceEpoch,
      'isIndexed': isIndexed,
    };
  }

  // For deserializing from JSON when loading from preferences
  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
      indexedAt: DateTime.fromMillisecondsSinceEpoch(json['indexedAt']),
      isIndexed: json['isIndexed'] ?? false,
    );
  }

  // Create a basic VideoInfo object from just an ID
  factory VideoInfo.fromId(String id) {
    return VideoInfo(
      id: id,
      title: 'YouTube Video $id',
      indexedAt: DateTime.now(),
      isIndexed: false,
    );
  }
}
