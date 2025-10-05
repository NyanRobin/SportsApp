import 'package:flutter/material.dart';

class Announcement {
  final int id;
  final String title;
  final String content;
  final String tag;
  final String authorId;
  final String authorName;
  final int viewCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Attachment> attachments;
  
  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.tag,
    required this.authorId,
    required this.authorName,
    required this.viewCount,
    required this.createdAt,
    required this.updatedAt,
    this.attachments = const [],
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      tag: json['tag'] ?? '',
      authorId: json['author_id'] ?? '',
      authorName: json['author_name'] ?? '',
      viewCount: json['view_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
              .map((attachment) => Attachment.fromJson(attachment))
              .toList()
          : [],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'tag': tag,
      'author_id': authorId,
      'author_name': authorName,
      'view_count': viewCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'attachments': attachments.map((attachment) => attachment.toJson()).toList(),
    };
  }

  // 태그 색상 반환
  Color get tagColor {
    switch (tag.toLowerCase()) {
      case 'games':
        return Colors.green.shade100;
      case 'other':
        return Colors.purple.shade100;
      default:
        return Colors.blue.shade100;
    }
  }
  
  // 태그 텍스트
  String get tagText {
    switch (tag.toLowerCase()) {
      case 'games':
        return 'Games';
      case 'other':
        return 'Other';
      default:
        return 'All';
    }
  }

  // 날짜 포맷팅
  String get formattedDate {
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
  }

  // 시간 포맷팅
  String get formattedTime {
    return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  // 오늘 작성된 공지사항인지 확인
  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
           createdAt.month == now.month &&
           createdAt.day == now.day;
  }

  // 첨부파일이 있는지 확인
  bool get hasAttachments => attachments.isNotEmpty;

  // 첨부파일 개수
  int get attachmentCount => attachments.length;
}

class Attachment {
  final int id;
  final String name;
  final String originalName;
  final String filePath;
  final String fileType;
  final int fileSize;
  final DateTime createdAt;

  Attachment({
    required this.id,
    required this.name,
    required this.originalName,
    required this.filePath,
    required this.fileType,
    required this.fileSize,
    required this.createdAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      originalName: json['original_name'] ?? '',
      filePath: json['file_path'] ?? '',
      fileType: json['file_type'] ?? '',
      fileSize: json['file_size'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'original_name': originalName,
      'file_path': filePath,
      'file_type': fileType,
      'file_size': fileSize,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // 파일 크기 포맷팅
  String get formattedFileSize {
    if (fileSize < 1024) {
      return '${fileSize}B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }
  
  // 파일 타입에 따른 아이콘
  IconData get fileIcon {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.video_file;
      default:
        return Icons.attach_file;
    }
  }

  // 파일 타입에 따른 색상
  Color get fileColor {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Colors.purple;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
