import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'shared/services/service_locator.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/games/screens/games_screen.dart';
import 'features/games/screens/preparation_screen.dart';
import 'features/games/screens/game_detail_screen.dart';
import 'features/announcements/screens/announcements_screen.dart';
import 'features/statistics/screens/statistics_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/profile/screens/profile_edit_screen.dart';
import 'features/profile/screens/privacy_policy_screen.dart';
import 'features/profile/screens/terms_of_service_screen.dart';
import 'features/notifications/screens/notifications_screen.dart';
import 'shared/widgets/bottom_navigation_bar.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      // 실시간 서비스 초기화
      final realtimeService = ServiceLocator().realtimeService;
      await realtimeService.initialize();
      print('✅ Realtime service initialized');
      
      // 네트워크 서비스 초기화
      final networkService = ServiceLocator().networkService;
      await networkService.initialize();
      print('✅ Network service initialized');
      
      // 로컬 저장소 서비스 초기화
      final localStorageService = ServiceLocator().localStorageService;
      await localStorageService.initialize();
      print('✅ Local storage service initialized');
      
      // 동기화 서비스 초기화
      final syncService = ServiceLocator().syncService;
      await syncService.initialize();
      print('✅ Sync service initialized');
      
    } catch (e) {
      print('❌ Failed to initialize services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthWrapper(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    // Shell route for main app with bottom navigation
    ShellRoute(
      builder: (context, state, child) => MainAppShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/games',
          builder: (context, state) => const GamesScreen(),
          routes: [
            GoRoute(
              path: 'detail/:id',
              builder: (context, state) {
                final gameId = state.pathParameters['id']!;
                return GameDetailScreen(gameId: gameId);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/preparation',
          builder: (context, state) => const PreparationScreen(),
        ),
        GoRoute(
          path: '/announcements',
          builder: (context, state) => const AnnouncementsScreen(),
        ),
        GoRoute(
          path: '/statistics',
          builder: (context, state) => const StatisticsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) {
                final userProfile = state.extra as Map<String, dynamic>?;
                return ProfileEditScreen(
                  userProfile: userProfile,
                  onProfileUpdated: (updatedProfile) {
                    // Handle profile update if needed
                  },
                );
              },
            ),
            GoRoute(
              path: 'privacy-policy',
              builder: (context, state) => const PrivacyPolicyScreen(),
            ),
            GoRoute(
              path: 'terms-of-service',
              builder: (context, state) => const TermsOfServiceScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
      ],
    ),
  ],
);

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with animation
                  Container(
                    padding: const EdgeInsets.all(24),
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
                    child: const Icon(
                      CupertinoIcons.sportscourt_fill,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'FieldSync',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      fontFamily: AppTheme.primaryFontFamily,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your Ultimate Sports Management Companion',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textSecondary,
                      fontFamily: AppTheme.bodyFontFamily,
                      letterSpacing: -0.23,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  const CupertinoActivityIndicator(radius: 16),
                  const SizedBox(height: 16),
                  const Text(
                    '앱을 준비하는 중...',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textSecondary,
                      fontFamily: AppTheme.bodyFontFamily,
                      letterSpacing: -0.24,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        
        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in, redirect to home
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/home');
          });
          return const Center(
            child: CupertinoActivityIndicator(radius: 16),
          );
        } else {
          // User is not logged in
          return const LoginScreen();
        }
      },
    );
  }
}

// Shell widget for main app with persistent bottom navigation
class MainAppShell extends StatefulWidget {
  final Widget child;
  
  const MainAppShell({
    super.key,
    required this.child,
  });

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Navigate to the corresponding route
    switch (index) {
      case 0:
        context.go(AppConstants.homeRoute);
        break;
      case 1:
        context.go(AppConstants.gamesRoute);
        break;
      case 2:
        context.go(AppConstants.announcementsRoute);
        break;
      case 3:
        context.go(AppConstants.statisticsRoute);
        break;
      case 4:
        context.go(AppConstants.profileRoute);
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCurrentIndex();
  }

  void _updateCurrentIndex() {
    final currentLocation = GoRouterState.of(context).fullPath;
    
    // Update the current index based on the current route
    if (currentLocation?.startsWith('/home') == true) {
      _currentIndex = 0;
    } else if (currentLocation?.startsWith('/games') == true) {
      _currentIndex = 1;
    } else if (currentLocation?.startsWith('/announcements') == true) {
      _currentIndex = 2;
    } else if (currentLocation?.startsWith('/statistics') == true) {
      _currentIndex = 3;
    } else if (currentLocation?.startsWith('/profile') == true) {
      _currentIndex = 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: widget.child,
          ),
          CustomBottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
          ),
        ],
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const GamesScreen();
      case 2:
        return const AnnouncementsScreen();
      case 3:
        return const StatisticsScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: _buildCurrentScreen(),
          ),
          CustomBottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
          ),
        ],
      ),
    );
  }
}
