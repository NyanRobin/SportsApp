const { Pool } = require('pg');
require('dotenv').config();

// PostgreSQL 연결 풀 생성
const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432'),
  database: process.env.DB_NAME || 'sports_app',
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'password',
  ssl: process.env.DB_SSL === 'true' ? {
    rejectUnauthorized: false,
    sslmode: 'require'
  } : false,
  max: 20, // 최대 연결 수
  idleTimeoutMillis: 30000, // 유휴 연결 타임아웃
  connectionTimeoutMillis: 5000, // 연결 타임아웃 (5초로 감소)
  application_name: 'sports-app-backend'
});

// 데이터베이스 연결 상태
let isConnected = false;

// 연결 테스트
pool.on('connect', () => {
  console.log('✅ PostgreSQL 데이터베이스에 연결되었습니다.');
  isConnected = true;
});

pool.on('error', (err) => {
  console.error('❌ PostgreSQL 연결 오류:', err.message);
  isConnected = false;
});

// 데이터베이스 연결 테스트 함수
async function testConnection() {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT NOW() as current_time, version() as db_version');
    console.log('✅ 데이터베이스 연결 테스트 성공:', result.rows[0]);
    client.release();
    isConnected = true;
    return true;
  } catch (error) {
    console.error('❌ 데이터베이스 연결 테스트 실패:', error.message);
    console.log('🔄 개발 모드: 모크 데이터를 사용합니다.');
    isConnected = false;
    return false;
  }
}

// 안전한 쿼리 실행 함수 (항상 데이터베이스 사용 시도)
async function safeQuery(query, params = []) {
  try {
    const client = await pool.connect();
    const result = await client.query(query, params);
    client.release();
    // 성공적으로 실행되면 연결 상태를 true로 설정
    isConnected = true;
    return result;
  } catch (error) {
    console.error('❌ 쿼리 실행 오류:', error.message);
    console.log('Query:', query);
    isConnected = false;
    return { rows: [] };
  }
}

module.exports = {
  pool,
  testConnection,
  safeQuery,
  isConnected: () => isConnected
};