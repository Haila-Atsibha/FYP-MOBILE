import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:provider/provider.dart';

class ProviderReviewsScreen extends StatefulWidget {
  const ProviderReviewsScreen({super.key});

  @override
  State<ProviderReviewsScreen> createState() => _ProviderReviewsScreenState();
}

class _ProviderReviewsScreenState extends State<ProviderReviewsScreen> {
  late Future<List<Review>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  void _loadReviews() {
    setState(() {
      _reviewsFuture = context.read<ApiService>().getProviderReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Customer Reviews'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Review>>(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final reviews = snapshot.data ?? [];
          
          return RefreshIndicator(
            onRefresh: () async => _loadReviews(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customer Reviews',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'See what your customers are saying about your services',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 32),
                  _buildOverallRating(reviews),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Feedback',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.sort, size: 18),
                        label: const Text('Sort: Newest First'),
                        style: TextButton.styleFrom(foregroundColor: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (reviews.isEmpty)
                    const Center(child: Text('No reviews yet.'))
                  else
                    ...reviews.map((r) => _buildReviewCard(r)).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverallRating(List<Review> reviews) {
    final double avg = reviews.isEmpty 
        ? 0.0 
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
    
    final Map<int, int> counts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var r in reviews) {
      int rounded = r.rating.round();
      if (counts.containsKey(rounded)) counts[rounded] = counts[rounded]! + 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Overall Rating', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    avg.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Based on ${reviews.length} total reviews',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 3,
              child: Column(
                children: [5, 4, 3, 2, 1].map((star) {
                  final double percent = reviews.isEmpty ? 0 : (counts[star]! / reviews.length);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Text('$star', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percent,
                              backgroundColor: Colors.grey.shade100,
                              color: Colors.amber,
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 35,
                          child: Text(
                            '${(percent * 100).toInt()}%',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewCard(Review review) {
    String formattedDate = "${review.createdAt.month}/${review.createdAt.day}/${review.createdAt.year}";
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formattedDate, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Row(
                children: List.generate(5, (i) => Icon(
                  Icons.star,
                  size: 14,
                  color: i < review.rating ? Colors.amber : Colors.grey.shade200,
                )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"${review.comment ?? ""}"',
            style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Text(
                  review.customerName?[0].toUpperCase() ?? 'U',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                review.customerName ?? 'Verified Customer',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Booked:',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          Text(
            review.serviceTitle ?? 'Professional Service',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
