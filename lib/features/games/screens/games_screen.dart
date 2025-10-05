import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/services/service_locator.dart';
import '../../../shared/models/game_model.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  List<Game> _games = [];
  List<Game> _filteredGames = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Scheduled', 'Live', 'Completed'];

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final gameApiService = ServiceLocator.getGameApiService(context);
      final games = await gameApiService.getAllGames();
      
      setState(() {
        _games = games;
        _filteredGames = games;
        _isLoading = false;
      });
      
      _applyFilter(_selectedFilter);
    } catch (e) {
      _errorMessage = 'Failed to load game list: $e';
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      
      switch (filter) {
        case 'Scheduled':
          _filteredGames = _games.where((game) => game.status == 'scheduled').toList();
          break;
        case 'Live':
          _filteredGames = _games.where((game) => game.status == 'live').toList();
          break;
        case 'Completed':
          _filteredGames = _games.where((game) => game.status == 'completed').toList();
          break;
        default:
          _filteredGames = _games;
      }
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
            onPressed: _loadGames,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Row(
              children: List.generate(_filters.length, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _applyFilter(_filters[index]);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        color: _selectedFilter == _filters[index]
                            ? AppTheme.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Center(
                        child: Text(
                          _filters[index],
                          style: TextStyle(
                            color: _selectedFilter == _filters[index]
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

          // Content
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

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadGames,
                              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredGames.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_soccer,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No games available',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: _filteredGames.length,
      itemBuilder: (context, index) {
        final game = _filteredGames[index];
        return _buildGameItem(game);
      },
    );
  }

  Widget _buildGameItem(Game game) {
    return InkWell(
      onTap: () {
        context.go('/games/detail/${game.id}');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  game.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(game.status),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    game.statusDisplayText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Teams and score
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Text(
                    game.homeTeamName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    game.scoreText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    game.awayTeamName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date and venue
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  '${game.formattedDate} ${game.formattedTime}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    game.venue,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'live':
        return Colors.red;
      case 'scheduled':
        return Colors.blue;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }
} 