import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/models/models.dart';
import 'package:provider/provider.dart';

class ProviderProfileScreen extends StatefulWidget {
  const ProviderProfileScreen({super.key});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  XFile? _selectedImage;
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await context.read<ApiService>().getProviderProfile();
      _nameController.text = profile['name'] ?? '';
      _bioController.text = profile['bio'] ?? '';
      _phoneController.text = profile['phone'] ?? '';
      _currentImageUrl = profile['profile_image_url'];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    try {
      final response = await context.read<ApiService>().updateProviderProfile(
        name: _nameController.text.trim(),
        bio: _bioController.text.trim(),
        phone: _phoneController.text.trim(),
        profileImage: _selectedImage,
      );
      if (mounted) {
        if (response.containsKey('user')) {
          final updatedUser = User.fromJson(response['user']);
          context.read<AuthProvider>().updateUser(updatedUser);
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: _selectedImage != null
                                ? (kIsWeb
                                    ? NetworkImage(_selectedImage!.path)
                                    : FileImage(File(_selectedImage!.path))) as ImageProvider
                                : (_currentImageUrl != null
                                    ? NetworkImage(_currentImageUrl!)
                                    : null),
                            child: _selectedImage == null && _currentImageUrl == null
                                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bioController,
                      decoration: const InputDecoration(labelText: 'Bio'),
                      maxLines: 4,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                        onPressed: _submit,
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Save Changes'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
