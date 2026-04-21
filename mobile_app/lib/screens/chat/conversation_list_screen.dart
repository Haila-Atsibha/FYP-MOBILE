import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:mobile_app/screens/chat/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  late Future<List<Conversation>> _conversationsFuture;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  void _loadConversations() {
    _conversationsFuture = context.read<ApiService>().getConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => _loadConversations());
        },
        child: FutureBuilder<List<Conversation>>(
          future: _conversationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Secure Messaging', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mail_outline, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      'No messages to show yet',
                      style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            }

            final conversations = snapshot.data!;
            return ListView.separated(
              itemCount: conversations.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return ListTile(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(conversation: conversation),
                      ),
                    );
                    _loadConversations(); // Refresh on return
                    setState(() {});
                  },
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.accentColor.withOpacity(0.1),
                    child: Text(
                      conversation.partnerName[0].toUpperCase(),
                      style: const TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(conversation.partnerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (conversation.lastMessageTime != null)
                        Text(
                          DateFormat.Hm().format(conversation.lastMessageTime!),
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${conversation.serviceTitle} (${conversation.bookingStatus})',
                        style: TextStyle(fontSize: 12, color: AppTheme.primaryColor.withOpacity(0.7)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        conversation.lastMessage ?? 'No messages yet',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
