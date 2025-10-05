import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import '../../../core/theme/app_theme.dart';
import '../../../shared/services/service_locator.dart';
import '../../../core/network/statistics_api_service.dart';
import '../../../core/network/game_api_service.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with TickerProviderStateMixin {
  bool _isLoading = true;
  String _selectedSeason = '2025';
  int _selectedSegment = 0; // 0: 개인, 1: 팀, 2: 리그
  
  final List<String> _seasons = ['2025', '2024', '2023', '2022'];
  // 백엔드 데이터
  List<Map<String, dynamic>> _topScorers = [];
  List<Map<String, dynamic>> _topAssisters = [];
  List<Map<String, dynamic>> _teamRankings = [];
  Map<String, dynamic>? _userStats;
  
  late final StatisticsApiService _statisticsApiService;
  late final GameApiService _gameApiService;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeServices();
    _loadData();
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
  
  void _initializeServices() {
    _statisticsApiService = ServiceLocator.getStatisticsApiService(context);
    _gameApiService = ServiceLocator.getGameApiService(context);
  }
  
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      // 게임 목록은 현재 사용하지 않음
      
      // 상위 득점자 로드 (새로운 API 사용)
      final topScorersResponse = await _statisticsApiService.getTopScorers(limit: 10, season: _selectedSeason);
      _topScorers = topScorersResponse.map<Map<String, dynamic>>((scorer) => {
        'user_id': scorer.user_id,
        'user_name': scorer.user_name,
        'team_name': scorer.team_name ?? 'Unknown Team',
        'goals': scorer.goals,
        'assists': scorer.assists,
        'total_games': scorer.total_games,
        'goals_per_game': scorer.goals_per_game,
        'rank': scorer.rank,
        'position': scorer.position,
        'is_student': scorer.is_student,
        'grade_or_subject': scorer.grade_or_subject,
      }).toList();
      
      // 상위 도움왕 로드
      final topAssistersResponse = await _statisticsApiService.getTopAssisters(limit: 10, season: _selectedSeason);
      _topAssisters = topAssistersResponse.map<Map<String, dynamic>>((assister) => {
        'user_id': assister.user_id,
        'user_name': assister.user_name,
        'team_name': assister.team_name ?? 'Unknown Team',
        'goals': assister.goals,
        'assists': assister.assists,
        'total_games': assister.total_games,
        'assists_per_game': assister.assists_per_game,
        'rank': assister.rank,
        'position': assister.position,
        'is_student': assister.is_student,
        'grade_or_subject': assister.grade_or_subject,
      }).toList();

      // 팀 랭킹 로드
      final teamRankingsResponse = await _statisticsApiService.getTeamRankings(season: _selectedSeason);
      _teamRankings = teamRankingsResponse.map<Map<String, dynamic>>((team) => {
        'team_id': team.team_id,
        'team_name': team.team_name,
        'total_games': team.total_games,
        'wins': team.wins,
        'losses': team.losses,
        'draws': team.draws,
        'goals_for': team.goals_for,
        'goals_against': team.goals_against,
        'goal_difference': team.goal_difference,
        'points': team.points,
        'win_rate': team.win_rate,
        'rank': team.rank,
      }).toList();
      
      // 사용자 통계 로드 (현재 사용자)
      try {
        final authService = ServiceLocator.getAuthService(context);
        final currentUser = authService.currentUser;
        if (currentUser != null) {
          final userStatsResponse = await _statisticsApiService.getUserStats(currentUser.uid);
          if (userStatsResponse != null) {
            _userStats = userStatsResponse;
          }
        }
      } catch (e) {
        print('User stats not available: \$e');
      }
      
      // 통계가 비어있을 경우 fallback 데이터 사용
      if (_topScorers.isEmpty || _topAssisters.isEmpty || _teamRankings.isEmpty) {
        _setFallbackData();
      }
      
      print('DEBUG: Loaded statistics successfully');
      print('Top scorers: \${_topScorers.length}');
      print('Top assisters: \${_topAssisters.length}');
      print('Team rankings: \${_teamRankings.length}');
      
    } catch (e) {
      print('Error loading data: \$e');
      _setFallbackData();
    } finally {
      setState(() => _isLoading = false);
      _animationController.forward();
    }
  }

  void _setFallbackData() {
    _topScorers = _getTestStatisticsData()['topScorers'] ?? [];
    _topAssisters = _getTestStatisticsData()['topAssisters'] ?? [];
    _teamRankings = _getTestStatisticsData()['teamRankings'] ?? [];
    _userStats = _getTestStatisticsData()['userStats'];
  }

  Map<String, dynamic> _getTestStatisticsData() {
    return {
      'topScorers': [
        {
          'user_id': 'user1',
          'user_name': 'Kim Minseok',
          'team_name': 'Daehan High School',
          'goals': 15,
          'assists': 8,
          'total_games': 12,
          'goals_per_game': 1.25,
          'rank': 1,
          'position': 'Forward',
          'is_student': true,
          'grade_or_subject': '3학년',
        },
        {
          'user_id': 'user2', 
          'user_name': 'Park Jisung',
          'team_name': 'Gangbuk High School',
          'goals': 12,
          'assists': 15,
          'total_games': 11,
          'goals_per_game': 1.09,
          'rank': 2,
          'position': 'Midfielder',
          'is_student': true,
          'grade_or_subject': '2학년',
        },
        {
          'user_id': 'user3',
          'user_name': 'Lee Junho',
          'team_name': 'Seoul High School', 
          'goals': 10,
          'assists': 6,
          'total_games': 10,
          'goals_per_game': 1.0,
          'rank': 3,
          'position': 'Forward',
          'is_student': true,
          'grade_or_subject': '3학년',
        },
      ],
      'topAssisters': [
        {
          'user_id': 'user2',
          'user_name': 'Park Jisung',
          'team_name': 'Gangbuk High School',
          'assists': 15,
          'goals': 12,
          'total_games': 11,
          'assists_per_game': 1.36,
          'rank': 1,
          'position': 'Midfielder',
          'is_student': true,
          'grade_or_subject': '2학년',
        },
        {
          'user_id': 'user4',
          'user_name': 'Choi Jaewon',
          'team_name': 'Seoul High School',
          'assists': 12,
          'goals': 5,
          'total_games': 9,
          'assists_per_game': 1.33,
          'rank': 2,
          'position': 'Midfielder',
          'is_student': true,
          'grade_or_subject': '1학년',
        },
        {
          'user_id': 'user1',
          'user_name': 'Kim Minseok',
          'team_name': 'Daehan High School',
          'assists': 8,
          'goals': 15,
          'total_games': 12,
          'assists_per_game': 0.67,
          'rank': 3,
          'position': 'Forward',
          'is_student': true,
          'grade_or_subject': '3학년',
        },
      ],
      'teamRankings': [
        {
          'team_id': 1,
          'team_name': 'Daehan High School',
          'total_games': 12,
          'wins': 10,
          'draws': 1,
          'losses': 1,
          'goals_for': 35,
          'goals_against': 12,
          'goal_difference': 23,
          'points': 31,
          'win_rate': 83.3,
          'rank': 1,
        },
        {
          'team_id': 2,
          'team_name': 'Gangbuk High School',
          'total_games': 11,
          'wins': 8,
          'draws': 2,
          'losses': 1,
          'goals_for': 28,
          'goals_against': 15,
          'goal_difference': 13,
          'points': 26,
          'win_rate': 72.7,
          'rank': 2,
        },
        {
          'team_id': 3,
          'team_name': 'Seoul High School',
          'total_games': 10,
          'wins': 6,
          'draws': 2,
          'losses': 2,
          'goals_for': 22,
          'goals_against': 18,
          'goal_difference': 4,
          'points': 20,
          'win_rate': 60.0,
          'rank': 3,
        },
      ],
      'userStats': {
        'games_played': 12,
        'total_goals': 15,
        'total_assists': 8,
        'total_minutes_played': 1080,
        'avg_goals_per_game': 1.25,
        'avg_assists_per_game': 0.67,
      },
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
                    _buildSeasonSelector(),
                    _buildSegmentedControl(),
                    if (_selectedSegment == 0) ..._buildPersonalStats(),
                    if (_selectedSegment == 1) ..._buildTeamStats(),
                    if (_selectedSegment == 2) ..._buildLeagueStats(),
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
            '통계를 불러오는 중...',
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
                '통계',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                CupertinoIcons.chart_bar_fill,
                size: 20,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonSelector() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppTheme.systemGray6,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: _seasons.map((season) {
            final isSelected = season == _selectedSeason;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedSeason = season);
                  _loadData();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.surfaceColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 1),
                        blurRadius: 3,
                      ),
                    ] : null,
                  ),
                  child: Text(
                    season,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: CupertinoSlidingSegmentedControl<int>(
          backgroundColor: AppTheme.systemGray6,
          thumbColor: AppTheme.surfaceColor,
          groupValue: _selectedSegment,
          children: {
            0: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                '개인',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _selectedSegment == 0 ? AppTheme.textPrimary : AppTheme.textSecondary,
                ),
              ),
            ),
            1: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                '팀',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _selectedSegment == 1 ? AppTheme.textPrimary : AppTheme.textSecondary,
                ),
              ),
            ),
            2: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                '리그',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _selectedSegment == 2 ? AppTheme.textPrimary : AppTheme.textSecondary,
                ),
              ),
            ),
          },
          onValueChanged: (value) {
            setState(() => _selectedSegment = value!);
          },
        ),
      ),
    );
  }

  List<Widget> _buildPersonalStats() {
    return [
      // 개인 통계 요약
      SliverToBoxAdapter(child: _buildPersonalSummary()),
      
      // 개인 차트
      SliverToBoxAdapter(child: _buildPersonalChart()),
      
      // 최근 경기 기록
      SliverToBoxAdapter(child: _buildRecentGames()),
    ];
  }

  List<Widget> _buildTeamStats() {
    return [
      // 팀 순위
      SliverToBoxAdapter(child: _buildTeamRankings()),
    ];
  }

  List<Widget> _buildLeagueStats() {
    return [
      // 득점왕
      SliverToBoxAdapter(child: _buildTopScorers()),
      
      // 도움왕
      SliverToBoxAdapter(child: _buildTopAssisters()),
    ];
  }

  Widget _buildPersonalSummary() {
    final stats = _userStats;
    if (stats == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.cardShadow,
        ),
        child: const Center(
          child: Text(
            '개인 통계를 불러올 수 없습니다',
            style: TextStyle(
              fontSize: 17,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
      );
    }

    return Container(
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
            '개인 성과',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: '골',
                  value: '${stats['total_goals'] ?? 0}',
                  subtitle: '${(stats['avg_goals_per_game'] ?? 0.0).toStringAsFixed(1)}/경기',
                  icon: CupertinoIcons.circle_fill,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: '어시스트',
                  value: '${stats['total_assists'] ?? 0}',
                  subtitle: '${(stats['avg_assists_per_game'] ?? 0.0).toStringAsFixed(1)}/경기',
                  icon: CupertinoIcons.hand_thumbsup_fill,
                  color: AppTheme.successColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: '경기 수',
                  value: '${stats['games_played'] ?? 0}',
                  subtitle: '이번 시즌',
                  icon: CupertinoIcons.sportscourt_fill,
                  color: AppTheme.warningColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: '플레이 시간',
                  value: '${((stats['total_minutes_played'] ?? 0) ~/ 60)}h',
                  subtitle: '${(stats['total_minutes_played'] ?? 0) % 60}분',
                  icon: CupertinoIcons.clock_fill,
                  color: AppTheme.systemGray,
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalChart() {
    return Container(
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
            '월별 성과',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.systemGray5,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: AppTheme.textTertiary,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ['1월', '2월', '3월', '4월', '5월', '6월'];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Text(
                            months[value.toInt()],
                            style: const TextStyle(
                              color: AppTheme.textTertiary,
                              fontSize: 12,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 5),
                      const FlSpot(2, 4),
                      const FlSpot(3, 6),
                      const FlSpot(4, 8),
                      const FlSpot(5, 7),
                    ],
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: AppTheme.primaryColor,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppTheme.primaryColor,
                          strokeWidth: 2,
                          strokeColor: AppTheme.surfaceColor,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.3),
                          AppTheme.primaryColor.withOpacity(0.05),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentGames() {
    return Container(
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
            '최근 경기',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...[
            _buildGameResult(
              opponent: '강북고등학교',
              result: '승리',
              score: '3-1',
              goals: 2,
              assists: 1,
              resultColor: AppTheme.successColor,
            ),
            _buildGameResult(
              opponent: '서울고등학교',
              result: '무승부',
              score: '2-2',
              goals: 1,
              assists: 0,
              resultColor: AppTheme.warningColor,
            ),
            _buildGameResult(
              opponent: '부산고등학교',
              result: '승리',
              score: '4-0',
              goals: 3,
              assists: 1,
              resultColor: AppTheme.successColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGameResult({
    required String opponent,
    required String result,
    required String score,
    required int goals,
    required int assists,
    required Color resultColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.systemGray5,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: resultColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              result,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: resultColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'vs $opponent',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$goals골 $assists어시스트',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            score,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: resultColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamRankings() {
    return Container(
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
            '팀 순위',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          ..._teamRankings.asMap().entries.map((entry) {
            final index = entry.key;
            final team = entry.value;
            return _buildTeamRankingItem(team, index);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTeamRankingItem(Map<String, dynamic> team, int index) {
    final rank = team['rank'] ?? (index + 1);
    final teamName = team['team_name'] ?? 'Unknown Team';
    final wins = team['wins'] ?? 0;
    final draws = team['draws'] ?? 0;
    final losses = team['losses'] ?? 0;
    final points = team['points'] ?? 0;
    final winRate = team['win_rate'] ?? 0.0;

    Color rankColor = AppTheme.textSecondary;
    if (rank == 1) rankColor = AppTheme.successColor;
    else if (rank == 2) rankColor = AppTheme.primaryColor;
    else if (rank == 3) rankColor = AppTheme.warningColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: rank <= 3 ? rankColor.withOpacity(0.05) : AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: rank <= 3 ? rankColor.withOpacity(0.2) : AppTheme.systemGray5,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rankColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: rankColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teamName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$wins승 $draws무 $losses패 • ${winRate.toStringAsFixed(1)}% 승률',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${points}pt',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: rankColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopScorers() {
    return Container(
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
            '득점왕',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          ..._topScorers.take(5).toList().asMap().entries.map((entry) {
            final index = entry.key;
            final scorer = entry.value;
            return _buildPlayerItem(
              player: scorer,
              index: index,
              primaryStat: scorer['goals']?.toString() ?? '0',
              primaryLabel: '골',
              secondaryStat: scorer['assists']?.toString() ?? '0',
              secondaryLabel: '어시스트',
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTopAssisters() {
    return Container(
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
            '도움왕',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          ..._topAssisters.take(5).toList().asMap().entries.map((entry) {
            final index = entry.key;
            final assister = entry.value;
            return _buildPlayerItem(
              player: assister,
              index: index,
              primaryStat: assister['assists']?.toString() ?? '0',
              primaryLabel: '어시스트',
              secondaryStat: assister['goals']?.toString() ?? '0',
              secondaryLabel: '골',
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPlayerItem({
    required Map<String, dynamic> player,
    required int index,
    required String primaryStat,
    required String primaryLabel,
    required String secondaryStat,
    required String secondaryLabel,
  }) {
    final rank = index + 1;
    final playerName = player['user_name'] ?? 'Unknown Player';
    final teamName = player['team_name'] ?? 'Unknown Team';
    final position = player['position'] ?? '';

    Color rankColor = AppTheme.textSecondary;
    if (rank == 1) rankColor = AppTheme.successColor;
    else if (rank == 2) rankColor = AppTheme.primaryColor;
    else if (rank == 3) rankColor = AppTheme.warningColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: rank <= 3 ? rankColor.withOpacity(0.05) : AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: rank <= 3 ? rankColor.withOpacity(0.2) : AppTheme.systemGray5,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rankColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: rankColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playerName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$teamName${position.isNotEmpty ? ' • $position' : ''}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                primaryStat,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: rankColor,
                ),
              ),
              Text(
                primaryLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Container(
            width: 1,
            height: 32,
            color: AppTheme.systemGray5,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                secondaryStat,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                secondaryLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}