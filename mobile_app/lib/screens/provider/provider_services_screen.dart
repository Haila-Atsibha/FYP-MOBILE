import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/screens/provider/service_form_screen.dart';

class ProviderServicesScreen extends StatefulWidget {
  const ProviderServicesScreen({super.key});

  @override
  State<ProviderServicesScreen> createState() => _ProviderServicesScreenState();
}

class _ProviderServicesScreenState extends State<ProviderServicesScreen> {
  late Future<List<Service>> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  void _loadServices() {
    setState(() {
      _servicesFuture = context.read<ApiService>().getMyProviderServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ServiceFormScreen()),
              );
              if (result == true) {
                _loadServices();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadServices();
          await _servicesFuture;
        },
        child: FutureBuilder<List<Service>>(
          future: _servicesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: \${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.build_circle_outlined, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No services found.', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ServiceFormScreen()),
                        );
                        if (result == true) {
                          _loadServices();
                        }
                      },
                      child: const Text('Add a Service', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }

            final services = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: services.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final service = services[index];
                return Card(
                  elevation: 2,
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
                                service.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Text(
                              'ETB ${service.price.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (service.categoryName != null)
                          Chip(
                            label: Text(service.categoryName!, style: const TextStyle(fontSize: 12)),
                            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                            side: BorderSide.none,
                            visualDensity: VisualDensity.compact,
                          ),
                        const SizedBox(height: 8),
                        if (service.description != null)
                          Text(service.description!, style: TextStyle(color: Colors.grey.shade700)),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => ServiceFormScreen(service: service)),
                              );
                              if (result == true) {
                                _loadServices();
                              }
                            },
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text('Edit Service'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primaryColor,
                              side: const BorderSide(color: AppTheme.primaryColor),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
