import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/services/service_locator.dart';
import '../../../shared/models/announcement_model.dart';
import 'announcement_detail_screen.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  List<Announcement> _announcements = [];
  List<Announcement> _filteredAnnouncements = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedTab = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _tabs = ['All', 'Games', 'Other'];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadAnnouncements();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _applyFilters();
    });
  }

  Future<void> _loadAnnouncements() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final announcementApiService = ServiceLocator.getAnnouncementApiService(context);
      final announcements = await announcementApiService.getAllAnnouncements();
      
      print('DEBUG: Loaded ${announcements.length} announcements');
      for (var announcement in announcements) {
        print('DEBUG: Announcement - ID: ${announcement.id}, Title: ${announcement.title}, Tag: ${announcement.tag}');
      }
      
      setState(() {
        _announcements = announcements;
        _filteredAnnouncements = announcements;
        _isLoading = false;
      });
      
      _applyFilters();
    } catch (e) {
      print('DEBUG: Error loading announcements: $e');
      
      // API 오류 시 테스트 데이터 사용
      final testAnnouncements = _getTestAnnouncements();
      print('DEBUG: Using test data with ${testAnnouncements.length} announcements');
      
      setState(() {
        _announcements = testAnnouncements;
        _filteredAnnouncements = testAnnouncements;
        _isLoading = false;
        _errorMessage = 'Using test data (API error: $e)';
      });
      
      _applyFilters();
    }
  }

  List<Announcement> _getTestAnnouncements() {
    return [
      Announcement(
        id: 1,
        title: 'Upcoming Championship Final',
        content: 'The championship final between Seoul High School and Busan High School will be held this Saturday at 3 PM.',
        tag: 'Games',
        authorId: 'admin1',
        authorName: 'Sports Admin',
        viewCount: 125,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Announcement(
        id: 2,
        title: 'Team Training Schedule Update',
        content: 'Due to weather conditions, tomorrow\'s training session has been moved indoors. Please arrive at the gymnasium by 4 PM.',
        tag: 'Games',
        authorId: 'coach1',
        authorName: 'Coach Kim',
        viewCount: 87,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      Announcement(
        id: 3,
        title: 'New Sports Equipment Arrival',
        content: 'New soccer balls and training equipment have arrived. Please see the equipment manager to check out items.',
        tag: 'Other',
        authorId: 'manager1',
        authorName: 'Equipment Manager',
        viewCount: 43,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      Announcement(
        id: 4,
        title: 'Sports App Update Available',
        content: 'A new version of the sports app is now available with improved features and bug fixes. Please update from your app store.',
        tag: 'Other',
        authorId: 'tech1',
        authorName: 'Tech Support',
        viewCount: 156,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Announcement(
        id: 5,
        title: 'Weekend Tournament Results',
        content: 'Congratulations to all teams that participated in the weekend tournament. Full results and statistics are now available.',
        tag: 'Games',
        authorId: 'admin1',
        authorName: 'Sports Admin',
        viewCount: 98,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Announcement(
        id: 6,
        title: 'Cafeteria Menu Changes',
        content: 'Starting next week, the school cafeteria will offer new healthy meal options for student athletes.',
        tag: 'Other',
        authorId: 'cafeteria1',
        authorName: 'Cafeteria Manager',
        viewCount: 67,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  void _applyFilters() {
    List<Announcement> filtered = _announcements;

    print('DEBUG: Apply filters - Selected tab: $_selectedTab, Total announcements: ${_announcements.length}');

    // 탭 필터 적용
    if (_selectedTab == 'Games') {
      filtered = filtered.where((announcement) => announcement.tag.toLowerCase() == 'games').toList();
      print('DEBUG: After Games filter: ${filtered.length} announcements');
    } else if (_selectedTab == 'Other') {
      filtered = filtered.where((announcement) => announcement.tag.toLowerCase() == 'other').toList();
      print('DEBUG: After Other filter: ${filtered.length} announcements');
    }

    // 검색 필터 적용
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((announcement) {
        final title = announcement.title.toLowerCase();
        final content = announcement.content.toLowerCase();
        final author = announcement.authorName.toLowerCase();
        
        return title.contains(_searchQuery) ||
               content.contains(_searchQuery) ||
               author.contains(_searchQuery);
      }).toList();
      print('DEBUG: After search filter: ${filtered.length} announcements');
    }

    print('DEBUG: Final filtered announcements: ${filtered.length}');
    setState(() {
      _filteredAnnouncements = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: GestureDetector(
          onTap: () => context.go('/home'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.accentColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.sportscourt_fill,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'FieldSync',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                  fontFamily: AppTheme.primaryFontFamily,
                ),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              context.go('/home');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadAnnouncements,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Row(
              children: List.generate(_tabs.length, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTab = _tabs[index];
                        _applyFilters();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        color: _selectedTab == _tabs[index]
                            ? AppTheme.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Center(
                        child: Text(
                          _tabs[index],
                          style: TextStyle(
                            color: _selectedTab == _tabs[index]
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search announcements',
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14.0),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                ],
              ),
            ),
          ),

          // Search Results Count
          if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  Text(
                    '${_filteredAnnouncements.length} results',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          
          // Announcements List
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show error message and test data warning if applicable
    Widget? headerWidget;
    if (_errorMessage != null && _errorMessage!.startsWith('Using test data')) {
      headerWidget = Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange.shade700, size: 20),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Using test data - API connection failed',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: _loadAnnouncements,
              child: const Text('Retry', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      );
    } else if (_errorMessage != null && _announcements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load announcements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAnnouncements,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredAnnouncements.isEmpty) {
      String message;
      IconData icon;
      
      if (_searchQuery.isNotEmpty) {
        message = 'No announcements found for "$_searchQuery"';
        icon = Icons.search_off;
      } else if (_selectedTab == 'Games') {
        message = 'No game-related announcements available';
        icon = Icons.sports_soccer;
      } else if (_selectedTab == 'Other') {
        message = 'No other announcements available';
        icon = Icons.info_outline;
      } else {
        message = 'No announcements available';
        icon = Icons.announcement;
      }
      
      return Column(
        children: [
          if (headerWidget != null) headerWidget,
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_searchQuery.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                      },
                      child: const Text('Reset Search'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        if (headerWidget != null) headerWidget,
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: _filteredAnnouncements.length,
            itemBuilder: (context, index) {
              final announcement = _filteredAnnouncements[index];
              return _buildAnnouncementItem(announcement);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnnouncementItem(Announcement announcement) {
    Color tagColor;
    switch (announcement.tag) {
      case 'Games':
        tagColor = Colors.green.shade100;
        break;
      case 'Other':
        tagColor = Colors.purple.shade100;
        break;
      default:
        tagColor = Colors.blue.shade100;
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnnouncementDetailScreen(
              announcement: announcement,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: tagColor,
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
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          announcement.title,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          announcement.content,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            Text(
                              announcement.authorName,
                              style: TextStyle(
                                fontSize: 11.0,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            if (announcement.hasAttachments) ...[
                              const SizedBox(width: 8.0),
                              Icon(
                                Icons.attach_file,
                                size: 12.0,
                                color: Colors.grey.shade500,
                              ),
                              Text(
                                '${announcement.attachmentCount}',
                                style: TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        announcement.formattedDate,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        '${announcement.viewCount} views',
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 