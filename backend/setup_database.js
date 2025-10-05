const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

// PostgreSQL 연결 설정 (데이터베이스 생성을 위해 기본 postgres DB에 연결)
const adminPool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432'),
  database: 'postgres', // 기본 데이터베이스
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'password',
});

// 앱 데이터베이스 연결 설정
const appPool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432'),
  database: process.env.DB_NAME || 'sports_app',
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'password',
});

async function setupDatabase() {
  try {
    console.log('🚀 데이터베이스 설정을 시작합니다...');

    // 1. 데이터베이스 존재 확인 및 생성
    const dbName = process.env.DB_NAME || 'sports_app';
    
    console.log(`📊 데이터베이스 '${dbName}' 존재 여부 확인 중...`);
    const dbCheckResult = await adminPool.query(
      'SELECT 1 FROM pg_database WHERE datname = $1',
      [dbName]
    );

    if (dbCheckResult.rows.length === 0) {
      console.log(`📊 데이터베이스 '${dbName}' 생성 중...`);
      await adminPool.query(`CREATE DATABASE ${dbName}`);
      console.log(`✅ 데이터베이스 '${dbName}' 생성 완료`);
    } else {
      console.log(`✅ 데이터베이스 '${dbName}' 이미 존재합니다`);
    }

    // 2. 마이그레이션 파일 실행
    console.log('📋 테이블 생성 중...');
    const migrationPath = path.join(__dirname, 'src', 'config', 'migrations.sql');
    const migrationSQL = fs.readFileSync(migrationPath, 'utf8');
    
    await appPool.query(migrationSQL);
    console.log('✅ 테이블 생성 완료');

    // 3. 샘플 데이터 삽입 (선택사항)
    console.log('📝 샘플 데이터 삽입 중...');
    await insertSampleData();
    console.log('✅ 샘플 데이터 삽입 완료');

    console.log('🎉 데이터베이스 설정이 완료되었습니다!');
    
  } catch (error) {
    console.error('❌ 데이터베이스 설정 중 오류 발생:', error);
    throw error;
  } finally {
    await adminPool.end();
    await appPool.end();
  }
}

async function insertSampleData() {
  // 샘플 사용자 데이터 먼저 삽입
  await appPool.query(`
    INSERT INTO users (id, email, name, phone, is_student, grade_or_subject) VALUES 
    ('sample_user_1', 'admin1@school.com', '관리자1', '010-1234-5678', false, '체육'),
    ('sample_user_2', 'admin2@school.com', '관리자2', '010-1234-5679', false, '체육'),
    ('sample_user_3', 'admin3@school.com', '관리자3', '010-1234-5680', false, '체육')
    ON CONFLICT (id) DO NOTHING
  `);

  // 샘플 팀 데이터
  await appPool.query(`
    INSERT INTO teams (name, description) VALUES 
    ('축구부', '학교 대표 축구팀'),
    ('농구부', '학교 대표 농구팀'),
    ('배구부', '학교 대표 배구팀')
    ON CONFLICT DO NOTHING
  `);

  // 샘플 공지사항 데이터
  await appPool.query(`
    INSERT INTO announcements (title, content, tag, author_id) VALUES 
    ('축구 경기 일정 안내', '다음 주 토요일 오후 2시에 축구 경기가 있습니다.', '경기일정', 'sample_user_1'),
    ('체육관 이용 안내', '체육관 이용 시간이 변경되었습니다.', '시설안내', 'sample_user_2'),
    ('운동부 모집 공고', '새 학기 운동부 신입 부원을 모집합니다.', '모집공고', 'sample_user_3')
    ON CONFLICT DO NOTHING
  `);
}

// 스크립트 실행
if (require.main === module) {
  setupDatabase()
    .then(() => {
      console.log('데이터베이스 설정 완료');
      process.exit(0);
    })
    .catch((error) => {
      console.error('데이터베이스 설정 실패:', error);
      process.exit(1);
    });
}

module.exports = { setupDatabase };
