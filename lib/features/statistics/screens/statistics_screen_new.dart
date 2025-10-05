import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/services/service_locator.dart';
import '../../../../shared/models/statistics_model.dart';
import '../../../../core/theme/app_theme.dart';

class StatisticsScreenNew extends StatefulWidget {
  const StatisticsScreenNew({super.key});

  @override
  State<StatisticsScreenNew> createState() => _StatisticsScreenNewState();
}

class _StatisticsScreenNewState extends State<StatisticsScreenNew>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String? _error;
  
  // 통계 데이터
  List<TopScorer> _topScorers = [];
  List<TopAssister> _topAssisters = [];
  List<TeamStats> _teamRankings = [];
  UserStats? _userStats;
  
  // 필터 옵션
  String _selectedSeason = '2025';
  String _selectedCategory = 'All Seasons';
  String _selectedGame = 'Select Game';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadStatistics();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final statisticsService = ServiceLocator.getStatisticsApiService(context);
      
      // 병렬로 여러 통계 데이터 로드
      final results = await Future.wait([
        statisticsService.getTopScorers(limit: 10, season: _selectedSeason == 'All Seasons' ? null : _selectedSeason),
        statisticsService.getTopAssisters(limit: 10, season: _selectedSeason == 'All Seasons' ? null : _selectedSeason),
        statisticsService.getTeamRankings(season: _selectedSeason == 'All Seasons' ? null : _selectedSeason),
      ]);

      setState(() {
        _topScorers = results[0] as List<TopScorer>;
        _topAssisters = results[1] as List<TopAssister>;
        _teamRankings = results[2] as List<TeamStats>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load statistics: $e';
        _isLoading = false;
      });
    }
  }

  void _showSeasonDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Season'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'All Seasons',
            '2025',
            '2024',
            '2023',
          ].map((season) => ListTile(
            title: Text(season),
            onTap: () {
              setState(() {
                _selectedSeason = season;
              });
              Navigator.pop(context);
              _loadStatistics();
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Goals/Assists',
            'Team Rankings',
            'Player Performance',
            'Game Statistics',
          ].map((category) => ListTile(
            title: Text(category),
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showGameDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Game'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'All Games',
            'Daehan vs Gangbuk (2025-05-15)',
            'Seoul vs Daehan (2025-05-20)',
            'Gangbuk vs Seoul (2025-05-25)',
          ].map((game) => ListTile(
            title: Text(game),
            onTap: () {
              setState(() {
                _selectedGame = game;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/home');
          },
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
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.of(context).pushReplacementNamed('/home');
            }
          },
        ),
      ),
      body: Column(
        children: [
          // 필터 옵션들
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 시즌 선택
                Row(
                  children: [
                    const Text('Season: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: GestureDetector(
                        onTap: _showSeasonDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_selectedSeason),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                
                // 카테고리 선택
                Row(
                  children: [
                    const Text('Category: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: GestureDetector(
                        onTap: _showCategoryDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_selectedCategory),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                
                // 게임 선택
                Row(
                  children: [
                    const Text('Game: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: GestureDetector(
                        onTap: _showGameDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_selectedGame),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 탭바
          Container(
            color: Colors.grey.shade100,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.primaryColor,
              tabs: const [
                Tab(text: 'Top Scorers'),
                Tab(text: 'Top Assisters'),
                Tab(text: 'Team Rankings'),
                Tab(text: 'Player Stats'),
              ],
            ),
          ),

          // 탭 내용
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(_error!, style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadStatistics,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildTopScorersTab(),
                          _buildTopAssistersTab(),
                          _buildTeamRankingsTab(),
                          _buildPlayerStatsTab(),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopScorersTab() {
    return RefreshIndicator(
      onRefresh: _loadStatistics,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _topScorers.length,
        itemBuilder: (context, index) {
          final scorer = _topScorers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(scorer.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(scorer.teamName),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${scorer.goals} goals',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  Text(
                    '${scorer.goalsPerGame.toStringAsFixed(1)} per game',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopAssistersTab() {
    return RefreshIndicator(
      onRefresh: _loadStatistics,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _topAssisters.length,
        itemBuilder: (context, index) {
          final assister = _topAssisters[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(assister.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(assister.teamName),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${assister.assists} assists',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  Text(
                    '${assister.assistsPerGame.toStringAsFixed(1)} per game',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamRankingsTab() {
    return RefreshIndicator(
      onRefresh: _loadStatistics,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _teamRankings.length,
        itemBuilder: (context, index) {
          final team = _teamRankings[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: team.rank <= 3 ? Colors.amber : Colors.grey,
                child: Text(
                  '${team.rank}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(team.teamName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${team.wins}W ${team.draws}D ${team.losses}L'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${team.points} pts',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${team.goalsFor}-${team.goalsAgainst}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerStatsTab() {
    return RefreshIndicator(
      onRefresh: _loadStatistics,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Player Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select a player to view detailed statistics',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement player selection and detailed stats
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Player selection coming soon!')),
                );
              },
              child: const Text('Select Player'),
            ),
          ],
        ),
      ),
    );
  }
} 