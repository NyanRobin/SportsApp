import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/network/game_api_service.dart';
import '../../../core/network/api_service.dart';
import '../../../shared/models/game_model.dart';
import '../../../shared/models/game_timeline_model.dart';
import '../../../shared/models/game_lineup_model.dart';
import '../../../shared/models/game_stats_model.dart';
import '../../../shared/models/game_highlights_model.dart';

class GameDetailScreen extends StatefulWidget {
  final String gameId;
  
  const GameDetailScreen({
    super.key,
    required this.gameId,
  });

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late GameApiService _gameApiService;
  
  // State variables
  bool _isLoading = true;
  String? _error;
  Game? _game;
  List<GameTimelineEvent> _timeline = [];
  Map<String, GameLineup?> _lineup = {};
  GameStats? _statistics;
  List<GameHighlight> _highlights = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _gameApiService = GameApiService(ApiService());
    _loadGameDetails();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadGameDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Safely parse gameId, handle both string and int
      final gameId = int.tryParse(widget.gameId);
      if (gameId == null) {
        throw Exception('Invalid game ID: ${widget.gameId}');
      }
      
      final gameDetails = await _gameApiService.getGameDetails(gameId);
      
      setState(() {
        _game = gameDetails['game'];
        _timeline = gameDetails['timeline'] ?? [];
        _lineup = gameDetails['lineup'] ?? {};
        _statistics = gameDetails['statistics'];
        _highlights = gameDetails['highlights'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadGameDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Game Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
              context.go('/games');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _refreshData,
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {
              // Share game details
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Timeline'),
            Tab(text: 'Lineup'),
            Tab(text: 'Statistics'),
            Tab(text: 'Highlights'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorWidget()
              : Column(
        children: [
          // Game Info Card
          _buildGameInfoCard(),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTimelineTab(),
                _buildLineupTab(),
                _buildStatsTab(),
                _buildHighlightsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading game details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? 'Unknown error',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _refreshData,
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
  
  Widget _buildGameInfoCard() {
    if (_game == null) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        height: 150,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          // Date and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_game!.formattedDate} ${_game!.formattedTime}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(_game!.status),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _game!.statusDisplayText.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Teams and Scores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home Team
              Expanded(
                child: Column(
                children: [
                    Text(
                      _game!.homeTeamName,
                      style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                      textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                      _game!.homeScore.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
                ),
              ),
              
              // VS
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                'VS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Away Team
              Expanded(
                child: Column(
                children: [
                    Text(
                      _game!.awayTeamName,
                      style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                      textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                    Text(
                      _game!.awayScore.toString(),
                      style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                _game!.venue,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return Colors.red;
      case 'completed':
        return Colors.green;
      case 'scheduled':
        return Colors.blue;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }
  
  Widget _buildTimelineTab() {
    if (_timeline.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: [
            Icon(
              Icons.timeline,
              size: 60,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No timeline events available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    // Sort timeline events by minute (descending - most recent first)
    final sortedTimeline = List<GameTimelineEvent>.from(_timeline)
      ..sort((a, b) => b.minute.compareTo(a.minute));

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedTimeline.length,
        itemBuilder: (context, index) {
          final event = sortedTimeline[index];
          return _buildTimelineItem(event);
        },
      ),
    );
  }
  
  Widget _buildTimelineItem(GameTimelineEvent event) {
    final iconData = _getEventIcon(event.eventType);
    final iconColor = _getEventColor(event.eventType);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Minute
          SizedBox(
            width: 50,
            child: Text(
              event.displayMinute,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Timeline Line and Icon
          Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: iconColor,
                  size: 16,
                ),
              ),
              Container(
                width: 2,
                height: 40,
                color: Colors.grey.shade200,
              ),
            ],
          ),
          const SizedBox(width: 12),
          
          // Event Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getEventDisplayName(event.eventType),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (event.teamName != null) ...[
                Text(
                    event.teamName!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                if (event.playerName != null) ...[
                  Text(
                    event.playerName!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                if (event.description != null)
                  Text(
                    event.description!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEventIcon(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'goal':
        return Icons.sports_soccer;
      case 'yellow_card':
        return Icons.warning;
      case 'red_card':
        return Icons.error;
      case 'substitution':
        return Icons.swap_horiz;
      case 'kick_off':
      case 'half_time':
      case 'full_time':
        return Icons.sports_soccer;
      case 'corner':
        return Icons.flag;
      case 'offside':
        return Icons.sports_handball;
      case 'foul':
        return Icons.sports_mma;
      default:
        return Icons.sports_soccer;
    }
  }

  Color _getEventColor(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'goal':
        return Colors.green;
      case 'yellow_card':
        return Colors.amber;
      case 'red_card':
        return Colors.red;
      case 'substitution':
        return Colors.blue;
      case 'kick_off':
      case 'half_time':
      case 'full_time':
        return Colors.grey;
      case 'corner':
        return Colors.orange;
      case 'offside':
        return Colors.purple;
      case 'foul':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  String _getEventDisplayName(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'goal':
        return 'Goal';
      case 'yellow_card':
        return 'Yellow Card';
      case 'red_card':
        return 'Red Card';
      case 'substitution':
        return 'Substitution';
      case 'kick_off':
        return 'Kick Off';
      case 'half_time':
        return 'Half Time';
      case 'full_time':
        return 'Full Time';
      case 'corner':
        return 'Corner';
      case 'offside':
        return 'Offside';
      case 'foul':
        return 'Foul';
      default:
        return eventType;
    }
  }
  
  Widget _buildLineupTab() {
    if (_lineup.isEmpty || (_lineup['home'] == null && _lineup['away'] == null)) {
    return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.groups,
              size: 60,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No lineup information available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_lineup['home'] != null) ...[
              _buildTeamLineup(_lineup['home']!, true),
              const SizedBox(height: 24),
            ],
            if (_lineup['away'] != null) ...[
              _buildTeamLineup(_lineup['away']!, false),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTeamLineup(GameLineup lineup, bool isHome) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Team Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isHome ? AppTheme.primaryColor : Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                lineup.teamName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Formation: ${lineup.formation}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Starting XI
        _buildPlayerSection('Starting XI', lineup.startingEleven),
        
        const SizedBox(height: 16),
        
        // Substitutes
        if (lineup.substitutes.isNotEmpty)
          _buildPlayerSection('Substitutes', lineup.substitutes),
      ],
    );
  }

  Widget _buildPlayerSection(String title, List<PlayerLineup> players) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...players.map((player) => _buildPlayerCard(player)),
      ],
    );
  }

  Widget _buildPlayerCard(PlayerLineup player) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Jersey Number
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getPositionColor(player.position),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                player.jerseyNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Player Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        player.playerName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (player.isCaptain)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'C',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  player.positionFullName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (player.isSubstituted) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Substituted at ${player.minuteSubstituted}\'${player.substitutePlayerName != null ? ' → ${player.substitutePlayerName}' : ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPositionColor(String position) {
    switch (position.toUpperCase()) {
      case 'GK':
        return Colors.orange;
      case 'CB':
      case 'LB':
      case 'RB':
      case 'LWB':
      case 'RWB':
        return Colors.blue;
      case 'CM':
      case 'CDM':
      case 'CAM':
      case 'LM':
      case 'RM':
        return Colors.green;
      case 'LW':
      case 'RW':
      case 'CF':
      case 'ST':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  Widget _buildStatsTab() {
    if (_statistics == null) {
    return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 60,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No statistics available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    final stats = _getStatItems(_statistics!);

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Team names header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _statistics!.homeTeam.teamName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 80),
                Expanded(
                  child: Text(
                    _statistics!.awayTeam.teamName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          
          // Statistics items
          ...stats.map((stat) => _buildStatisticItem(stat)),
        ],
      ),
    );
  }

  List<StatItem> _getStatItems(GameStats statistics) {
    return [
      StatItem(
        label: 'Possession',
        homeValue: statistics.homeTeam.possession,
        awayValue: statistics.awayTeam.possession,
        isPercentage: true,
      ),
      StatItem(
        label: 'Shots',
        homeValue: statistics.homeTeam.shots,
        awayValue: statistics.awayTeam.shots,
      ),
      StatItem(
        label: 'Shots on Target',
        homeValue: statistics.homeTeam.shotsOnTarget,
        awayValue: statistics.awayTeam.shotsOnTarget,
      ),
      StatItem(
        label: 'Corners',
        homeValue: statistics.homeTeam.corners,
        awayValue: statistics.awayTeam.corners,
      ),
      StatItem(
        label: 'Fouls',
        homeValue: statistics.homeTeam.fouls,
        awayValue: statistics.awayTeam.fouls,
      ),
      StatItem(
        label: 'Yellow Cards',
        homeValue: statistics.homeTeam.yellowCards,
        awayValue: statistics.awayTeam.yellowCards,
      ),
      StatItem(
        label: 'Red Cards',
        homeValue: statistics.homeTeam.redCards,
        awayValue: statistics.awayTeam.redCards,
      ),
      StatItem(
        label: 'Offsides',
        homeValue: statistics.homeTeam.offsides,
        awayValue: statistics.awayTeam.offsides,
      ),
      StatItem(
        label: 'Saves',
        homeValue: statistics.homeTeam.saves,
        awayValue: statistics.awayTeam.saves,
      ),
      StatItem(
        label: 'Passes',
        homeValue: statistics.homeTeam.passes,
        awayValue: statistics.awayTeam.passes,
      ),
      StatItem(
        label: 'Pass Accuracy',
        homeValue: statistics.homeTeam.passAccuracy,
        awayValue: statistics.awayTeam.passAccuracy,
        isPercentage: true,
      ),
      StatItem(
        label: 'Distance Covered',
        homeValue: statistics.homeTeam.distanceCovered.toStringAsFixed(1),
        awayValue: statistics.awayTeam.distanceCovered.toStringAsFixed(1),
        unit: 'km',
      ),
    ];
  }

  Widget _buildStatisticItem(StatItem stat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Values row
          Row(
            children: [
              // Home value
              Expanded(
                child: Text(
                  stat.formattedHomeValue,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Label
              SizedBox(
                width: 80,
                child: Text(
                  stat.label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Away value
              Expanded(
                child: Text(
                  stat.formattedAwayValue,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Progress bar (for numerical stats)
          if (stat.homeValue is num && stat.awayValue is num)
            Row(
              children: [
                Expanded(
                  flex: (stat.homePercentage * 100).round(),
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(2),
                        bottomLeft: Radius.circular(2),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: (stat.awayPercentage * 100).round(),
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(2),
                        bottomRight: Radius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
  
  Widget _buildHighlightsTab() {
    if (_highlights.isEmpty) {
    return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library,
              size: 60,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No highlights available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    // Sort highlights by minute (descending - most recent first)
    final sortedHighlights = List<GameHighlight>.from(_highlights)
      ..sort((a, b) => b.minute.compareTo(a.minute));

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedHighlights.length,
        itemBuilder: (context, index) {
          final highlight = sortedHighlights[index];
          return _buildHighlightCard(highlight);
        },
      ),
    );
  }

  Widget _buildHighlightCard(GameHighlight highlight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail/Video section
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Stack(
              children: [
                // Placeholder for video thumbnail
                if (highlight.thumbnailUrl != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.network(
                      highlight.thumbnailUrl!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildVideoPlaceholder(),
                    ),
                  )
                else
                  _buildVideoPlaceholder(),
                
                // Play button overlay
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                
                // Duration badge
                if (highlight.duration > 0)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        highlight.formattedDuration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                
                // Minute badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getHighlightTypeColor(highlight.highlightType),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      highlight.displayMinute,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type and title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getHighlightTypeColor(highlight.highlightType).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        highlight.typeDisplayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getHighlightTypeColor(highlight.highlightType),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        highlight.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Team and player info
                if (highlight.teamName != null || highlight.playerName != null) ...[
                  Row(
                    children: [
                      if (highlight.teamName != null) ...[
                        Icon(
                          Icons.groups,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          highlight.teamName!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        if (highlight.playerName != null) const SizedBox(width: 16),
                      ],
                      if (highlight.playerName != null) ...[
                        Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          highlight.playerName!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                
                // Description
                Text(
                  highlight.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey.shade300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library,
            size: 40,
            color: Colors.grey.shade500,
          ),
          const SizedBox(height: 8),
          Text(
            'Video Highlight',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getHighlightTypeColor(String highlightType) {
    switch (highlightType.toLowerCase()) {
      case 'goal':
        return Colors.green;
      case 'save':
        return Colors.blue;
      case 'skill':
        return Colors.purple;
      case 'tackle':
        return Colors.orange;
      case 'assist':
        return Colors.cyan;
      case 'miss':
        return Colors.red;
      case 'foul':
        return Colors.brown;
      case 'card':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

}
