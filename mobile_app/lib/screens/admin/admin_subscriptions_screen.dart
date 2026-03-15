import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:provider/provider.dart';

class AdminSubscriptionsScreen extends StatefulWidget {
  const AdminSubscriptionsScreen({super.key});

  @override
  State<AdminSubscriptionsScreen> createState() => _AdminSubscriptionsScreenState();
}

class _AdminSubscriptionsScreenState extends State<AdminSubscriptionsScreen> {
  late Future<AdminSubscriptionData> _subFuture;

  @override
  void initState() {
    super.initState();
    _loadSubs();
  }

  void _loadSubs() {
    setState(() {
      _subFuture = context.read<ApiService>().getAdminSubscriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscriptions & Revenue')),
      body: FutureBuilder<AdminSubscriptionData>(
        future: _subFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text('Error fetching data:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(snapshot.error.toString(), textAlign: TextAlign.center),
                  ),
                  ElevatedButton(onPressed: _loadSubs, child: const Text('Retry')),
                ],
              ),
            );
          }
          final data = snapshot.data!;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(data),
                const SizedBox(height: 24),
                const Text('Recent Payments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.history.length,
                  itemBuilder: (context, index) {
                    final payment = data.history[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.payment)),
                        title: Text(payment.providerName),
                        subtitle: Text(payment.date.toLocal().toString().split(' ')[0]),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'ETB ${payment.amount.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                            Text(
                              payment.status.toUpperCase(),
                              style: TextStyle(fontSize: 10, color: payment.status.toLowerCase() == 'success' ? Colors.green : Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(AdminSubscriptionData data) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            'Monthly Revenue',
            'ETB ${data.monthlyRevenue.toStringAsFixed(0)}',
            Icons.monetization_on,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            'Active Premium',
            data.activePremium.toString(),
            Icons.star,
            Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
