import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class ProviderSubscriptionsScreen extends StatefulWidget {
  const ProviderSubscriptionsScreen({super.key});

  @override
  State<ProviderSubscriptionsScreen> createState() => _ProviderSubscriptionsScreenState();
}

class _ProviderSubscriptionsScreenState extends State<ProviderSubscriptionsScreen> {
  late Future<List<PaymentTransaction>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = context.read<ApiService>().getMySubscriptionHistory();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.subscriptionHistory ?? 'Subscription History'),
      ),
      body: FutureBuilder<List<PaymentTransaction>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(l10n?.noSubscriptionPaymentsFound ?? 'No subscription payments found.'));
          }

          final history = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final tx = history[index];
              final isSuccess = tx.status == 'success';
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isSuccess ? Colors.green.shade100 : Colors.red.shade100,
                  child: Icon(
                    isSuccess ? Icons.check : Icons.close,
                    color: isSuccess ? Colors.green : Colors.red,
                  ),
                ),
                title: Text(l10n?.etbAmount(tx.amount.toStringAsFixed(2)) ?? 'ETB ${tx.amount.toStringAsFixed(2)}'),
                subtitle: Text('${l10n?.subscriptionRef(tx.txRef) ?? "Ref: " + tx.txRef}\n${tx.createdAt.toLocal().toString().split('.')[0]}'),
                isThreeLine: true,
                trailing: Text(
                  tx.status.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSuccess ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
