class AppConstants {
  // API Configuration - Supabase Edge Functions
  static const String supabaseUrl = 'https://ayqcfpldgsfntwlurkca.supabase.co';
  static const String edgeFunctionsUrl = '$supabaseUrl/functions/v1';
  
  // Supabase REST API (direct database access)
  static const String supabaseRestApiUrl = '$supabaseUrl/rest/v1';
  
  // For local development, use Node.js backend
  static const String localBaseUrl = 'http://localhost:3000';
  static const String localApiUrl = '$localBaseUrl/api';
  
  // Choose environment
  static const bool useSupabaseFunctions = true; // Use Supabase Edge Functions (production)
  static const String baseUrl = useSupabaseFunctions ? supabaseUrl : localBaseUrl;
  static const String apiVersion = useSupabaseFunctions ? '/functions/v1' : '/api';
  static const String apiBaseUrl = useSupabaseFunctions ? edgeFunctionsUrl : localApiUrl;
  
  // Supabase API Keys (for Edge Functions)
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF5cWNmcGxkZ3NmbnR3bHVya2NhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDYwNzEyNjQsImV4cCI6MjAyMTY0NzI2NH0.vK9AV8W6Ff1qVWZfUPVHEV2KLHK8F5N-oR5_CtgN7RM';
  
  // Environment
  static const bool isDevelopment = !useSupabaseFunctions;
  static const bool isProduction = useSupabaseFunctions;
  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/webp',
  ];
  static const List<String> allowedDocumentTypes = [
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  ];
  
  // Cache
  static const int cacheExpirationMinutes = 15;
  static const int imageCacheExpirationDays = 7;
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  
  // Error Messages
  static const String networkErrorMessage = 'Please check your network connection.';
  static const String serverErrorMessage = 'A server error occurred.';
  static const String timeoutErrorMessage = 'Request timeout occurred.';
  static const String unauthorizedErrorMessage = 'Login is required.';
  static const String forbiddenErrorMessage = 'Access denied.';
  static const String notFoundErrorMessage = 'Requested data not found.';
  static const String unknownErrorMessage = 'An unknown error occurred.';
  
  // Success Messages
  static const String loginSuccessMessage = 'Logged in successfully.';
  static const String logoutSuccessMessage = 'Logged out successfully.';
  static const String saveSuccessMessage = 'Saved successfully.';
  static const String deleteSuccessMessage = 'Deleted successfully.';
  static const String uploadSuccessMessage = 'Uploaded successfully.';
  
  // Validation Messages
  static const String requiredFieldMessage = 'This field is required.';
  static const String invalidEmailMessage = 'Please enter a valid email format.';
  static const String invalidPasswordMessage = 'Password must be at least 8 characters long.';
  static const String passwordMismatchMessage = 'Passwords do not match.';
  static const String invalidPhoneMessage = 'Please enter a valid phone number format.';
  
  // App Information
  static const String appName = 'FieldSync';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your Ultimate Sports Management Companion';
  static const String appTagline = 'Sync Your Game, Elevate Your Performance';
  
  // Route Names
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String gamesRoute = '/games';
  static const String announcementsRoute = '/announcements';
  static const String statisticsRoute = '/statistics';
  static const String profileRoute = '/profile';
  static const String notificationsRoute = '/notifications';
}
