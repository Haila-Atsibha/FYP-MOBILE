import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class AdminCategoryProvidersScreen extends StatefulWidget {
  final Category category;

  const AdminCategoryProvidersScreen({super.key, required this.category});

  @override
  State<AdminCategoryProvidersScreen> createState() => _AdminCategoryProvidersScreenState();
}

class _AdminCategoryProvidersScreenState extends State<AdminCategoryProvidersScreen> {
  late Future<List<TopProvider>> _providersFuture;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  void _loadProviders() {
    setState(() {
      _providersFuture = context.read<ApiService>().getProviders(categoryId: widget.category.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.providersInCategory(widget.category.name) ?? '${widget.category.name} Providers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProviders,
          ),
        ],
      ),
      body: FutureBuilder<List<TopProvider>>(
        future: _providersFuture,
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
                  Text(l10n?.errorText(snapshot.error.toString()) ?? 'Error: ${snapshot.error}'),
                  ElevatedButton(onPressed: _loadProviders, child: Text(l10n?.retry ?? 'Retry')),
                ],
              ),
            );
          }
          final providers = snapshot.data ?? [];
          if (providers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    l10n?.noProvidersFoundInCategory ?? 'No providers found in this category.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: providers.length,
            itemBuilder: (context, index) {
              final provider = providers[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: provider.profileImageUrl != null
                        ? NetworkImage(provider.profileImageUrl!)
                        : null,
                    child: provider.profileImageUrl == null
                        ? Text(provider.name[0].toUpperCase(), style: const TextStyle(fontSize: 20))
                        : null,
                  ),
                  title: Text(
                    provider.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            l10n?.ratingJobsCount(provider.averageRating.toStringAsFixed(1), provider.completedJobs.toString()) ?? '${provider.averageRating.toStringAsFixed(1)} • ${provider.completedJobs} jobs',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      if (provider.bio != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          provider.bio!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ],
                  ),
                  isThreeLine: provider.bio != null,
                  onTap: () {
                    // Logic to view full provider profile could go here
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
