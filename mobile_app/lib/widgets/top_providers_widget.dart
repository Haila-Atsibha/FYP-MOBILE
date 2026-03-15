import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/screens/booking/booking_screen.dart';

class TopProvidersWidget extends StatefulWidget {
  const TopProvidersWidget({super.key});

  @override
  State<TopProvidersWidget> createState() => _TopProvidersWidgetState();
}

class _TopProvidersWidgetState extends State<TopProvidersWidget> {
  late Future<List<TopProvider>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<ApiService>().getTopProviders();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TopProvider>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red, fontSize: 12)),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final providers = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                'Top Rated Professionals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: providers.length,
                itemBuilder: (context, index) {
                  final provider = providers[index];
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BookingScreen(providerProfileId: provider.providerProfileId),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: AppTheme.accentColor.withOpacity(0.1),
                                child: Text(
                                  provider.name[0].toUpperCase(),
                                  style: const TextStyle(fontSize: 20, color: AppTheme.accentColor, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                provider.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                provider.category ?? 'Provider',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.star, size: 14, color: Colors.amber),
                                  Text(
                                    ' ${provider.averageRating.toStringAsFixed(1)}',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    ' (${provider.completedJobs})',
                                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
