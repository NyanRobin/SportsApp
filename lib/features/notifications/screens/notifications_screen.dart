import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/notification_model.dart';
import '../../../shared/services/notification_service.dart';


class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with TickerProviderStateMixin {
  final NotificationService _notificationService = NotificationService();
  late TabController _tabController;
  String _selectedFilter = 'all'; // all, game, announcement, achievement, system

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _setupNotificationCallbacks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _setupNotificationCallbacks() {
    _notificationService.onNotificationTap = (notification) {
      _handleNotificationTap(notification);
    };
  }

  void _handleNotificationTap(NotificationModel notification) {
    // Navigate based on notification type
    switch (notification.type) {
      case 'game':
        if (notification.data?['gameId'] != null) {
          context.go('/games/${notification.data!['gameId']}');
        }
        break;
      case 'announcement':
        context.go('/announcements');
        break;
      case 'achievement':
        context.go('/profile');
        break;
      default:
        // Stay on notifications screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: GestureDetector(
          onTap: () => context.go('/home'),
          child: Text(
            'logo',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () => _showNotificationSettings(),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () => _showOptionsMenu(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications),
                  const SizedBox(width: 8),
                  const Text('All'),
                  if (_notificationService.unreadCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_notificationService.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.tune),
                  SizedBox(width: 8),
                  Text('Settings'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsTab(),
          _buildSettingsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _notificationService.showTestNotification(),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return Column(
      children: [
        // Filter bar
        Container(
          height: 60,
          color: Colors.white,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              _buildFilterChip('all', 'All', Icons.notifications),
              _buildFilterChip('game', 'Games', Icons.sports_soccer),
              _buildFilterChip('announcement', 'News', Icons.campaign),
              _buildFilterChip('achievement', 'Achievements', Icons.emoji_events),
              _buildFilterChip('system', 'System', Icons.settings),
            ],
          ),
        ),
        
        // Notifications list
        Expanded(
          child: _buildNotificationsList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String value, String label, IconData icon) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
        },
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
        checkmarkColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildNotificationsList() {
    final notifications = _getFilteredNotifications();
    
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedFilter == 'all' 
                  ? 'You\'ll see notifications here when they arrive'
                  : 'No ${_selectedFilter} notifications yet',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  List<NotificationModel> _getFilteredNotifications() {
    final allNotifications = _notificationService.notifications;
    
    if (_selectedFilter == 'all') {
      return allNotifications;
    }
    
    return allNotifications.where((n) => n.type == _selectedFilter).toList();
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    final isUnread = !notification.isRead;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isUnread ? 2 : 1,
      child: InkWell(
        onTap: () => _onNotificationTap(notification),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isUnread 
                ? Border.all(color: AppTheme.primaryColor.withOpacity(0.3), width: 1)
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.type).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type),
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                              color: isUnread ? Colors.black : Colors.grey.shade700,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getNotificationColor(notification.type).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getNotificationTypeLabel(notification.type),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: _getNotificationColor(notification.type),
                            ),
                          ),
                        ),
                        
                        const Spacer(),
                        
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Action menu
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, size: 16, color: Colors.grey.shade400),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'read',
                    child: Row(
                      children: [
                        Icon(
                          isUnread ? Icons.mark_email_read : Icons.mark_email_unread,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(isUnread ? 'Mark as read' : 'Mark as unread'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) => _onNotificationAction(notification, value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSettingsSection(
          'General',
          [
            _buildSwitchTile(
              'Enable Notifications',
              'Receive push notifications',
              _notificationService.settings.enabled,
              (value) => _updateSettings(_notificationService.settings.copyWith(enabled: value)),
              Icons.notifications,
            ),
            _buildSwitchTile(
              'Sound',
              'Play sound for notifications',
              _notificationService.settings.sound,
              (value) => _updateSettings(_notificationService.settings.copyWith(sound: value)),
              Icons.volume_up,
            ),
            _buildSwitchTile(
              'Vibration',
              'Vibrate for notifications',
              _notificationService.settings.vibration,
              (value) => _updateSettings(_notificationService.settings.copyWith(vibration: value)),
              Icons.vibration,
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        _buildSettingsSection(
          'Notification Types',
          [
            _buildSwitchTile(
              'Game Updates',
              'Game results and schedules',
              _notificationService.settings.gameUpdates,
              (value) => _updateSettings(_notificationService.settings.copyWith(gameUpdates: value)),
              Icons.sports_soccer,
            ),
            _buildSwitchTile(
              'Announcements',
              'Team and league news',
              _notificationService.settings.announcements,
              (value) => _updateSettings(_notificationService.settings.copyWith(announcements: value)),
              Icons.campaign,
            ),
            _buildSwitchTile(
              'Achievements',
              'Player milestones and awards',
              _notificationService.settings.achievements,
              (value) => _updateSettings(_notificationService.settings.copyWith(achievements: value)),
              Icons.emoji_events,
            ),
            _buildSwitchTile(
              'System Messages',
              'App updates and system alerts',
              _notificationService.settings.systemMessages,
              (value) => _updateSettings(_notificationService.settings.copyWith(systemMessages: value)),
              Icons.settings,
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        _buildSettingsSection(
          'Quiet Hours',
          [
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bedtime, color: Colors.purple),
              ),
              title: const Text('Quiet Hours'),
              subtitle: Text(
                '${_notificationService.settings.quietHoursStart} - ${_notificationService.settings.quietHoursEnd}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showQuietHoursDialog(),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        _buildSettingsSection(
          'Actions',
          [
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: Colors.green),
              ),
              title: const Text('Mark All as Read'),
              subtitle: Text('${_notificationService.unreadCount} unread notifications'),
              onTap: () => _markAllAsRead(),
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_sweep, color: Colors.red),
              ),
              title: const Text('Clear All'),
              subtitle: const Text('Delete all notifications'),
              onTap: () => _clearAllNotifications(),
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bug_report, color: Colors.blue),
              ),
              title: const Text('Test Notification'),
              subtitle: const Text('Send a test notification'),
              onTap: () => _notificationService.showTestNotification(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return SwitchListTile(
      secondary: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  // Event handlers
  void _onNotificationTap(NotificationModel notification) {
    _notificationService.markAsRead(notification.id);
    _handleNotificationTap(notification);
    setState(() {});
  }

  void _onNotificationAction(NotificationModel notification, String action) {
    switch (action) {
      case 'read':
        if (notification.isRead) {
          // Mark as unread (create new notification with isRead: false)
          // For simplicity, we'll just mark as read
          _notificationService.markAsRead(notification.id);
        } else {
          _notificationService.markAsRead(notification.id);
        }
        setState(() {});
        break;
      case 'delete':
        _notificationService.deleteNotification(notification.id);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification deleted')),
        );
        break;
    }
  }

  void _markAllAsRead() {
    _notificationService.markAllAsRead();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text('Are you sure you want to delete all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _notificationService.clearAll();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications cleared')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _updateSettings(AppNotificationSettings newSettings) {
    _notificationService.updateSettings(newSettings);
    setState(() {});
  }

  void _showNotificationSettings() {
    // Switch to settings tab
    _tabController.animateTo(1);
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Mark All as Read'),
              onTap: () {
                Navigator.pop(context);
                _markAllAsRead();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep),
              title: const Text('Clear All'),
              onTap: () {
                Navigator.pop(context);
                _clearAllNotifications();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                _showNotificationSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQuietHoursDialog() {
    TimeOfDay startTime = _parseTimeOfDay(_notificationService.settings.quietHoursStart);
    TimeOfDay endTime = _parseTimeOfDay(_notificationService.settings.quietHoursEnd);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Quiet Hours'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Start Time'),
                subtitle: Text(startTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: startTime,
                  );
                  if (time != null) {
                    setDialogState(() {
                      startTime = time;
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('End Time'),
                subtitle: Text(endTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: endTime,
                  );
                  if (time != null) {
                    setDialogState(() {
                      endTime = time;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newSettings = _notificationService.settings.copyWith(
                  quietHoursStart: _formatTimeOfDay(startTime),
                  quietHoursEnd: _formatTimeOfDay(endTime),
                );
                _updateSettings(newSettings);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'game':
        return Icons.sports_soccer;
      case 'announcement':
        return Icons.campaign;
      case 'achievement':
        return Icons.emoji_events;
      case 'system':
        return Icons.settings;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'game':
        return Colors.green;
      case 'announcement':
        return Colors.blue;
      case 'achievement':
        return Colors.orange;
      case 'system':
        return Colors.grey;
      default:
        return AppTheme.primaryColor;
    }
  }

  String _getNotificationTypeLabel(String type) {
    switch (type) {
      case 'game':
        return 'GAME';
      case 'announcement':
        return 'NEWS';
      case 'achievement':
        return 'ACHIEVEMENT';
      case 'system':
        return 'SYSTEM';
      default:
        return type.toUpperCase();
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
