import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class AdminComplaintsScreen extends StatefulWidget {
  const AdminComplaintsScreen({super.key});

  @override
  State<AdminComplaintsScreen> createState() => _AdminComplaintsScreenState();
}

class _AdminComplaintsScreenState extends State<AdminComplaintsScreen> {
  late Future<List<Complaint>> _complaintsFuture;

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  void _loadComplaints() {
    setState(() {
      _complaintsFuture = context.read<ApiService>().getAdminComplaints();
    });
  }

  void _showReplyDialog(Complaint complaint) {
    final l10n = AppLocalizations.of(context);
    final replyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n?.replyToComplaint(complaint.subject) ?? 'Reply to: ${complaint.subject}'),
        content: SingleChildScrollView(
          child: TextField(
            controller: replyController,
            maxLines: 3,
            decoration: InputDecoration(hintText: l10n?.typeReplyHere ?? 'Type your reply here...'),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n?.cancel ?? 'Cancel')),
          TextButton(
            onPressed: () async {
              if (replyController.text.isEmpty) return;
              try {
                await context.read<ApiService>().replyToComplaint(complaint.id, replyController.text);
                if (mounted) {
                   Navigator.pop(context);
                   _loadComplaints();
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n?.replySent ?? 'Reply sent!')));
                }
              } catch (e) {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n?.errorText(e.toString()) ?? 'Error: $e')));
              }
            },
            child: Text(l10n?.sendReply ?? 'Send Reply'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.complaintReportTitle ?? 'Complaints'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadComplaints,
          ),
        ],
      ),
      body: FutureBuilder<List<Complaint>>(
        future: _complaintsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(l10n?.errorText(snapshot.error.toString()) ?? 'Error: ${snapshot.error}'));
          }
          final complaints = snapshot.data ?? [];
          if (complaints.isEmpty) {
            return Center(child: Text(l10n?.complaintHistoryNoComplaints ?? 'No complaints found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaint = complaints[index];
              final hasReply = complaint.adminReply != null;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              complaint.subject,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          _buildPriorityBadge(complaint.priority),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(complaint.description),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n?.byUser(complaint.userName ?? '') ?? 'By: ${complaint.userName}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                          Text(
                            complaint.status.toUpperCase(),
                            style: TextStyle(
                              color: complaint.status.toLowerCase() == 'open' ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      if (hasReply) ...[
                        const Divider(height: 24),
                        Text(l10n?.adminReply ?? 'Admin Reply:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(complaint.adminReply!, style: const TextStyle(fontStyle: FontStyle.italic)),
                      ] else if (complaint.status.toLowerCase() == 'open') ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showReplyDialog(complaint),
                            icon: const Icon(Icons.reply, size: 16),
                            label: Text(l10n?.replyAndResolve ?? 'Reply & Resolve'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                              foregroundColor: AppTheme.primaryColor,
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildPriorityBadge(String priority) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'high': color = Colors.red; break;
      case 'medium': color = Colors.orange; break;
      case 'low': color = Colors.green; break;
      default: color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
