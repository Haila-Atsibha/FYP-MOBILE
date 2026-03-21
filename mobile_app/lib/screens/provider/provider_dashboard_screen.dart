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
import 'package:mobile_app/screens/provider/provider_services_screen.dart';
import 'package:mobile_app/screens/provider/service_form_screen.dart';
import 'package:mobile_app/screens/chat/conversation_list_screen.dart';
import 'package:mobile_app/screens/complaint/complaint_screen.dart';
import 'package:mobile_app/screens/provider/provider_subscriptions_screen.dart';
import 'package:mobile_app/widgets/platform_rating_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderDashboardScreen extends StatefulWidget {
  const ProviderDashboardScreen({super.key});

  @override
  State<ProviderDashboardScreen> createState() => _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState extends State<ProviderDashboardScreen> {
  late Future<ProviderStats> _statsFuture;
  bool _showRatingWidget = true;

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

  Future<void> _handleRenewSubscription(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      final paymentData = await context.read<ApiService>().initializeSubscriptionPayment();
      Navigator.pop(context); // close dialog

      final checkoutUrl = paymentData['checkout_url']!;
      final txRef = paymentData['tx_ref']!;

      final uri = Uri.parse(checkoutUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
        
        // Refresh stats once user returns from browser by triggering manual verification (since app is running locally)
        if (mounted) {
           showDialog(
             context: context,
             barrierDismissible: false,
             builder: (_) => const Center(child: CircularProgressIndicator()),
           );
           try {
             await context.read<ApiService>().verifySubscriptionPayment(txRef);
           } catch (e) {
             debugPrint("Verification warning (might be incomplete): $e");
           }
           if (mounted) Navigator.pop(context); // close explicit loader
        }
        
        _loadStats();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not launch payment screen')));
        }
      }
    } catch (e) {
      Navigator.pop(context); // close dialog
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
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
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ServiceFormScreen()),
                            );
                          },
                          icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                          label: const Text('Add New Service', style: TextStyle(color: Colors.white, fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_showRatingWidget)
                        PlatformRatingWidget(onClose: () => setState(() => _showRatingWidget = false)),
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
      child: Column(
        children: [
          ListTile(
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
          Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 12.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => _handleRenewSubscription(context),
                style: ElevatedButton.styleFrom(
                   backgroundColor: isActive ? Colors.green.shade700 : Colors.red.shade700,
                   foregroundColor: Colors.white,
                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                ),
                child: Text(isActive ? 'Renew Early' : 'Renew Now', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
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
              backgroundImage: user?.profileImageUrl != null
                  ? NetworkImage(user!.profileImageUrl!)
                  : null,
              child: user?.profileImageUrl == null
                  ? Text(
                      user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'P',
                      style: const TextStyle(fontSize: 24, color: AppTheme.primaryColor),
                    )
                  : null,
            ),
            decoration: const BoxDecoration(color: AppTheme.primaryColor),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.build_circle),
            title: const Text('My Services'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProviderServicesScreen()));
            },
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
            leading: const Icon(Icons.history, color: AppTheme.primaryColor),
            title: const Text('Subscription History'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProviderSubscriptionsScreen()));
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
          const Divider(),
          ListTile(
            leading: const Icon(Icons.report_problem, color: Colors.orange),
            title: const Text('Submit Complaint'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComplaintScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.star_rate, color: Colors.amber),
            title: const Text('Rate Platform'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: PlatformRatingWidget(onClose: () => Navigator.pop(context)),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
