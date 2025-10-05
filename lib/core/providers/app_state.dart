import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class AppState extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;
  Map<String, dynamic>? _userData;
  ThemeMode _themeMode = ThemeMode.system;
  String _language = 'ko';

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userData => _userData;
  ThemeMode get themeMode => _themeMode;
  String get language => _language;

  AppState() {
    _loadSavedData();
  }

  // Loading state management
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Error state management
  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Authentication state management
  void setAuthenticated(bool authenticated) {
    _isAuthenticated = authenticated;
    notifyListeners();
  }

  void setUserData(Map<String, dynamic>? userData) {
    _userData = userData;
    notifyListeners();
  }

  Future<void> login(Map<String, dynamic> userData, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.authTokenKey, token);
    await prefs.setString(AppConstants.userDataKey, userData.toString());
    
    _isAuthenticated = true;
    _userData = userData;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.authTokenKey);
    await prefs.remove(AppConstants.userDataKey);
    
    _isAuthenticated = false;
    _userData = null;
    notifyListeners();
  }

  // Theme management
  void setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.themeKey, themeMode.name);
    notifyListeners();
  }

  // Language management
  void setLanguage(String language) async {
    _language = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.languageKey, language);
    notifyListeners();
  }

  // Load saved data from SharedPreferences
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load theme
    final themeString = prefs.getString(AppConstants.themeKey);
    if (themeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.name == themeString,
        orElse: () => ThemeMode.system,
      );
    }
    
    // Load language
    _language = prefs.getString(AppConstants.languageKey) ?? 'ko';
    
    // Check authentication
    final token = prefs.getString(AppConstants.authTokenKey);
    final userDataString = prefs.getString(AppConstants.userDataKey);
    
    if (token != null && userDataString != null) {
      _isAuthenticated = true;
      // Parse user data string back to map (simplified)
      _userData = {'token': token};
    }
    
    notifyListeners();
  }
} 