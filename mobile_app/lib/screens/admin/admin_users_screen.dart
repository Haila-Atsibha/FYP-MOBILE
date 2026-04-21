import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'full_screen_image_viewer.dart';

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
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            action: SnackBarAction(
              label: 'Copy URL',
              onPressed: () {
                // You would typically use Clipboard.setData here
              },
            ),
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: const Icon(Icons.folder_shared, color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text('User Documents', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (user.nationalIdUrl != null)
                      _buildDocItem(
                        'National ID',
                        user.nationalIdUrl!,
                        Icons.badge,
                        Colors.blue,
                      ),
                    if (user.verificationSelfieUrl != null)
                      _buildDocItem(
                        'Verification Selfie',
                        user.verificationSelfieUrl!,
                        Icons.face,
                        Colors.green,
                      ),
                    if (user.role == 'provider' && user.educationalDocuments != null && user.educationalDocuments!.isNotEmpty) ...[
                      const Divider(height: 32),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Educational Documents',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...user.educationalDocuments!.map((doc) => _buildDocItem(
                        doc['name'] ?? 'Document',
                        doc['url'],
                        Icons.description,
                        Colors.orange,
                      )),
                    ],
                    if (user.nationalIdUrl == null && 
                        user.verificationSelfieUrl == null && 
                        (user.role != 'provider' || user.educationalDocuments == null || user.educationalDocuments!.isEmpty))
                      const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.no_accounts_outlined, size: 48, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('No documents uploaded for this user.', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  bool _isPdf(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    return uri.path.toLowerCase().endsWith('.pdf') || url.toLowerCase().contains('.pdf?');
  }

  Widget _buildDocItem(String title, String url, IconData icon, Color color) {
    final isPdfFile = _isPdf(url);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isPdfFile ? Colors.red : color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(isPdfFile ? Icons.picture_as_pdf : icon, color: isPdfFile ? Colors.red : color),
              ),
              title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(
                url.split('/').last.split('?').first,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: Text(isPdfFile ? 'Open PDF' : 'View In-App'),
                      onPressed: () {
                        if (isPdfFile) {
                          _openUrl(url);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullScreenImageViewer(imageUrl: url, tag: url),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.download_outlined, size: 18),
                      label: const Text('Download'),
                      onPressed: () => _openUrl(url),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
