import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/supabase_config.dart';

class ProfileSettingsWidget extends StatefulWidget {
  final Map<String, dynamic> userProfile;
  final Function(Map<String, dynamic>) onSettingsChanged;

  const ProfileSettingsWidget({
    super.key,
    required this.userProfile,
    required this.onSettingsChanged,
  });

  @override
  State<ProfileSettingsWidget> createState() => _ProfileSettingsWidgetState();
}

class _ProfileSettingsWidgetState extends State<ProfileSettingsWidget> {
  late Map<String, dynamic> _settings;

  @override
  void initState() {
    super.initState();
    _settings = Map.from(widget.userProfile);
  }

  void _updateSetting(String key, dynamic value) {
    setState(() {
      _settings[key] = value;
    });
    widget.onSettingsChanged(_settings);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            '프로필 설정',
            CupertinoIcons.settings,
          ),
          const SizedBox(height: 16),
          _buildPrivacySettings(),
          const SizedBox(height: 16),
          _buildNotificationSettings(),
          const SizedBox(height: 16),
          _buildDisplaySettings(),
          const SizedBox(height: 16),
          _buildAccountSettings(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySettings() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubSectionTitle('개인정보 설정'),
          const SizedBox(height: 12),
          _buildSettingItem(
            title: '프로필 공개',
            subtitle: '다른 사용자에게 프로필 정보 공개',
            icon: CupertinoIcons.eye,
            value: _settings['profile_public'] ?? true,
            onChanged: (value) => _updateSetting('profile_public', value),
          ),
          _buildSettingItem(
            title: '통계 공개',
            subtitle: '개인 통계 정보 공개',
            icon: CupertinoIcons.chart_bar,
            value: _settings['stats_public'] ?? true,
            onChanged: (value) => _updateSetting('stats_public', value),
          ),
          _buildSettingItem(
            title: '연락처 표시',
            subtitle: '전화번호 및 이메일 공개',
            icon: CupertinoIcons.phone,
            value: _settings['contact_visible'] ?? false,
            onChanged: (value) => _updateSetting('contact_visible', value),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubSectionTitle('알림 설정'),
          const SizedBox(height: 12),
          _buildSettingItem(
            title: '게임 알림',
            subtitle: '게임 일정 및 결과 알림',
            icon: CupertinoIcons.game_controller,
            value: _settings['game_notifications'] ?? true,
            onChanged: (value) => _updateSetting('game_notifications', value),
          ),
          _buildSettingItem(
            title: '팀 공지',
            subtitle: '팀 공지사항 알림',
            icon: CupertinoIcons.bell,
            value: _settings['team_notifications'] ?? true,
            onChanged: (value) => _updateSetting('team_notifications', value),
          ),
          _buildSettingItem(
            title: '채팅 알림',
            subtitle: '팀 채팅 메시지 알림',
            icon: CupertinoIcons.chat_bubble,
            value: _settings['chat_notifications'] ?? true,
            onChanged: (value) => _updateSetting('chat_notifications', value),
          ),
          _buildSettingItem(
            title: '통계 업데이트',
            subtitle: '개인 통계 업데이트 알림',
            icon: CupertinoIcons.graph_circle,
            value: _settings['stats_notifications'] ?? false,
            onChanged: (value) => _updateSetting('stats_notifications', value),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplaySettings() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubSectionTitle('화면 설정'),
          const SizedBox(height: 12),
          _buildSettingItem(
            title: '다크 모드',
            subtitle: '어두운 테마 사용',
            icon: CupertinoIcons.moon,
            value: _settings['dark_mode'] ?? false,
            onChanged: (value) => _updateSetting('dark_mode', value),
          ),
          _buildSettingItem(
            title: '애니메이션',
            subtitle: '화면 전환 애니메이션 사용',
            icon: CupertinoIcons.sparkles,
            value: _settings['animations_enabled'] ?? true,
            onChanged: (value) => _updateSetting('animations_enabled', value),
          ),
          _buildLanguageSelector(),
        ],
      ),
    );
  }

  Widget _buildAccountSettings() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubSectionTitle('계정 설정'),
          const SizedBox(height: 12),
          _buildActionItem(
            title: '비밀번호 변경',
            subtitle: '계정 비밀번호 변경',
            icon: CupertinoIcons.lock,
            onTap: _changePassword,
          ),
          _buildActionItem(
            title: '계정 연동',
            subtitle: '소셜 계정 연동 관리',
            icon: CupertinoIcons.link,
            onTap: _manageLinkedAccounts,
          ),
          _buildActionItem(
            title: '데이터 내보내기',
            subtitle: '개인 데이터 백업',
            icon: CupertinoIcons.square_arrow_down,
            onTap: _exportData,
          ),
          _buildActionItem(
            title: '계정 삭제',
            subtitle: '계정 영구 삭제',
            icon: CupertinoIcons.trash,
            onTap: _deleteAccount,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSubSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.systemGray4.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 18,
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
                    color: AppTheme.textPrimary,
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
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDestructive 
                    ? AppTheme.errorColor.withOpacity(0.3)
                    : AppTheme.systemGray4.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDestructive 
                        ? AppTheme.errorColor.withOpacity(0.1)
                        : AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive 
                        ? AppTheme.errorColor
                        : AppTheme.primaryColor,
                    size: 18,
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
                          color: isDestructive 
                              ? AppTheme.errorColor
                              : AppTheme.textPrimary,
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
                Icon(
                  CupertinoIcons.chevron_right,
                  color: AppTheme.textTertiary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    final languages = ['한국어', 'English', '日本語', '中文'];
    final selectedLanguage = _settings['language'] ?? '한국어';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.systemGray4.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  CupertinoIcons.globe,
                  color: AppTheme.primaryColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '언어 설정',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '앱 표시 언어 선택',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedLanguage,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            items: languages.map((String language) {
              return DropdownMenuItem<String>(
                value: language,
                child: Text(language),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                _updateSetting('language', newValue);
              }
            },
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('비밀번호 변경'),
        content: const Text('비밀번호 변경 기능은 준비 중입니다.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _manageLinkedAccounts() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('계정 연동'),
        content: const Text('소셜 계정 연동 기능은 준비 중입니다.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('데이터 내보내기'),
        content: const Text('개인 데이터를 백업 파일로 내보내시겠습니까?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement data export
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('데이터 내보내기 준비 중입니다')),
              );
            },
            child: const Text('내보내기'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('계정 삭제'),
        content: const Text('정말로 계정을 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없으며, 모든 데이터가 영구적으로 삭제됩니다.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _showFinalDeleteConfirmation();
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  void _showFinalDeleteConfirmation() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('최종 확인'),
        content: const Text('계정을 삭제하려면 "DELETE"를 입력해주세요.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('계정 삭제 기능은 준비 중입니다')),
              );
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}


