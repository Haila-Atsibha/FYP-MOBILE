import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class ServiceFormScreen extends StatefulWidget {
  final Service? service;

  const ServiceFormScreen({super.key, this.service});

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  
  bool _isLoading = false;
  int? _selectedCategoryId;
  List<Category> _categories = [];
  bool _isLoadingCategories = false;

  bool get _isEditing => widget.service != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.service!.title;
      _descriptionController.text = widget.service!.description ?? '';
      _priceController.text = widget.service!.price.toString();
      _selectedCategoryId = widget.service!.categoryId;
    } else {
      _fetchCategories();
    }
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoadingCategories = true);
    try {
      final categories = await context.read<ApiService>().getCategories();
      if (mounted) setState(() => _categories = categories);
    } catch (e) {
      debugPrint('Failed to load categories: \$e');
    } finally {
      if (mounted) setState(() => _isLoadingCategories = false);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_isEditing && _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.pleaseSelectCategory ?? 'Please select a category')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final double price = double.parse(_priceController.text);
      if (_isEditing) {
        await context.read<ApiService>().updateService(
          widget.service!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          price: price,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)?.serviceUpdatedSuccess ?? 'Service updated successfully')),
          );
          Navigator.pop(context, true);
        }
      } else {
        await context.read<ApiService>().createService(
          categoryId: _selectedCategoryId!,
          title: _titleController.text,
          description: _descriptionController.text,
          price: price,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)?.serviceCreatedSuccess ?? 'Service created successfully')),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: \$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? (l10n?.editService ?? 'Edit Service') : (l10n?.addService ?? 'Add Service')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: l10n?.serviceTitle ?? 'Service Title',
                  border: const OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? (l10n?.pleaseEnterTitle ?? 'Please enter a title') : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n?.priceETB ?? 'Price (ETB)',
                  border: const OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return l10n?.pleaseEnterPrice ?? 'Please enter a price';
                  if (double.tryParse(val) == null) return l10n?.pleaseEnterValidNumber ?? 'Please enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (!_isEditing) ...[
                _isLoadingCategories
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: l10n?.serviceCategory ?? 'Category',
                          border: const OutlineInputBorder(),
                        ),
                        value: _selectedCategoryId,
                        items: _categories.map((cat) {
                          return DropdownMenuItem<int>(
                            value: cat.id,
                            child: Text(cat.name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => _selectedCategoryId = val);
                        },
                        validator: (val) => val == null ? (l10n?.pleaseSelectCategory ?? 'Please select a category') : null,
                      ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: l10n?.serviceDescription ?? 'Description',
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (val) => val == null || val.isEmpty ? (l10n?.pleaseEnterDescription ?? 'Please enter a description') : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(
                          _isEditing ? (l10n?.saveChanges ?? 'Save Changes') : (l10n?.createService ?? 'Create Service'),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
