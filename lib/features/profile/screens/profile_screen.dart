import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/services/service_locator.dart';
import '../../../shared/models/user_model.dart';
import '../../../core/network/user_profile_api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  bool _isLoading = true;
  UserModel? _userData;
  User? _currentUser;
  Map<String, dynamic>? _userProfile;
  
  UserProfileApiService? _userProfileApiService;
  bool _servicesInitialized = false;

  // Settings state variables
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'Korean';
  bool _profilePublic = true;
  bool _statsPublic = true;
  bool _shareDataEnabled = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadSettings();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_servicesInitialized) {
      _initializeServices();
      _servicesInitialized = true;
    }
  }

  void _initializeServices() {
    _userProfileApiService = ServiceLocator.getUserProfileApiService(context);
    _loadUserData();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _darkModeEnabled = prefs.getBool('dark_mode_enabled') ?? false;
      _selectedLanguage = prefs.getString('selected_language') ?? 'Korean';
      _profilePublic = prefs.getBool('profile_public') ?? true;
      _statsPublic = prefs.getBool('stats_public') ?? true;
      _shareDataEnabled = prefs.getBool('share_data_enabled') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('dark_mode_enabled', _darkModeEnabled);
    await prefs.setString('selected_language', _selectedLanguage);
    await prefs.setBool('profile_public', _profilePublic);
    await prefs.setBool('stats_public', _statsPublic);
    await prefs.setBool('share_data_enabled', _shareDataEnabled);
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final authService = ServiceLocator.getAuthService(context);
      _currentUser = authService.currentUser;

      if (_currentUser != null) {
        _userData = UserModel(
          uid: _currentUser!.uid,
          email: _currentUser!.email ?? '',
          name: _currentUser!.displayName ?? 'User',
          isStudent: false,
          gradeOrSubject: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // 프로필 API 호출 (실패 시 fallback 데이터 사용)
        try {
          final profileResponse = await _userProfileApiService?.getUserProfile(_currentUser!.uid);
          if (profileResponse != null) {
            _userProfile = profileResponse.toJson();
          } else {
            _userProfile = _getFallbackProfileData();
          }
        } catch (e) {
          print('Profile API error: \$e');
          _userProfile = _getFallbackProfileData();
        }
      }
    } catch (e) {
      print('Error loading user data: \$e');
    } finally {
      setState(() => _isLoading = false);
      _animationController.forward();
    }
  }

  Map<String, dynamic> _getFallbackProfileData() {
    return {
      'name': _currentUser?.displayName ?? 'Player',
      'email': _currentUser?.email ?? 'player@example.com',
      'position': 'Forward',
      'team_name': 'Daehan High School',
      'jersey_number': 10,
      'goals': 15,
      'assists': 8,
      'games_played': 12,
      'profile_image_url': null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: _isLoading 
          ? _buildLoadingState()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildAppBar(),
                    _buildProfileHeader(),
                    _buildStatsSection(),
                    _buildSettingsSection(),
                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(radius: 16),
          SizedBox(height: 16),
          Text(
            '프로필을 불러오는 중...',
            style: TextStyle(
              fontSize: 17,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: const Icon(
                  CupertinoIcons.back,
                  size: 20,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                '프로필',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final profile = _userProfile ?? {};
    final name = profile['name'] ?? _userData?.name ?? 'Player';
    // final position = profile['position'] ?? 'Player';
    // final teamName = profile['team_name'] ?? 'Team';
    final jerseyNumber = profile['jersey_number'] ?? 0;

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              AppTheme.accentColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Profile Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.accentColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    offset: const Offset(0, 8),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      jerseyNumber > 0 ? jerseyNumber.toString() : name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.camera_fill,
                        size: 16,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Name and Position
            Text(
              name,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Player • Team',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    final profile = _userProfile ?? {};
    final goals = profile['goals'] ?? 0;
    final assists = profile['assists'] ?? 0;
    final gamesPlayed = profile['games_played'] ?? 0;

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이번 시즌 통계',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: CupertinoIcons.circle_fill,
                    label: '골',
                    value: goals.toString(),
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    icon: CupertinoIcons.hand_thumbsup_fill,
                    label: '어시스트',
                    value: assists.toString(),
                    color: AppTheme.successColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    icon: CupertinoIcons.sportscourt_fill,
                    label: '경기',
                    value: gamesPlayed.toString(),
                    color: AppTheme.warningColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                '설정',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            
            // General Settings
            _buildSettingsGroup(
              title: '일반 설정',
              items: [
                _buildSettingItem(
                  icon: CupertinoIcons.bell,
                  title: '알림',
                  subtitle: '푸시 알림 및 소리',
                  trailing: CupertinoSwitch(
                    value: _notificationsEnabled,
                    onChanged: (value) async {
                      setState(() => _notificationsEnabled = value);
                      await _saveSettings();
                      
                      // Update notification service
                      final notificationService = ServiceLocator.getNotificationService(context);
                      final currentSettings = notificationService.settings;
                      await notificationService.updateSettings(
                        currentSettings.copyWith(enabled: value),
                      );
                      
                      if (value) {
                        notificationService.showLocalNotification(
                          title: "알림 활성화",
                          body: "알림이 성공적으로 활성화되었습니다!",
                          type: "system",
                        );
                      }
                    },
                  ),
                  onTap: null,
                ),
                _buildSettingItem(
                  icon: CupertinoIcons.moon,
                  title: '다크 모드',
                  subtitle: '어두운 테마 사용',
                  trailing: CupertinoSwitch(
                    value: _darkModeEnabled,
                    onChanged: (value) async {
                      setState(() => _darkModeEnabled = value);
                      await _saveSettings();
                    },
                  ),
                  onTap: null,
                ),
                _buildSettingItem(
                  icon: CupertinoIcons.globe,
                  title: '언어',
                  subtitle: _selectedLanguage,
                  trailing: const Icon(
                    CupertinoIcons.chevron_right,
                    size: 16,
                    color: AppTheme.textTertiary,
                  ),
                  onTap: () => _showLanguageSelector(),
                ),
              ],
            ),
            
            const Divider(height: 1),
            
            // Privacy Settings
            _buildSettingsGroup(
              title: '개인정보 설정',
              items: [
                _buildSettingItem(
                  icon: CupertinoIcons.eye,
                  title: '프로필 공개',
                  subtitle: '다른 사용자에게 프로필 표시',
                  trailing: CupertinoSwitch(
                    value: _profilePublic,
                    onChanged: (value) async {
                      setState(() => _profilePublic = value);
                      await _saveSettings();
                    },
                  ),
                  onTap: null,
                ),
                _buildSettingItem(
                  icon: CupertinoIcons.chart_bar,
                  title: '통계 공개',
                  subtitle: '통계 정보 공개 여부',
                  trailing: CupertinoSwitch(
                    value: _statsPublic,
                    onChanged: (value) async {
                      setState(() => _statsPublic = value);
                      await _saveSettings();
                    },
                  ),
                  onTap: null,
                ),
                _buildSettingItem(
                  icon: CupertinoIcons.share,
                  title: '데이터 공유',
                  subtitle: '개선을 위한 익명 데이터 공유',
                  trailing: CupertinoSwitch(
                    value: _shareDataEnabled,
                    onChanged: (value) async {
                      setState(() => _shareDataEnabled = value);
                      await _saveSettings();
                    },
                  ),
                  onTap: null,
                ),
              ],
            ),
            
            const Divider(height: 1),
            
            // App Information
            _buildSettingsGroup(
              title: '앱 정보',
              items: [
                _buildSettingItem(
                  icon: CupertinoIcons.info_circle,
                  title: '앱 버전',
                  subtitle: '1.0.0',
                  trailing: const Icon(
                    CupertinoIcons.chevron_right,
                    size: 16,
                    color: AppTheme.textTertiary,
                  ),
                  onTap: () => _showAppInfo(),
                ),
                _buildSettingItem(
                  icon: CupertinoIcons.doc_text,
                  title: '이용약관',
                  subtitle: '서비스 이용약관 보기',
                  trailing: const Icon(
                    CupertinoIcons.chevron_right,
                    size: 16,
                    color: AppTheme.textTertiary,
                  ),
                  onTap: () => _showTermsOfService(),
                ),
                _buildSettingItem(
                  icon: CupertinoIcons.shield,
                  title: '개인정보처리방침',
                  subtitle: '개인정보 보호정책 보기',
                  trailing: const Icon(
                    CupertinoIcons.chevron_right,
                    size: 16,
                    color: AppTheme.textTertiary,
                  ),
                  onTap: () => _showPrivacyPolicy(),
                ),
              ],
            ),
            
            const Divider(height: 1),
            
            // Logout
            Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.errorColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _showLogoutDialog,
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.square_arrow_right,
                            color: AppTheme.errorColor,
                            size: 24,
                          ),
                          SizedBox(width: 16),
                          Text(
                            '로그아웃',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.errorColor,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            CupertinoIcons.chevron_right,
                            size: 16,
                            color: AppTheme.errorColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget? trailing,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.systemGray6,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('언어 선택'),
        message: const Text('앱에서 사용할 언어를 선택하세요'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _selectedLanguage = 'Korean');
              _saveSettings();
              Navigator.pop(context);
            },
            child: Text(
              '한국어',
              style: TextStyle(
                color: _selectedLanguage == 'Korean' ? AppTheme.primaryColor : AppTheme.textPrimary,
                fontWeight: _selectedLanguage == 'Korean' ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _selectedLanguage = 'English');
              _saveSettings();
              Navigator.pop(context);
            },
            child: Text(
              'English',
              style: TextStyle(
                color: _selectedLanguage == 'English' ? AppTheme.primaryColor : AppTheme.textPrimary,
                fontWeight: _selectedLanguage == 'English' ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
      ),
    );
  }

  void _showAppInfo() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.accentColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                CupertinoIcons.sportscourt_fill,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Text('FieldSync'),
          ],
        ),
        content: const Text(
          'Your Ultimate Sports Management Companion\\n\\n버전: 1.0.0\\n\\nSync Your Game, Elevate Your Performance\\n\\n스포츠 활동을 기록하고 통계를 확인하며 팀과 연결되는 올인원 플랫폼입니다.',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }


  void _showLogoutDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말로 로그아웃하시겠습니까?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              await _logout();
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    try {
      final authService = ServiceLocator.getAuthService(context);
      await authService.logout();
      
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      print('Logout error: \$e');
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('오류'),
            content: const Text('로그아웃 중 오류가 발생했습니다.'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showPrivacyPolicy() {
    context.push('/profile/privacy-policy');
  }

  void _showTermsOfService() {
    context.push('/profile/terms-of-service');
  }
}