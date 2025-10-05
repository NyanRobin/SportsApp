import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'api_service.dart';

class AuthApiService {
  final ApiService _apiService;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthApiService(this._apiService);

  // Firebase ID 토큰을 백엔드로 전송하여 JWT 토큰 발급
  Future<Map<String, dynamic>> authenticateWithBackend() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated with Firebase');
      }

      // Firebase ID 토큰 가져오기
      final idToken = await user.getIdToken();
      
      // 백엔드로 토큰 전송
      final response = await _apiService.post('/auth/firebase', data: {
        'idToken': idToken,
      });

      // JWT 토큰 저장
      if (response['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.authTokenKey, response['token']);
        
        if (response['refreshToken'] != null) {
          await prefs.setString(AppConstants.refreshTokenKey, response['refreshToken']);
        }
      }

      return response;
    } catch (e) {
      throw Exception('Failed to authenticate with backend: $e');
    }
  }

  // 토큰 갱신
  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(AppConstants.refreshTokenKey);
      
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await _apiService.post('/auth/refresh', data: {
        'refreshToken': refreshToken,
      });

      // 새로운 토큰 저장
      if (response['token'] != null) {
        await prefs.setString(AppConstants.authTokenKey, response['token']);
      }

      return response;
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }

  // 로그아웃 (백엔드 토큰 무효화)
  Future<void> logout() async {
    try {
      // 백엔드에 로그아웃 요청
      await _apiService.post('/auth/logout', data: {});
    } catch (e) {
      // 백엔드 로그아웃 실패해도 로컬 토큰은 삭제
      print('Backend logout failed: $e');
    } finally {
      // 로컬 토큰 삭제
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.authTokenKey);
      await prefs.remove(AppConstants.refreshTokenKey);
    }
  }

  // 사용자 프로필 가져오기
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _apiService.get('/auth/profile');
      return response;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  // 사용자 프로필 업데이트
  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _apiService.put('/auth/profile', data: profileData);
      return response;
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  // 토큰 유효성 검사
  Future<bool> validateToken() async {
    try {
      await _apiService.get('/auth/validate');
      return true;
    } catch (e) {
      return false;
    }
  }

  // 현재 저장된 토큰 가져오기
  Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.authTokenKey);
  }

  // 토큰이 있는지 확인
  Future<bool> hasValidToken() async {
    final token = await getStoredToken();
    if (token == null) return false;
    
    return await validateToken();
  }
} 