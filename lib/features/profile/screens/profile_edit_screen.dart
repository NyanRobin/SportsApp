import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import '../../../core/theme/app_theme.dart';
import '../../../shared/services/service_locator.dart';
import '../../../core/network/user_profile_api_service.dart';
import '../../../core/config/supabase_config.dart';

class ProfileEditScreen extends StatefulWidget {
  final Map<String, dynamic>? userProfile;
  final Function(Map<String, dynamic>) onProfileUpdated;

  const ProfileEditScreen({
    super.key,
    required this.userProfile,
    required this.onProfileUpdated,
  });

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _positionController;
  late TextEditingController _teamNameController;
  late TextEditingController _jerseyNumberController;
  late TextEditingController _gradeOrSubjectController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _bioController;
  
  bool _isLoading = false;
  bool _isStudent = true;
  String? _selectedPosition;
  DateTime? _selectedBirthDate;
  File? _selectedImage;
  Uint8List? _webImage;
  String? _currentAvatarUrl;
  // UserProfileApiService? _userProfileApiService; // Reserved for future API integration
  
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // Position options
  final List<String> _positions = [
    'Goalkeeper',
    'Defender', 
    'Midfielder',
    'Forward',
    'Striker',
    'Winger',
    'Center Back',
    'Full Back',
    'Attacking Midfielder',
    'Defensive Midfielder',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeControllers();
    _initializeServices();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  void _initializeServices() {
    // Reserved for future API service initialization
    // try {
    //   _userProfileApiService = ServiceLocator.getUserProfileApiService(context);
    // } catch (e) {
    //   print('Error initializing profile services: $e');
    // }
  }

  void _initializeControllers() {
    final profile = widget.userProfile ?? {};
    
    _nameController = TextEditingController(text: profile['name'] ?? '');
    _emailController = TextEditingController(text: profile['email'] ?? '');
    _phoneController = TextEditingController(text: profile['phone'] ?? '');
    _positionController = TextEditingController(text: profile['position'] ?? '');
    _teamNameController = TextEditingController(text: profile['team_name'] ?? '');
    _jerseyNumberController = TextEditingController(
      text: profile['jersey_number']?.toString() ?? ''
    );
    _gradeOrSubjectController = TextEditingController(
      text: profile['grade_or_subject'] ?? ''
    );
    _heightController = TextEditingController(
      text: profile['height_cm']?.toString() ?? ''
    );
    _weightController = TextEditingController(
      text: profile['weight_kg']?.toString() ?? ''
    );
    _bioController = TextEditingController(text: profile['bio'] ?? '');
    
    _isStudent = profile['is_student'] ?? true;
    _selectedPosition = profile['position'];
    _currentAvatarUrl = profile['avatar_url'];
    
    // Parse birth date if available
    if (profile['birthdate'] != null) {
      try {
        _selectedBirthDate = DateTime.parse(profile['birthdate']);
      } catch (e) {
        print('Error parsing birth date: $e');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    _teamNameController.dispose();
    _jerseyNumberController.dispose();
    _gradeOrSubjectController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // Image picker methods
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          setState(() {
            _webImage = bytes;
            _selectedImage = null;
          });
        } else {
          setState(() {
            _selectedImage = File(image.path);
            _webImage = null;
          });
        }
      }
    } catch (e) {
      _showErrorMessage('이미지 선택 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> _takePicture() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          setState(() {
            _webImage = bytes;
            _selectedImage = null;
          });
        } else {
          setState(() {
            _selectedImage = File(image.path);
            _webImage = null;
          });
        }
      }
    } catch (e) {
      _showErrorMessage('사진 촬영 중 오류가 발생했습니다: $e');
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _webImage = null;
      _currentAvatarUrl = null;
    });
  }

  void _showImagePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('프로필 사진 선택'),
        message: const Text('사진을 선택하는 방법을 골라주세요'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _pickImage();
            },
            child: const Text('갤러리에서 선택'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _takePicture();
            },
            child: const Text('카메라로 촬영'),
          ),
          if (_selectedImage != null || _webImage != null || _currentAvatarUrl != null)
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _removeImage();
              },
              isDestructiveAction: true,
              child: const Text('사진 제거'),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
      ),
    );
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: _selectedBirthDate ?? DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
            mode: CupertinoDatePickerMode.date,
            maximumDate: DateTime.now(),
            minimumDate: DateTime(1950),
            onDateTimeChanged: (DateTime newDate) {
              setState(() => _selectedBirthDate = newDate);
            },
          ),
        ),
      ),
    );

    if (picked != null) {
      setState(() => _selectedBirthDate = picked);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String? avatarUrl = _currentAvatarUrl;
      
      // Upload image if selected
      if (_selectedImage != null || _webImage != null) {
        try {
          final user = SupabaseConfig.currentUser;
          if (user != null) {
            final fileName = 'avatar_${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
            
            if (kIsWeb && _webImage != null) {
              avatarUrl = await SupabaseStorage.uploadFile(
                SupabaseConfig.avatarsBucket,
                fileName,
                _webImage!,
                contentType: 'image/jpeg',
              );
            } else if (_selectedImage != null) {
              final bytes = await _selectedImage!.readAsBytes();
              avatarUrl = await SupabaseStorage.uploadFile(
                SupabaseConfig.avatarsBucket,
                fileName,
                bytes,
                contentType: 'image/jpeg',
              );
            }
          }
        } catch (e) {
          print('Error uploading image: $e');
          _showErrorMessage('이미지 업로드 중 오류가 발생했습니다');
        }
      }

      final updatedProfile = {
        ...widget.userProfile ?? {},
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'position': _selectedPosition ?? _positionController.text.trim(),
        'team_name': _teamNameController.text.trim(),
        'jersey_number': int.tryParse(_jerseyNumberController.text) ?? null,
        'grade_or_subject': _gradeOrSubjectController.text.trim(),
        'height_cm': int.tryParse(_heightController.text) ?? null,
        'weight_kg': int.tryParse(_weightController.text) ?? null,
        'bio': _bioController.text.trim(),
        'is_student': _isStudent,
        'birthdate': _selectedBirthDate?.toIso8601String(),
        'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Update profile via Supabase
      try {
        final user = SupabaseConfig.currentUser;
        if (user != null) {
          await SupabaseConfig.client.updateUserProfile(user.id, updatedProfile);
        }
      } catch (e) {
        print('API update failed, continuing with local update: $e');
        _showErrorMessage('프로필 업데이트 중 오류가 발생했습니다');
      }

      widget.onProfileUpdated(updatedProfile);
      
      if (mounted) {
        _showSuccessMessage();
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('프로필 저장 중 오류가 발생했습니다: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('프로필이 성공적으로 업데이트되었습니다'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildProfileImageSection(),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: '기본 정보',
                        icon: CupertinoIcons.person_2,
                        children: [
                          _buildTextField(
                            controller: _nameController,
                            label: '이름',
                            icon: CupertinoIcons.person,
                            validator: (value) {
                              if (value?.trim().isEmpty ?? true) {
                                return '이름을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _emailController,
                            label: '이메일',
                            icon: CupertinoIcons.mail,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value?.trim().isEmpty ?? true) {
                                return '이메일을 입력해주세요';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value!)) {
                                return '올바른 이메일 형식을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _phoneController,
                            label: '전화번호',
                            icon: CupertinoIcons.phone,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          _buildBirthDateField(),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: '스포츠 정보',
                        icon: CupertinoIcons.sportscourt,
                        children: [
                          _buildPositionSelector(),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _teamNameController,
                            label: '팀명',
                            icon: CupertinoIcons.group,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _jerseyNumberController,
                            label: '등번호',
                            icon: CupertinoIcons.number,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.isNotEmpty == true) {
                                final number = int.tryParse(value!);
                                if (number == null || number < 1 || number > 99) {
                                  return '1-99 사이의 숫자를 입력해주세요';
                                }
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: '신체 정보',
                        icon: CupertinoIcons.person_crop_rectangle,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _heightController,
                                  label: '키 (cm)',
                                  icon: CupertinoIcons.arrow_up_down,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value?.isNotEmpty == true) {
                                      final height = int.tryParse(value!);
                                      if (height == null || height < 100 || height > 250) {
                                        return '100-250cm 사이 입력';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  controller: _weightController,
                                  label: '몸무게 (kg)',
                                  icon: CupertinoIcons.scope,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value?.isNotEmpty == true) {
                                      final weight = int.tryParse(value!);
                                      if (weight == null || weight < 30 || weight > 200) {
                                        return '30-200kg 사이 입력';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: '추가 정보',
                        icon: CupertinoIcons.info_circle,
                        children: [
                          _buildStudentToggle(),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _gradeOrSubjectController,
                            label: _isStudent ? '학년/반' : '담당 과목',
                            icon: _isStudent ? CupertinoIcons.book : CupertinoIcons.briefcase,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _bioController,
                            label: '자기소개',
                            icon: CupertinoIcons.chat_bubble_text,
                            maxLines: 3,
                            validator: (value) {
                              if (value != null && value.length > 200) {
                                return '자기소개는 200자 이내로 입력해주세요';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildSaveButton(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
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
              '프로필 편집',
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

  Widget _buildProfileImageSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Text(
            '프로필 사진',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _showImagePicker,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryColor.withOpacity(0.1),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: _buildProfileImage(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '탭하여 사진 변경',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    if (_webImage != null) {
      return Image.memory(
        _webImage!,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    } else if (_selectedImage != null) {
      return Image.file(
        _selectedImage!,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    } else if (_currentAvatarUrl != null && _currentAvatarUrl!.isNotEmpty) {
      return Image.network(
        _currentAvatarUrl!,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
      );
    } else {
      return _buildDefaultAvatar();
    }
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.primaryColor.withOpacity(0.1),
      ),
      child: Icon(
        CupertinoIcons.camera,
        size: 40,
        color: AppTheme.primaryColor.withOpacity(0.7),
      ),
    );
  }

  Widget _buildBirthDateField() {
    return GestureDetector(
      onTap: _selectBirthDate,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.systemGray4),
        ),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.calendar,
              color: AppTheme.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '생년월일',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedBirthDate != null
                        ? '${_selectedBirthDate!.year}년 ${_selectedBirthDate!.month}월 ${_selectedBirthDate!.day}일'
                        : '생년월일을 선택하세요',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: _selectedBirthDate != null 
                          ? AppTheme.textPrimary 
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              color: AppTheme.textTertiary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.systemGray4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.sportscourt,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                '포지션',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedPosition,
            hint: const Text('포지션을 선택하세요'),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            items: _positions.map((String position) {
              return DropdownMenuItem<String>(
                value: position,
                child: Text(position),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedPosition = newValue;
                _positionController.text = newValue ?? '';
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        maxLength: maxLength,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppTheme.textSecondary.withOpacity(0.8),
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.systemGray4.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppTheme.primaryColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.systemGray4.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppTheme.errorColor,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppTheme.errorColor,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: AppTheme.backgroundColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          counterStyle: TextStyle(
            color: AppTheme.textTertiary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.systemGray4),
      ),
      child: Row(
        children: [
          Icon(
            _isStudent ? CupertinoIcons.book : CupertinoIcons.briefcase,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '학생',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          CupertinoSwitch(
            value: _isStudent,
            onChanged: (value) => setState(() => _isStudent = value),
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const CupertinoActivityIndicator(color: Colors.white)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.check_mark_circled,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '프로필 저장',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

