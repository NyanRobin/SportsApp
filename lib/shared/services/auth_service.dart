import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'firestore_service.dart';
import '../../core/network/auth_api_service.dart';
import '../../core/providers/app_state.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  AuthApiService? _authApiService;
  AppState? _appState;
  
  void initialize(AuthApiService authApiService, AppState appState) {
    _authApiService = authApiService;
    _appState = appState;
  }
  
  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;
  
  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? phone,
    required bool isStudent,
    required String gradeOrSubject,
  }) async {
    try {
      // Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update user profile with name
      await userCredential.user?.updateDisplayName(name);
      
      // Store additional user data in Firestore
      await _storeUserData(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
        phone: phone,
        isStudent: isStudent,
        gradeOrSubject: gradeOrSubject,
      );
      
      notifyListeners();
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }
  
  // Login with email and password
  Future<UserCredential> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _appState?.setLoading(true);
      
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // 백엔드 인증
      if (_authApiService != null) {
        try {
          final backendResponse = await _authApiService!.authenticateWithBackend();
          _appState?.login(backendResponse, backendResponse['token'] ?? '');
        } catch (e) {
          print('Backend authentication failed: $e');
          // 백엔드 인증 실패해도 Firebase 로그인은 성공으로 처리
        }
      }
      
      _appState?.setLoading(false);
      notifyListeners();
      return userCredential;
    } catch (e) {
      _appState?.setLoading(false);
      _appState?.setError(getErrorMessage(e as FirebaseAuthException));
      rethrow;
    }
  }
  
  // Logout
  Future<void> logout() async {
    try {
      _appState?.setLoading(true);
      
      // 백엔드 로그아웃
      if (_authApiService != null) {
        try {
          await _authApiService!.logout();
        } catch (e) {
          print('Backend logout failed: $e');
        }
      }
      
      // Firebase 로그아웃
      await _auth.signOut();
      
      // 앱 상태 업데이트
      _appState?.logout();
      _appState?.setLoading(false);
      
      notifyListeners();
    } catch (e) {
      _appState?.setLoading(false);
              _appState?.setError('An error occurred during logout.');
      rethrow;
    }
  }
  
  // Reset password
  Future<void> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
  
  // Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.updatePhotoURL(photoURL);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  
  // Delete account
  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  
  // Store user data in Firestore
  Future<void> _storeUserData({
    required String uid,
    required String email,
    required String name,
    String? phone,
    required bool isStudent,
    required String gradeOrSubject,
  }) async {
    await _firestoreService.storeUserData(
      uid: uid,
      email: email,
      name: name,
      phone: phone,
      isStudent: isStudent,
      gradeOrSubject: gradeOrSubject,
    );
  }
  
  // Helper method to handle Firebase auth exceptions
  String getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The email address is already in use.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
