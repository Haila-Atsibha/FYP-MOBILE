import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class ProviderBookingsScreen extends StatefulWidget {
  const ProviderBookingsScreen({super.key});

  @override
  State<ProviderBookingsScreen> createState() => _ProviderBookingsScreenState();
}

class _ProviderBookingsScreenState extends State<ProviderBookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Booking>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBookings();
  }

  void _loadBookings() {
    setState(() {
      _bookingsFuture = context.read<ApiService>().getProviderBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.bookMyBookings ?? 'My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: l10n?.tabPending ?? 'Pending'),
            Tab(text: l10n?.tabActive ?? 'Active'),
            Tab(text: l10n?.tabHistory ?? 'History'),
          ],
        ),
      ),
      body: FutureBuilder<List<Booking>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final allBookings = snapshot.data ?? [];
          
          return TabBarView(
            controller: _tabController,
            children: [
              _buildBookingList(allBookings.where((b) => b.status == 'pending').toList()),
              _buildBookingList(allBookings.where((b) => b.status == 'accepted').toList()),
              _buildBookingList(allBookings.where((b) => ['completed', 'rejected', 'cancelled'].contains(b.status)).toList()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookingList(List<Booking> bookings) {
    if (bookings.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)?.bookNoBookings ?? 'No bookings found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.title ?? (l10n?.bookServiceDefault ?? 'Service'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _buildStatusBadge(booking.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(l10n?.bookingCustomerName(booking.providerName ?? "N/A") ?? 'Customer: ${booking.providerName ?? "N/A"}'), // Using providerName as a placeholder for customer_name if not in model
            const SizedBox(height: 4),
            Text(l10n?.bookingPrice(booking.totalPrice?.toStringAsFixed(0) ?? "0") ?? 'Price: ETB ${booking.totalPrice?.toStringAsFixed(0) ?? "0"}'),
            if (booking.scheduledDate != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                  const SizedBox(width: 6),
                  Text('Scheduled: ${booking.scheduledDate}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  if (booking.scheduledTime != null) ...[
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time, size: 16, color: Colors.blue),
                    const SizedBox(width: 6),
                    Text(booking.scheduledTime!.substring(0, 5), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  ]
                ],
              ),
            ],
            const SizedBox(height: 8),
            if (booking.description != null && booking.description!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(l10n?.bookingNote(booking.description!) ?? 'Note: ${booking.description}', style: const TextStyle(fontStyle: FontStyle.italic)),
              ),
            const SizedBox(height: 16),
            _buildActions(booking),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'pending': color = Colors.orange; break;
      case 'accepted': color = Colors.blue; break;
      case 'completed': color = Colors.green; break;
      case 'rejected':
      case 'cancelled': color = Colors.red; break;
      default: color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getLocalizedStatus(status).toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  String _getLocalizedStatus(String status) {
    final l10n = AppLocalizations.of(context);
    switch (status) {
      case 'pending': return l10n?.bookStatusPending ?? 'Pending';
      case 'accepted': return l10n?.bookStatusAccepted ?? 'Accepted';
      case 'completed': return l10n?.bookStatusCompleted ?? 'Completed';
      case 'rejected': return l10n?.bookStatusRejected ?? 'Rejected';
      case 'cancelled': return l10n?.bookStatusCancelled ?? 'Cancelled';
      default: return status;
    }
  }

  Widget _buildActions(Booking booking) {
    final l10n = AppLocalizations.of(context);
    if (booking.status == 'pending') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _updateStatus(booking.id, 'rejected'),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n?.actionReject ?? 'Reject'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _updateStatus(booking.id, 'accepted'),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
              child: Text(l10n?.actionAccept ?? 'Accept'),
            ),
          ),
        ],
      );
    } else if (booking.status == 'accepted') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _updateStatus(booking.id, 'completed'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: Text(l10n?.actionMarkCompleted ?? 'Mark as Completed'),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _updateStatus(int bookingId, String status) async {
    try {
      final success = await context.read<ApiService>().updateBookingStatus(bookingId, status);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.bookingStatusUpdateSuccess(status) ?? 'Booking $status successfully')),
        );
        _loadBookings();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
