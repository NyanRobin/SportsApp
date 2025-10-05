import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/services/service_locator.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  
  bool _isLoading = false;
  bool _isStudent = true; // Default to student registration
  String _selectedGrade = 'Grade 1'; // Default grade for students
  String _selectedSubject = 'Physical Education'; // Default subject for teachers
  String _errorMessage = '';

  @override
  void dispose() {
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      
      try {
        final authService = ServiceLocator.getAuthService(context);
        final firestoreService = ServiceLocator.getFirestoreService(context);
        
        // Register user with Firebase Auth
        final userCredential = await authService.registerWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          isStudent: _isStudent,
          gradeOrSubject: _isStudent ? _selectedGrade : _selectedSubject,
        );
        
        // Store additional user data in Firestore
        await firestoreService.storeUserData(
          uid: userCredential.user!.uid,
          email: _emailController.text.trim(),
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          isStudent: _isStudent,
          gradeOrSubject: _isStudent ? _selectedGrade : _selectedSubject,
        );
        
        // Navigate to login screen after successful registration
        if (mounted) {
          context.go(AppConstants.loginRoute);
        }
      } on FirebaseAuthException catch (e) {
        final authService = ServiceLocator.getAuthService(context);
        setState(() {
          _errorMessage = authService.getErrorMessage(e);
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred during registration. Please try again.';
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
                      child: Text(
                        'logo',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  
                  // Registration Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with close button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  context.go(AppConstants.loginRoute);
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          
                          // Error message
                          if (_errorMessage.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage,
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          
                          // Toggle between student and teacher
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isStudent = true;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _isStudent ? AppTheme.primaryColor : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Student',
                                        style: TextStyle(
                                          color: _isStudent ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isStudent = false;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: !_isStudent ? AppTheme.primaryColor : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Teacher',
                                        style: TextStyle(
                                          color: !_isStudent ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          
                          // Password Field
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Name Field
                          const Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Phone Field (Optional)
                          Row(
                            children: [
                              const Text(
                                'Phone Number',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '(Optional)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            // No validator since it's optional
                          ),
                          const SizedBox(height: 16),
                          
                          // Email Field
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Grade Field (for students) or Subject Field (for teachers)
                          Text(
                            _isStudent ? 'Grade' : 'Subject',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _isStudent ? _selectedGrade : _selectedSubject,
                                isExpanded: true,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                borderRadius: BorderRadius.circular(8),
                                items: _isStudent
                                    ? ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5', 'Grade 6', 
                                       'Grade 7', 'Grade 8', 'Grade 9', 'Grade 10', 'Grade 11', 'Grade 12'].map((String grade) {
                                        return DropdownMenuItem<String>(
                                          value: grade,
                                          child: Text(grade),
                                        );
                                      }).toList()
                                    : ['Physical Education', 'Team Coach', 'Math', 'English', 'Science', 'I&S', 'Design', 'Arts', 'Language'].map((String subject) {
                                        return DropdownMenuItem<String>(
                                          value: subject,
                                          child: Text(subject),
                                        );
                                      }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    if (_isStudent) {
                                      _selectedGrade = newValue!;
                                    } else {
                                      _selectedSubject = newValue!;
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
