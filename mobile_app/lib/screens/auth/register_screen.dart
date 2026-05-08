import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/screens/auth/camera_screen.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String _selectedRole = 'customer';
  bool _obscurePassword = true;
  bool _isLoading = false;

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _profileImage;
  dynamic _nationalId; // Can be XFile or PlatformFile
  XFile? _verificationSelfie;
  
  // Provider-specific fields
  List<PlatformFile> _educationalDocuments = [];
  List<Category> _categories = [];
  List<int> _selectedCategories = [];
  bool _isLoadingCategories = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  String? _categoryError;

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoadingCategories = true;
      _categoryError = null;
    });
    try {
      final categories = await context.read<ApiService>().getCategories();
      if (mounted) setState(() => _categories = categories);
    } catch (e) {
      debugPrint('Failed to load categories: $e');
      if (mounted) setState(() => _categoryError = e.toString());
    } finally {
      if (mounted) setState(() => _isLoadingCategories = false);
    }
  }

  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      if (type == 'selfie') {
        final XFile? picture = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CameraScreen()),
        );
        if (picture != null) {
          setState(() {
            _verificationSelfie = picture;
          });
        }
      } else {
        final pickedFile = await _imagePicker.pickImage(source: source, imageQuality: 70);
        if (pickedFile != null) {
          setState(() {
            if (type == 'profile') _profileImage = pickedFile;
            if (type == 'id') _nationalId = pickedFile;
          });
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  Future<void> _pickDocument({bool multiple = false}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: multiple,
        withData: kIsWeb,
      );

      if (result != null) {
        setState(() {
          if (multiple) {
            _educationalDocuments.addAll(result.files);
          } else {
            _nationalId = result.files.single;
          }
        });
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking document: $e')));
    }
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_profileImage == null || _nationalId == null || _verificationSelfie == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide all verification documents (Profile Image, National ID, Selfie)')),
      );
      return;
    }

    if (_selectedRole == 'provider' && _selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Providers must select at least one service category.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await context.read<ApiService>().register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: _selectedRole,
        profileImage: _profileImage!,
        nationalId: _nationalId!,
        selfie: _verificationSelfie!,
        educationalDocs: _selectedRole == 'provider' ? _educationalDocuments : null,
        categories: _selectedRole == 'provider' ? _selectedCategories : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! Please login.')),
        );
        Navigator.pop(context); // Go back to login screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primaryColor, Color(0xFF1E293B)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create Account',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Join the QuickServe professional network',
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Basic Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'John Doe',
                      icon: Icons.person_outline,
                      validator: (v) => v!.isEmpty ? 'Please enter your full name' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      hint: 'john@example.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => !v!.contains('@') ? 'Please enter a valid email' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (v) => v!.length < 6 ? 'Password must be at least 6 characters' : null,
                    ),
                    const SizedBox(height: 24),
                    
                    const Text('Select Role', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedRole,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: 'customer', child: Text('I am a Customer')),
                            DropdownMenuItem(value: 'provider', child: Text('I am a Provider')),
                          ],
                          onChanged: (val) => setState(() => _selectedRole = val!),
                        ),
                      ),
                    ),

<<<<<<< HEAD
                  const SizedBox(height: 24),
                  const Text('Service Categories', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    'Select the services you offer',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  _isLoadingCategories 
                      ? const Center(child: CircularProgressIndicator())
                      : _categoryError != null
                          ? Text('Error loading categories: \$_categoryError', style: const TextStyle(color: Colors.red))
                          : _categories.isEmpty
                              ? const Text('No categories available.')
                              : Wrap(
=======
                    if (_selectedRole == 'provider') ...[
                      const SizedBox(height: 24),
                      const Text('Service Categories', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
                      const SizedBox(height: 12),
                      _isLoadingCategories 
                          ? const Center(child: CircularProgressIndicator())
                          : Wrap(
>>>>>>> b5fc919 (updated some features in my websites)
                              spacing: 8,
                              runSpacing: 8,
                              children: _categories.map((cat) {
                                final isSelected = _selectedCategories.contains(cat.id);
                                return FilterChip(
                                  label: Text(cat.name),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) _selectedCategories.add(cat.id);
                                      else _selectedCategories.remove(cat.id);
                                    });
                                  },
                                  selectedColor: AppTheme.accentColor.withOpacity(0.2),
                                  checkmarkColor: AppTheme.primaryColor,
                                );
                              }).toList(),
                            ),
                    ],

                    const SizedBox(height: 32),
                    const Text('Verification Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                    const SizedBox(height: 16),
                    _buildFileUploadRow(
                      label: 'Profile Photo',
                      file: _profileImage,
                      onTap: () => _pickImage(ImageSource.gallery, 'profile'),
                      icon: Icons.camera_alt_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildFileUploadRow(
                      label: 'National ID Card',
                      file: _nationalId,
                      onTap: _pickDocument,
                      icon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Face Verification', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _pickImage(ImageSource.camera, 'selfie'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.accentColor.withOpacity(0.2), width: 1.5, style: BorderStyle.solid),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.face, size: 40, color: AppTheme.accentColor),
                            const SizedBox(height: 8),
                            Text(
                              _verificationSelfie == null ? 'Capture Verification Selfie' : 'Selfie Captured Successfully',
                              style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (_selectedRole == 'provider') ...[
                      const SizedBox(height: 24),
                      _buildFileUploadRow(
                        label: 'Educational / Certifications',
                        file: _educationalDocuments.isEmpty ? null : _educationalDocuments.first,
                        onTap: () => _pickDocument(multiple: true),
                        icon: Icons.school_outlined,
                        trailing: _educationalDocuments.length > 1 ? Text('+${_educationalDocuments.length - 1} more') : null,
                      ),
                    ],

                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Complete Registration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Already have an account? Login here', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppTheme.primaryColor.withOpacity(0.5)),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadRow({
    required String label,
    required dynamic file,
    required VoidCallback onTap,
    required IconData icon,
    Widget? trailing,
  }) {
    final bool uploaded = file != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: uploaded ? Colors.green.withOpacity(0.05) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: uploaded ? Colors.green.withOpacity(0.2) : Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(icon, color: uploaded ? Colors.green : AppTheme.primaryColor.withOpacity(0.5)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    uploaded ? (file is XFile ? file.name : file.name) : 'No file chosen',
                    style: TextStyle(color: uploaded ? Colors.black87 : Colors.grey, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (trailing != null) trailing,
                if (uploaded) const Icon(Icons.check_circle, color: Colors.green, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
