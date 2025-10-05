import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Custom App Bar
              SliverToBoxAdapter(
                child: _buildAppBar(),
              ),
              
              // Welcome Section
              SliverToBoxAdapter(
                child: _buildWelcomeSection(),
              ),
              
              // Quick Stats
              SliverToBoxAdapter(
                child: _buildQuickStats(),
              ),
              
              // Quick Actions
              SliverToBoxAdapter(
                child: _buildQuickActions(),
              ),
              
              // Bottom spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
          // Logo
                  GestureDetector(
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
            
          // Profile Button
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.go(AppConstants.profileRoute),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    CupertinoIcons.person_circle,
                    size: 24,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to FieldSync! 👋',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sync Your Game, Elevate Your Performance',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildWelcomeCard(
                  icon: CupertinoIcons.sportscourt,
                  label: '이번 주 경기',
                  value: '3',
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildWelcomeCard(
                  icon: CupertinoIcons.star_fill,
                  label: '승률',
                  value: '87%',
                  color: AppTheme.successColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
          const SizedBox(height: 8),
              Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
              Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.textTertiary,
            ),
            textAlign: TextAlign.center,
              ),
            ],
          ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
            '이번 시즌 통계',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                child: _buildStatCard(
                  title: '골',
                  value: '12',
                  subtitle: '+3 이번 주',
                  icon: CupertinoIcons.circle_fill,
                  color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                child: _buildStatCard(
                  title: '어시스트',
                  value: '8',
                  subtitle: '+1 이번 주',
                  icon: CupertinoIcons.hand_thumbsup_fill,
                  color: AppTheme.successColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                child: _buildStatCard(
                  title: '경기',
                  value: '15',
                  subtitle: '+2 이번 주',
                  icon: CupertinoIcons.sportscourt_fill,
                  color: AppTheme.warningColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '빠른 실행',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          children: [
              _buildActionCard(
                title: '경기 일정',
                subtitle: '다가오는 경기 확인',
                icon: CupertinoIcons.calendar,
                onTap: () => context.go('/games'),
              color: AppTheme.primaryColor,
            ),
              _buildActionCard(
                title: '통계',
                subtitle: '개인 & 팀 성과',
                icon: CupertinoIcons.chart_bar_fill,
                onTap: () => context.go('/statistics'),
                color: AppTheme.successColor,
              ),
              _buildActionCard(
                title: '공지사항',
                subtitle: '최신 소식 확인',
                icon: CupertinoIcons.speaker_2_fill,
                onTap: () => context.go('/announcements'),
                color: AppTheme.warningColor,
              ),
              _buildActionCard(
                title: '프로필',
                subtitle: '내 정보 및 설정',
                icon: CupertinoIcons.person_circle_fill,
                onTap: () => context.go(AppConstants.profileRoute),
                color: AppTheme.primaryColor,
            ),
          ],
        ),
        ],
      ),
    );
  }
  
  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
                const Spacer(),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
