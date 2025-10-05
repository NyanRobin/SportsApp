import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_theme.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
              '서비스 이용약관',
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
                  CupertinoIcons.doc_text_fill,
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
                      '서비스 이용약관',
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
          
          // 서비스 이용약관 내용
          _buildSection(
            context,
            title: '제 1 조 (목적)',
            content: '''이 약관은 FieldSync(이하 "회사")가 제공하는 스포츠 관리 서비스(이하 "서비스")의 이용조건 및 절차, 회사와 회원 간의 권리, 의무, 책임사항 및 기타 필요한 사항을 규정함을 목적으로 합니다.''',
          ),
          
          _buildSection(
            context,
            title: '제 2 조 (정의)',
            content: '''이 약관에서 사용하는 용어의 정의는 다음과 같습니다:

1. "서비스"란 회사가 제공하는 FieldSync 모바일 애플리케이션 및 관련 서비스를 의미합니다.
2. "회원"이란 회사의 서비스에 접속하여 이 약관에 따라 회사와 이용계약을 체결하고 회사가 제공하는 서비스를 이용하는 고객을 말합니다.
3. "아이디(ID)"란 회원의 식별과 서비스 이용을 위하여 회원이 정하고 회사가 승인하는 문자 또는 숫자의 조합을 의미합니다.
4. "비밀번호"란 회원이 부여받은 아이디와 일치되는 회원임을 확인하고 비밀보호를 위해 회원 자신이 정한 문자 또는 숫자의 조합을 의미합니다.''',
          ),
          
          _buildSection(
            context,
            title: '제 3 조 (약관의 효력 및 변경)',
            content: '''1. 이 약관은 서비스를 이용하고자 하는 모든 회원에 대하여 그 효력을 발생합니다.
2. 회사는 합리적인 사유가 발생할 경우에는 이 약관을 변경할 수 있으며, 약관이 변경되는 경우 변경된 약관의 내용과 시행일을 정하여, 그 시행일로부터 최소 7일 이전에 회원에게 통지합니다.
3. 회원은 변경된 약관에 동의하지 않을 경우 회원탈퇴를 요청할 수 있으며, 변경된 약관의 효력 발생일 이후에도 서비스를 계속 이용할 경우 약관의 변경사항에 동의한 것으로 간주됩니다.''',
          ),
          
          _buildSection(
            context,
            title: '제 4 조 (서비스의 제공)',
            content: '''1. 회사는 회원에게 아래와 같은 서비스를 제공합니다:
   • 스포츠 통계 관리 서비스
   • 경기 일정 관리 서비스
   • 팀 관리 서비스
   • 실시간 채팅 서비스
   • 공지사항 서비스
   • 기타 회사가 추가 개발하거나 다른 회사와의 제휴계약 등을 통해 회원에게 제공하는 일체의 서비스

2. 회사는 서비스를 일정범위로 분할하여 각 범위별로 이용가능시간을 별도로 지정할 수 있습니다. 다만, 이러한 경우에는 그 내용을 사전에 공지합니다.''',
          ),
          
          _buildSection(
            context,
            title: '제 5 조 (서비스의 중단)',
            content: '''1. 회사는 컴퓨터 등 정보통신설비의 보수점검·교체 및 고장, 통신의 두절 등의 사유가 발생한 경우에는 서비스의 제공을 일시적으로 중단할 수 있습니다.
2. 회사는 제1항의 사유로 서비스의 제공이 일시적으로 중단됨으로 인하여 회원 또는 제3자가 입은 손해에 대하여 배상하지 않습니다. 단, 회사의 고의 또는 중과실에 의한 경우에는 그러하지 아니합니다.''',
          ),
          
          _buildSection(
            context,
            title: '제 6 조 (회원가입)',
            content: '''1. 회원가입은 신청자가 약관의 내용에 대하여 동의를 하고 회원가입신청을 한 후 회사가 이러한 신청에 대하여 승낙함으로써 체결됩니다.
2. 회사는 다음 각 호에 해당하는 신청에 대하여는 승낙하지 않거나 사후에 이용계약을 해지할 수 있습니다:
   • 타인의 명의를 이용하여 신청한 경우
   • 허위의 정보를 기재하거나, 회사가 제시하는 내용을 기재하지 않은 경우
   • 14세 미만의 아동이 법정대리인의 동의를 얻지 아니한 경우
   • 기타 회원으로 등록하는 것이 회사의 기술상 현저히 지장이 있다고 판단되는 경우''',
          ),
          
          _buildSection(
            context,
            title: '제 7 조 (회원정보의 변경)',
            content: '''1. 회원은 개인정보관리화면을 통하여 언제든지 본인의 개인정보를 열람하고 수정할 수 있습니다.
2. 회원은 회원가입신청 시 기재한 사항이 변경되었을 경우 온라인으로 수정을 하거나 전자우편 기타 방법으로 회사에 대하여 그 변경사항을 알려야 합니다.
3. 제2항의 변경사항을 회사에 알리지 않아 발생한 불이익에 대하여는 회원에게 책임이 있습니다.''',
          ),
          
          _buildSection(
            context,
            title: '제 8 조 (개인정보보호)',
            content: '''회사는 관계법령이 정하는 바에 따라 회원등록정보를 포함한 회원의 개인정보를 보호하기 위해 노력합니다. 회원의 개인정보보호에 관해서는 관련법령 및 회사의 개인정보처리방침에 정한 바에 의합니다.''',
          ),
          
          _buildSection(
            context,
            title: '제 9 조 (회원의 의무)',
            content: '''1. 회원은 다음 행위를 하여서는 안 됩니다:
   • 신청 또는 변경시 허위 내용의 등록
   • 타인의 정보 도용
   • 회사가 게시한 정보의 변경
   • 회사가 정한 정보 이외의 정보(컴퓨터 프로그램 등) 등의 송신 또는 게시
   • 회사 기타 제3자의 저작권 등 지적재산권에 대한 침해
   • 회사 기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위
   • 외설 또는 폭력적인 메시지, 화상, 음성, 기타 공서양속에 반하는 정보를 회사에 공개 또는 게시하는 행위

2. 회원은 관계법령, 이 약관의 규정, 이용안내 및 서비스상에 공지한 주의사항, 회사가 통지하는 사항 등을 준수하여야 하며, 기타 회사의 업무에 방해되는 행위를 하여서는 안 됩니다.''',
          ),
          
          _buildSection(
            context,
            title: '제 10 조 (저작권의 귀속)',
            content: '''1. 회사가 작성한 저작물에 대한 저작권 기타 지적재산권은 회사에 귀속합니다.
2. 회원은 회사를 이용함으로써 얻은 정보 중 회사에게 지적재산권이 귀속된 정보를 회사의 사전 승낙 없이 복제, 송신, 출판, 배포, 방송 기타 방법에 의하여 영리목적으로 이용하거나 제3자에게 이용하게 하여서는 안됩니다.
3. 회원이 서비스에 게시한 게시물의 저작권은 해당 게시물의 저작자에게 귀속됩니다.''',
          ),
          
          _buildSection(
            context,
            title: '제 11 조 (손해배상)',
            content: '''회사는 무료로 제공되는 서비스와 관련하여 회원에게 어떠한 손해가 발생하더라도 동 손해가 회사의 고의 또는 중대한 과실에 의한 경우를 제외하고 이에 대하여 책임을 부담하지 아니합니다.''',
          ),
          
          _buildSection(
            context,
            title: '제 12 조 (분쟁해결)',
            content: '''1. 회사는 회원이 제기하는 정당한 의견이나 불만을 반영하고 그 피해를 보상처리하기 위하여 피해보상처리기구를 설치·운영합니다.
2. 회사와 회원 간에 발생한 전자상거래 분쟁에 관한 소송은 서울중앙지방법원을 관할 법원으로 합니다.''',
          ),
          
          const SizedBox(height: 32),
          
          // 동의 확인 안내
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
                      CupertinoIcons.checkmark_seal,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '서비스 이용 동의',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'FieldSync 서비스를 이용하시면 위의 이용약관에 동의한 것으로 간주됩니다.\n문의사항이 있으시면 fieldsync.app@gmail.com으로 연락주세요.',
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


