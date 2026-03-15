import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  final String providerProfileId;

  const BookingScreen({super.key, required this.providerProfileId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool _isLoading = true;
  bool _isBooking = false;
  ProviderDetail? _providerDetail;
  int? _selectedServiceId;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  void _fetchDetails() async {
    try {
      final api = context.read<ApiService>();
      final data = await api.getProviderDetails(widget.providerProfileId);
      if (mounted) {
        setState(() {
          _providerDetail = ProviderDetail.fromJson(data);
          _isLoading = false;
          if (_providerDetail!.services.isNotEmpty) {
            _selectedServiceId = _providerDetail!.services.first.id;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading provider: $e')),
        );
        Navigator.pop(context);
      }
    }
  }

  void _confirmBooking() async {
    if (_selectedServiceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a service')),
      );
      return;
    }

    setState(() => _isBooking = true);
    try {
      final api = context.read<ApiService>();
      await api.createBooking(
        serviceId: _selectedServiceId!,
        description: _descriptionController.text.trim(),
      );
      
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Your booking has been placed successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // dialog
                  Navigator.of(context).pop(); // screen
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final provider = _providerDetail!;

    return Scaffold(
      appBar: AppBar(title: const Text('Book a Service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Provider Header
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppTheme.accentColor.withOpacity(0.1),
                  child: Text(
                    provider.name[0].toUpperCase(),
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.accentColor),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          Text(
                            ' ${provider.averageRating.toStringAsFixed(1)} Rating',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              provider.bio ?? 'Professional service provider',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            ),
            const Divider(height: 48),

            // Service Selection
            const Text(
              'Select a Service',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (provider.services.isEmpty)
              const Text('This provider has no services listed.')
            else
              ...provider.services.map((service) => RadioListTile<int>(
                value: service.id,
                groupValue: _selectedServiceId,
                title: Text(service.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('ETB ${service.price.toStringAsFixed(0)}'),
                onChanged: (val) => setState(() => _selectedServiceId = val),
                contentPadding: EdgeInsets.zero,
                activeColor: AppTheme.primaryColor,
              )),

            const SizedBox(height: 32),

            // Job Description
            const Text(
              'Tell us about the job',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe what you actually want...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                fillColor: Colors.grey.shade50,
                filled: true,
              ),
            ),

            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isBooking || _selectedServiceId == null ? null : _confirmBooking,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isBooking 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Confirm Booking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
