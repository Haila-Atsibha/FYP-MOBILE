import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminVerificationScreen extends StatefulWidget {
  const AdminVerificationScreen({super.key});

  @override
  State<AdminVerificationScreen> createState() => _AdminVerificationScreenState();
}

class _AdminVerificationScreenState extends State<AdminVerificationScreen> {
  late Future<List<VerificationUser>> _verificationsFuture;

  @override
  void initState() {
    super.initState();
    _loadVerifications();
  }

  void _loadVerifications() {
    setState(() {
      _verificationsFuture = context.read<ApiService>().getPendingVerifications();
    });
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open document')),
        );
      }
    }
  }

  void _handleApprove(String id) async {
    try {
      await context.read<ApiService>().approveProvider(id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Provider approved successfully')));
      _loadVerifications();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _handleReject(String id) async {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Provider'),
        content: SingleChildScrollView(
          child: TextField(
            controller: reasonController,
            decoration: const InputDecoration(hintText: 'Reason for rejection'),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (reasonController.text.isEmpty) return;
              Navigator.pop(context);
              try {
                await context.read<ApiService>().rejectProvider(id, reasonController.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Provider rejected')));
                _loadVerifications();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            child: const Text('Reject', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provider Verifications')),
      body: FutureBuilder<List<VerificationUser>>(
        future: _verificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return const Center(child: Text('No pending verifications.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundImage: user.profileImageUrl != null ? NetworkImage(user.profileImageUrl!) : null,
                          child: user.profileImageUrl == null ? Text(user.name[0]) : null,
                        ),
                        title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(user.email),
                      ),
                      const Divider(),
                      const Text('Identity Documents', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (user.nationalIdUrl != null)
                             _buildDocPreview('National ID', user.nationalIdUrl!),
                          const SizedBox(width: 8),
                          if (user.selfieUrl != null)
                             _buildDocPreview('Selfie', user.selfieUrl!),
                        ],
                      ),
                      if (user.educationalDocuments != null && user.educationalDocuments!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text('Educational Documents', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ...user.educationalDocuments!.map((doc) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                          title: Text(doc['name'] ?? 'Document', style: const TextStyle(fontSize: 14)),
                          trailing: IconButton(
                            icon: const Icon(Icons.open_in_new),
                            onPressed: () => _openUrl(doc['url']),
                          ),
                        )),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              onPressed: () => _handleApprove(user.id),
                              child: const Text('Approve'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                              onPressed: () => _handleReject(user.id),
                              child: const Text('Reject'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDocPreview(String label, String url) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _openUrl(url),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.remove_red_eye_outlined, color: Colors.blue),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 10)),
              const Text('View', style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
