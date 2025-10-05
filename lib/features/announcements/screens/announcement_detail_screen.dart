import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/announcement_model.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementDetailScreen({
    super.key,
    required this.announcement,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Announcement',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              context.go('/announcements');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: announcement.tagColor,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      announcement.tagText,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  
                  // Title
                  Text(
                    announcement.title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  
                  // Author and date
                  Row(
                    children: [
                      Text(
                        announcement.authorName,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Text(
                        announcement.formattedDate,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  
                  // View count
                  Row(
                    children: [
                      Icon(
                        Icons.visibility,
                        size: 16.0,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '${announcement.viewCount} views',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const Divider(),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                announcement.content,
                style: const TextStyle(
                  fontSize: 16.0,
                  height: 1.6,
                ),
              ),
            ),
            
            // Attachments
            if (announcement.hasAttachments) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attachments (${announcement.attachmentCount})',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    ...announcement.attachments.map((attachment) => _buildAttachmentItem(attachment)),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 32.0),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              context.go('/announcements');
            }
          },
          icon: const Icon(Icons.list),
          label: const Text('Back to List'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentItem(Attachment attachment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            attachment.fileIcon,
            color: attachment.fileColor,
            size: 24.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.name,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  attachment.formattedFileSize,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Implement download functionality
            },
            color: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }
} 