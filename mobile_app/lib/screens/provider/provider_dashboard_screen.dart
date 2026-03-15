import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/screens/auth/login_screen.dart';

import 'package:mobile_app/screens/provider/provider_bookings_screen.dart';
import 'package:mobile_app/screens/provider/provider_reviews_screen.dart';
import 'package:mobile_app/screens/provider/provider_profile_screen.dart';
import 'package:mobile_app/screens/chat/conversation_list_screen.dart';

class ProviderDashboardScreen extends StatefulWidget {
  const ProviderDashboardScreen({super.key});

  @override
  State<ProviderDashboardScreen> createState() => _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState extends State<ProviderDashboardScreen> {
  late Future<ProviderStats> _statsFuture;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    setState(() {
      _statsFuture = context.read<ApiService>().getProviderStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context, user),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadStats();
          await _statsFuture;
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${user?.name ?? "Provider"}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              FutureBuilder<ProviderStats>(
                future: _statsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('No stats available'));
                  }

                  final stats = snapshot.data!;
                  return Column(
                    children: [
                      _buildStatsGrid(stats),
                      const SizedBox(height: 24),
                      _buildSubscriptionCard(stats),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(ProviderStats stats) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Pending', stats.pendingRequests.toString(), Icons.pending_actions, Colors.orange),
        _buildStatCard('Active', stats.activeBookings.toString(), Icons.play_arrow, Colors.blue),
        _buildStatCard('Completed', stats.completedJobs.toString(), Icons.check_circle, Colors.green),
        _buildStatCard('Earnings', 'ETB ${stats.totalEarnings.toStringAsFixed(0)}', Icons.payments, Colors.purple),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(ProviderStats stats) {
    final bool isActive = stats.subscriptionStatus == 'active';
    return Card(
      elevation: 0,
      color: isActive ? Colors.green.shade50 : Colors.red.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isActive ? Colors.green.shade100 : Colors.red.shade100),
      ),
      child: ListTile(
        leading: Icon(isActive ? Icons.verified_user : Icons.warning, color: isActive ? Colors.green : Colors.red),
        title: Text(
          isActive ? 'Active Subscription' : 'Subscription Inactive',
          style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? Colors.green.shade900 : Colors.red.shade900),
        ),
        subtitle: Text(
          stats.subscriptionExpiry != null 
            ? 'Expires on ${stats.subscriptionExpiry!.toLocal().toString().split(' ')[0]}'
            : 'No active subscription',
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, User? user) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.name ?? 'Provider'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                user?.name[0].toUpperCase() ?? 'P',
                style: const TextStyle(fontSize: 24, color: AppTheme.primaryColor),
              ),
            ),
            decoration: const BoxDecoration(color: AppTheme.primaryColor),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Bookings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProviderBookingsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Messages'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ConversationListScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Reviews'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProviderReviewsScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProviderProfileScreen()));
            },
          ),
        ],
      ),
    );
  }
}
