import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/screens/complaint/complaints_history_screen.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _priority = 'medium';
  bool _submitting = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      await context.read<ApiService>().submitComplaint(
            subject: _subjectController.text.trim(),
            description: _descriptionController.text.trim(),
            priority: _priority,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.complaintSubmitSuccess)),
        );
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComplaintsHistoryScreen()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.complaintSubmitError}$e')),
        );
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.complaintReportTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: AppLocalizations.of(context)!.complaintHistoryTooltip,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ComplaintsHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.complaintHelpImprove,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.complaintHelpDescription,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.complaintSubject,
                  hintText: AppLocalizations.of(context)!.complaintSubjectHint,
                  prefixIcon: const Icon(Icons.subject),
                ),
                validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.complaintSubjectRequired : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.complaintPriority,
                  prefixIcon: const Icon(Icons.priority_high),
                ),
                items: [
                  DropdownMenuItem(value: 'low', child: Text(AppLocalizations.of(context)!.complaintPriorityLow)),
                  DropdownMenuItem(value: 'medium', child: Text(AppLocalizations.of(context)!.complaintPriorityMedium)),
                  DropdownMenuItem(value: 'high', child: Text(AppLocalizations.of(context)!.complaintPriorityHigh)),
                ],
                onChanged: (value) => setState(() => _priority = value!),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.complaintDescription,
                  hintText: AppLocalizations.of(context)!.complaintDescriptionHint,
                  prefixIcon: const Icon(Icons.description_outlined),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.complaintDescriptionRequired : null,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _submitting
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(AppLocalizations.of(context)!.complaintSubmitButton, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
