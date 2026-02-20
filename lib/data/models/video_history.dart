// // models/video_history.dart
// class VideoHistory {
//   final int? id;
//   final String videoPath;
//   final String? thumbnailPath;
//   final String? imagePath;
//   final DateTime createdAt;
//   final String title;
//
//   VideoHistory({
//     this.id,
//     required this.videoPath,
//     this.thumbnailPath,
//     this.imagePath,
//     required this.createdAt,
//     required this.title,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'videoPath': videoPath,
//       'thumbnailPath': thumbnailPath,
//       'imagePath': imagePath,
//       'createdAt': createdAt.millisecondsSinceEpoch,
//       'title': title,
//     };
//   }
//
//   factory VideoHistory.fromMap(Map<String, dynamic> map) {
//     return VideoHistory(
//       id: map['id'],
//       videoPath: map['videoPath'],
//       thumbnailPath: map['thumbnailPath'],
//       imagePath: map['imagePath'],
//       createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
//       title: map['title'],
//     );
//   }
//
//   VideoHistory copyWith({
//     int? id,
//     String? videoPath,
//     String? thumbnailPath,
//     String? imagePath,
//     DateTime? createdAt,
//     String? title,
//   }) {
//     return VideoHistory(
//       id: id ?? this.id,
//       videoPath: videoPath ?? this.videoPath,
//       thumbnailPath: thumbnailPath ?? this.thumbnailPath,
//       imagePath: imagePath ?? this.imagePath,
//       createdAt: createdAt ?? this.createdAt,
//       title: title ?? this.title,
//     );
//   }
// }