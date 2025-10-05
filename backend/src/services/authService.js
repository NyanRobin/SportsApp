const admin = require('firebase-admin');
const jwt = require('jsonwebtoken');

class AuthService {
  constructor() {
    // Firebase Admin SDK 초기화 (실제 구현 시 설정 필요)
    if (!admin.apps.length) {
      admin.initializeApp({
        credential: admin.credential.applicationDefault(),
      });
    }
  }

  // Firebase ID 토큰 검증
  async verifyFirebaseToken(idToken) {
    try {
      const decodedToken = await admin.auth().verifyIdToken(idToken);
      return decodedToken;
    } catch (error) {
      throw new Error('Invalid Firebase token');
    }
  }

  // JWT 토큰 생성
  generateJWTToken(userId, email) {
    const payload = {
      userId,
      email,
      iat: Math.floor(Date.now() / 1000),
      exp: Math.floor(Date.now() / 1000) + (7 * 24 * 60 * 60), // 7 days
    };
    
    return jwt.sign(payload, process.env.JWT_SECRET);
  }

  // Refresh 토큰 생성
  generateRefreshToken(userId) {
    const payload = {
      userId,
      type: 'refresh',
      iat: Math.floor(Date.now() / 1000),
      exp: Math.floor(Date.now() / 1000) + (30 * 24 * 60 * 60), // 30 days
    };
    
    return jwt.sign(payload, process.env.JWT_SECRET);
  }

  // JWT 토큰 검증
  verifyJWTToken(token) {
    try {
      return jwt.verify(token, process.env.JWT_SECRET);
    } catch (error) {
      throw new Error('Invalid JWT token');
    }
  }

  // 사용자 인증 처리
  async authenticateUser(idToken) {
    try {
      // Firebase 토큰 검증
      const decodedToken = await this.verifyFirebaseToken(idToken);
      
      // 사용자 정보 추출
      const userId = decodedToken.uid;
      const email = decodedToken.email;
      const name = decodedToken.name || decodedToken.display_name || 'Unknown User';
      
      // JWT 토큰 생성
      const accessToken = this.generateJWTToken(userId, email);
      const refreshToken = this.generateRefreshToken(userId);
      
      return {
        success: true,
        user: {
          id: userId,
          email,
          name,
        },
        token: accessToken,
        refreshToken,
      };
    } catch (error) {
      throw new Error(`Authentication failed: ${error.message}`);
    }
  }

  // 토큰 갱신
  async refreshToken(refreshToken) {
    try {
      const decoded = this.verifyJWTToken(refreshToken);
      
      if (decoded.type !== 'refresh') {
        throw new Error('Invalid refresh token');
      }
      
      // 새로운 액세스 토큰 생성
      const newAccessToken = this.generateJWTToken(decoded.userId, decoded.email);
      
      return {
        success: true,
        token: newAccessToken,
      };
    } catch (error) {
      throw new Error(`Token refresh failed: ${error.message}`);
    }
  }

  // 사용자 프로필 가져오기 (모킹)
  async getUserProfile(userId) {
    // 실제 구현에서는 데이터베이스에서 사용자 정보를 가져옴
    return {
      id: userId,
      email: 'user@example.com',
      name: 'Test User',
      role: 'user',
      createdAt: new Date().toISOString(),
    };
  }

  // 사용자 프로필 업데이트 (모킹)
  async updateUserProfile(userId, profileData) {
    // 실제 구현에서는 데이터베이스에서 사용자 정보를 업데이트
    return {
      id: userId,
      ...profileData,
      updatedAt: new Date().toISOString(),
    };
  }
}

module.exports = new AuthService(); 