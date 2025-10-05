import '../../shared/models/announcement_model.dart';
import 'api_service.dart';

class AnnouncementApiService {
  final ApiService _apiService;

  AnnouncementApiService(this._apiService);

  // 모든 공지사항 가져오기
  Future<List<Announcement>> getAllAnnouncements({
    String? tag,
    String? search,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (tag != null) queryParams['tag'] = tag;
      if (search != null) queryParams['search'] = search;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _apiService.get('/announcements', queryParameters: queryParams);
      
      if (response['announcements'] != null) {
        final List<dynamic> announcementsJson = response['announcements'];
        return announcementsJson.map((json) => Announcement.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('Failed to get announcements from API, using mock data: $e');
      return _getMockAnnouncements(tag: tag, limit: limit);
    }
  }

  // 특정 공지사항 가져오기
  Future<Announcement?> getAnnouncementById(int announcementId) async {
    try {
      final response = await _apiService.get('/announcements/$announcementId');
      
      if (response['announcement'] != null) {
        return Announcement.fromJson(response['announcement']);
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to get announcement: $e');
    }
  }

  // 공지사항 생성
  Future<Announcement> createAnnouncement(Map<String, dynamic> announcementData) async {
    try {
      final response = await _apiService.post('/announcements', data: announcementData);
      
      if (response['announcement'] != null) {
        return Announcement.fromJson(response['announcement']);
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to create announcement: $e');
    }
  }

  // 공지사항 업데이트
  Future<Announcement> updateAnnouncement(int announcementId, Map<String, dynamic> announcementData) async {
    try {
      final response = await _apiService.put('/announcements/$announcementId', data: announcementData);
      
      if (response['announcement'] != null) {
        return Announcement.fromJson(response['announcement']);
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to update announcement: $e');
    }
  }

  // 공지사항 삭제
  Future<void> deleteAnnouncement(int announcementId) async {
    try {
      await _apiService.delete('/announcements/$announcementId');
    } catch (e) {
      throw Exception('Failed to delete announcement: $e');
    }
  }

  // 조회수 증가
  Future<void> incrementViewCount(int announcementId) async {
    try {
      await _apiService.put('/announcements/$announcementId/view', data: {});
    } catch (e) {
      throw Exception('Failed to increment view count: $e');
    }
  }

  // 첨부파일 가져오기
  Future<List<Attachment>> getAttachments(int announcementId) async {
    try {
      final response = await _apiService.get('/announcements/$announcementId/attachments');
      
      if (response['attachments'] != null) {
        final List<dynamic> attachmentsJson = response['attachments'];
        return attachmentsJson.map((json) => Attachment.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to get attachments: $e');
    }
  }

  // 첨부파일 추가
  Future<Attachment> addAttachment(int announcementId, String filePath, String fileName) async {
    try {
      final response = await _apiService.uploadFile(
        '/announcements/$announcementId/attachments',
        filePath,
        'file',
      );
      
      if (response['attachment'] != null) {
        return Attachment.fromJson(response['attachment']);
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to add attachment: $e');
    }
  }

  // 첨부파일 삭제
  Future<void> deleteAttachment(int announcementId, int attachmentId) async {
    try {
      await _apiService.delete('/announcements/$announcementId/attachments/$attachmentId');
    } catch (e) {
      throw Exception('Failed to delete attachment: $e');
    }
  }

  // 태그별 공지사항 가져오기
  Future<List<Announcement>> getAnnouncementsByTag(String tag) async {
    try {
      return await getAllAnnouncements(tag: tag);
    } catch (e) {
      throw Exception('Failed to get announcements by tag: $e');
    }
  }

  // 검색어로 공지사항 검색
  Future<List<Announcement>> searchAnnouncements(String searchTerm) async {
    try {
      return await getAllAnnouncements(search: searchTerm);
    } catch (e) {
      throw Exception('Failed to search announcements: $e');
    }
  }

  // 최근 공지사항 가져오기
  Future<List<Announcement>> getRecentAnnouncements({int limit = 10}) async {
    try {
      return await getAllAnnouncements(limit: limit);
    } catch (e) {
      throw Exception('Failed to get recent announcements: $e');
    }
  }

  // 중요 공지사항 가져오기
  Future<List<Announcement>> getImportantAnnouncements() async {
    try {
      final response = await _apiService.get('/announcements/important');
      
      if (response['announcements'] != null) {
        final List<dynamic> announcementsJson = response['announcements'];
        return announcementsJson.map((json) => Announcement.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('Failed to get important announcements from API, using mock data: $e');
      return _getMockAnnouncements().where((a) => a.tag == 'Important').toList();
    }
  }

  // Mock 공지사항 데이터 생성
  List<Announcement> _getMockAnnouncements({String? tag, int? limit}) {
    final mockAnnouncements = [
      Announcement(
        id: 1,
        title: '이번 주 훈련 일정 변경',
        content: '안녕하세요. 이번 주 훈련 일정이 변경되었습니다. 화요일 훈련은 오후 4시로 변경되며, 목요일은 휴식일로 변경됩니다. 모든 선수들은 새로운 일정을 확인해 주세요.',
        authorId: 'coach1',
        authorName: '코치',
        tag: 'Important',
        viewCount: 45,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        attachments: [],
      ),
      Announcement(
        id: 2,
        title: '다음 경기 상대팀 분석 자료',
        content: '다음 주 강북고등학교와의 경기를 위한 상대팀 분석 자료를 공유합니다. 상대팀의 주요 전술과 핵심 선수들에 대한 정보를 포함하고 있습니다.',
        authorId: 'analyst1',
        authorName: '분석팀',
        tag: 'Games',
        viewCount: 32,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
        attachments: [],
      ),
      Announcement(
        id: 3,
        title: '팀 저녁 식사 모임 안내',
        content: '이번 토요일 저녁 7시에 팀 전체 저녁 식사 모임이 있습니다. 장소는 학교 근처 한식당이며, 참석 여부를 코치에게 알려주세요.',
        authorId: 'captain1',
        authorName: '팀장',
        tag: 'Other',
        viewCount: 28,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        attachments: [],
      ),
      Announcement(
        id: 4,
        title: '새로운 유니폼 배급',
        content: '2025 시즌 새로운 유니폼이 도착했습니다. 내일부터 개인별로 수령 가능하며, 사이즈 확인 후 배급 예정입니다.',
        authorId: 'equipment1',
        authorName: '장비담당',
        tag: 'Other',
        viewCount: 18,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        attachments: [],
      ),
      Announcement(
        id: 5,
        title: '의료진 검진 일정',
        content: '선수들의 건강 관리를 위한 정기 의료진 검진이 다음 주 월요일에 예정되어 있습니다. 모든 선수는 필수 참석입니다.',
        authorId: 'medical1',
        authorName: '의무팀',
        tag: 'Important',
        viewCount: 52,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        attachments: [],
      ),
      Announcement(
        id: 6,
        title: '겨울 훈련 캠프 안내',
        content: '겨울 방학 기간 중 특별 훈련 캠프를 개최합니다. 기간은 1월 15일부터 25일까지이며, 참가 신청서를 제출해 주세요.',
        authorId: 'coach1',
        authorName: '코치',
        tag: 'Training',
        viewCount: 35,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        attachments: [],
      ),
    ];

    var filteredAnnouncements = mockAnnouncements;

    // 태그 필터링
    if (tag != null && tag != 'All') {
      filteredAnnouncements = filteredAnnouncements
          .where((announcement) => announcement.tag.toLowerCase() == tag.toLowerCase())
          .toList();
    }

    // 제한 적용
    if (limit != null) {
      filteredAnnouncements = filteredAnnouncements.take(limit).toList();
    }

    return filteredAnnouncements;
  }
} 