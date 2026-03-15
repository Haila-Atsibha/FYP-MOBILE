import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      _usersFuture = context.read<ApiService>().getAdminUsers();
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

  void _showUserDocuments(User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Documents: ${user.name}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              if (user.nationalIdUrl != null)
                ListTile(
                  leading: const Icon(Icons.badge, color: Colors.blue),
                  title: const Text('National ID'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => _openUrl(user.nationalIdUrl!),
                ),
              if (user.verificationSelfieUrl != null)
                ListTile(
                  leading: const Icon(Icons.face, color: Colors.green),
                  title: const Text('Verification Selfie'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => _openUrl(user.verificationSelfieUrl!),
                ),
              if (user.role == 'provider' && user.educationalDocuments != null && user.educationalDocuments!.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Educational Documents', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ...user.educationalDocuments!.map((doc) => ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text(doc['name'] ?? 'Document'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => _openUrl(doc['url']),
                )),
              ],
              if (user.nationalIdUrl == null && 
                  user.verificationSelfieUrl == null && 
                  (user.role != 'provider' || user.educationalDocuments == null || user.educationalDocuments!.isEmpty))
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text('No documents uploaded.')),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text('Error fetching data:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(snapshot.error.toString(), textAlign: TextAlign.center),
                  ),
                  ElevatedButton(onPressed: _loadUsers, child: const Text('Retry')),
                ],
              ),
            );
          }
          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.profileImageUrl != null ? NetworkImage(user.profileImageUrl!) : null,
                    child: user.profileImageUrl == null ? Text(user.name[0].toUpperCase()) : null,
                  ),
                  title: Text(user.name),
                  subtitle: Text('${user.email} • ${user.role}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.folder_shared_outlined, color: AppTheme.primaryColor),
                    tooltip: 'View Documents',
                    onPressed: () => _showUserDocuments(user),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'active': return Colors.green;
      case 'pending': return Colors.orange;
      case 'rejected':
      case 'banned': return Colors.red;
      default: return Colors.grey;
    }
  }
}
