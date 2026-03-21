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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.flash_on, color: AppTheme.primaryColor, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'QuickServe Services',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Register',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Join QuickServe and start your journey',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                const SizedBox(height: 32),
                
                // Form Fields
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'John Doe',
                  validator: (v) => v!.isEmpty ? 'Please enter your full name' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'john@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => !v!.contains('@') ? 'Please enter a valid email' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: '••••••••',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) => v!.length < 6 ? 'Password must be at least 6 characters' : null,
                ),
                const SizedBox(height: 16),

                // Role Selection
                const Text('Role', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRole,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'customer', child: Text('Customer')),
                        DropdownMenuItem(value: 'provider', child: Text('Provider/Professional')),
                      ],
                      onChanged: (val) => setState(() => _selectedRole = val!),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                const Text('Verification Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // File Uploads
                _buildFileUploadRow(
                  label: 'Profile Image',
                  file: _profileImage,
                  onTap: () => _pickImage(ImageSource.gallery, 'profile'),
                  icon: Icons.image_outlined,
                ),
                const SizedBox(height: 16),
                _buildFileUploadRow(
                  label: 'National ID',
                  file: _nationalId,
                  onTap: _pickDocument,
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 16),
                
                // Selfie Camera
                const Text('Selfie Verification', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _pickImage(ImageSource.camera, 'selfie'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3), width: 1.5, style: BorderStyle.solid),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.camera_alt, color: AppTheme.primaryColor, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          _verificationSelfie == null ? 'Start Camera\nCapture Photo' : 'Selfie Captured',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),

                if (_selectedRole == 'provider') ...[
                  const SizedBox(height: 24),
                  const Text('Educational Documents', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    'Upload certifications, degrees, or other relevant files (Multiple allowed)',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _pickDocument(multiple: true),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.file_copy_outlined, color: Colors.grey.shade600),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _educationalDocuments.isEmpty 
                                  ? 'No file chosen' 
                                  : '${_educationalDocuments.length} file(s) chosen',
                              style: TextStyle(
                                  color: _educationalDocuments.isEmpty ? Colors.grey.shade500 : Colors.black87),
                            ),
                          ),
                          if (_educationalDocuments.isNotEmpty)
                            const Icon(Icons.check_circle, color: Colors.green, size: 20),
                        ],
                      ),
                    ),
                  ),
                  if (_educationalDocuments.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _educationalDocuments.map((doc) => Chip(
                        label: Text(doc.name, style: const TextStyle(fontSize: 12)),
                        onDeleted: () => setState(() => _educationalDocuments.remove(doc)),
                        deleteIcon: const Icon(Icons.close, size: 16),
                      )).toList(),
                    ),
                  ],

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
                              spacing: 8,
                              runSpacing: 8,
                              children: _categories.map((cat) {
                                final isSelected = _selectedCategories.contains(cat.id);
                                return FilterChip(
                                  label: Text(cat.name),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedCategories.add(cat.id);
                                      } else {
                                        _selectedCategories.remove(cat.id);
                                      }
                                    });
                                  },
                                  selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                                  checkmarkColor: AppTheme.primaryColor,
                                );
                              }).toList(),
                            ),
                ],

                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Complete Registration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Already have an account? Login here', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryColor),
            ),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.grey.shade600),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    file != null ? file.name : 'No file chosen',
                    style: TextStyle(color: file != null ? Colors.black87 : Colors.grey.shade500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (file != null) const Icon(Icons.check_circle, color: Colors.green, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
