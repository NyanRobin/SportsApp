import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: AppTheme.cardShadow,
              ),
              child: const Icon(
                CupertinoIcons.back,
                size: 20,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '개인정보처리방침',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  CupertinoIcons.shield_fill,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '개인정보처리방침',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '최종 업데이트: 2024년 9월 21일',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // 개인정보처리방침 내용
          _buildSection(
            context,
            title: '1. 개인정보의 처리 목적',
            content: '''FieldSync는 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 개인정보보호법 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.

• 회원가입 및 관리: 회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 서비스 부정이용 방지
• 서비스 제공: 스포츠 통계 관리, 경기 일정 관리, 공지사항 전달, 맞춤형 서비스 제공
• 마케팅 및 광고에의 활용: 신규 서비스 개발 및 맞춤 서비스 제공, 이벤트 및 광고성 정보 제공 및 참여기회 제공''',
          ),
          
          _buildSection(
            context,
            title: '2. 개인정보의 처리 및 보유기간',
            content: '''① FieldSync는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.

② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다:
• 회원가입 및 관리: 회원탈퇴 시까지
• 서비스 제공: 서비스 제공 완료 시까지
• 통계 데이터: 3년 (개인식별정보 제거 후)''',
          ),
          
          _buildSection(
            context,
            title: '3. 처리하는 개인정보의 항목',
            content: '''FieldSync는 다음의 개인정보 항목을 처리하고 있습니다:

• 필수항목: 이름, 이메일주소, 비밀번호, 전화번호
• 선택항목: 프로필 사진, 포지션, 팀명, 등번호
• 자동 수집 항목: IP주소, 접속 로그, 서비스 이용 기록, 기기 정보''',
          ),
          
          _buildSection(
            context,
            title: '4. 개인정보의 제3자 제공',
            content: '''FieldSync는 정보주체의 개인정보를 개인정보의 처리 목적에서 명시한 범위 내에서만 처리하며, 정보주체의 동의, 법률의 특별한 규정 등 개인정보보호법 제17조에 해당하는 경우에만 개인정보를 제3자에게 제공합니다.''',
          ),
          
          _buildSection(
            context,
            title: '5. 개인정보처리의 위탁',
            content: '''FieldSync는 원활한 개인정보 업무처리를 위하여 다음과 같이 개인정보 처리업무를 위탁하고 있습니다:

• 클라우드 서비스 제공업체: 데이터 저장 및 백업
• 이메일 발송 대행업체: 회원 가입, 비밀번호 재설정 등 필수 이메일 발송
• 푸시 알림 서비스: 앱 내 알림 서비스 제공''',
          ),
          
          _buildSection(
            context,
            title: '6. 정보주체의 권리·의무 및 행사방법',
            content: '''정보주체는 FieldSync에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다:

• 개인정보 처리현황 통지요구
• 개인정보 열람요구
• 개인정보 정정·삭제요구
• 개인정보 처리정지요구

권리 행사는 FieldSync에 대해 서면, 전화, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 FieldSync는 이에 대해 지체없이 조치하겠습니다.''',
          ),
          
          _buildSection(
            context,
            title: '7. 개인정보의 안전성 확보조치',
            content: '''FieldSync는 개인정보보호법 제29조에 따라 다음과 같이 안전성 확보에 필요한 기술적/관리적 및 물리적 조치를 하고 있습니다:

• 개인정보 취급 직원의 최소화 및 교육
• 개인정보에 대한 접근 제한
• 개인정보를 저장하는 데이터베이스 시스템에 대한 접근권한의 부여, 변경, 말소를 통한 개인정보에 대한 접근통제
• 해킹이나 컴퓨터 바이러스 등에 의한 개인정보 유출 및 훼손을 막기 위한 보안프로그램 설치 및 주기적 갱신·점검
• 개인정보의 안전한 저장을 위한 저장데이터의 암호화''',
          ),
          
          _buildSection(
            context,
            title: '8. 개인정보보호책임자',
            content: '''FieldSync는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보보호책임자를 지정하고 있습니다:

• 개인정보보호책임자: FieldSync 개발팀
• 연락처: fieldsync.app@gmail.com
• 전화번호: 02-1234-5678

정보주체께서는 FieldSync의 서비스를 이용하시면서 발생한 모든 개인정보보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보보호책임자에게 문의하실 수 있습니다.''',
          ),
          
          const SizedBox(height: 32),
          
          // 연락처 정보
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.mail,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '문의사항이 있으시면 언제든 연락주세요',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '이메일: fieldsync.app@gmail.com\n전화번호: 02-1234-5678',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}


