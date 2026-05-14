import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  late Future<List<Booking>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() {
    _bookingsFuture = context.read<ApiService>().getMyBookings();
  }

  void _cancelBooking(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.bookCancelBooking),
        content: Text(AppLocalizations.of(context)!.bookCancelConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocalizations.of(context)!.bookNo)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(AppLocalizations.of(context)!.bookYesCancel, style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await context.read<ApiService>().updateBookingStatus(id, 'cancelled');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.bookCancelledMessage)));
          setState(() {
            _loadBookings();
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.bookMyBookings)),
      body: FutureBuilder<List<Booking>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const SizedBox.shrink();
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.bookNoBookings,
                    style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }

          final bookings = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final dateStr = DateFormat('MMM dd, yyyy, hh:mm a').format(booking.createdAt.toLocal());

              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              booking.title ?? AppLocalizations.of(context)!.bookServiceDefault,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          _buildStatusBadge(context, booking.status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${AppLocalizations.of(context)!.bookProviderPrefix}${booking.providerName ?? AppLocalizations.of(context)!.bookDefaultProviderName}',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 6),
                          Text(dateStr, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ETB ${booking.totalPrice?.toStringAsFixed(0) ?? "0"}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                          ),
                          if (booking.status.toLowerCase() == 'pending')
                            TextButton(
                              onPressed: () => _cancelBooking(booking.id),
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: Text(AppLocalizations.of(context)!.bookCancelBooking),
                            )
                          else if (booking.status.toLowerCase() == 'completed')
                            booking.isReviewed
                                ? Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                                      SizedBox(width: 4),
                                      Text(AppLocalizations.of(context)!.bookReviewed, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                : ElevatedButton(
                                    onPressed: () => _showReviewDialog(booking),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      minimumSize: Size.zero,
                                    ),
                                    child: Text(AppLocalizations.of(context)!.bookRateReview, style: TextStyle(fontSize: 12)),
                                  ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showReviewDialog(Booking booking) {
    double _rating = 5.0;
    final _commentController = TextEditingController();
    bool _isSubmitting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.bookRateReview),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${AppLocalizations.of(context)!.bookReviewPromptPrefix}${booking.providerName ?? AppLocalizations.of(context)!.bookDefaultProviderName}${AppLocalizations.of(context)!.bookReviewPromptSuffix}'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                          onPressed: () => setDialogState(() => _rating = index + 1.0),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.bookReviewComments,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isSubmitting ? null : () => Navigator.pop(dialogContext),
                  child: Text(AppLocalizations.of(context)!.bookCancel),
                ),
                ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          setDialogState(() => _isSubmitting = true);
                          try {
                            await context.read<ApiService>().submitReview(
                                  bookingId: booking.id,
                                  rating: _rating,
                                  comment: _commentController.text.trim(),
                                );
                            if (mounted) {
                              Navigator.pop(dialogContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(AppLocalizations.of(context)!.bookReviewSuccess)),
                              );
                              setState(() {
                                _loadBookings();
                              });
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${AppLocalizations.of(context)!.bookReviewFailed}$e')),
                              );
                              setDialogState(() => _isSubmitting = false);
                            }
                          }
                        },
                  child: _isSubmitting
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(AppLocalizations.of(context)!.bookSubmit),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    status = status.toLowerCase();
    Color color = Colors.grey;
    String label = status;

    if (status == 'pending') {
      color = Colors.orange;
      label = AppLocalizations.of(context)!.bookStatusPending;
    } else if (status == 'accepted') {
      color = Colors.blue;
      label = AppLocalizations.of(context)!.bookStatusAccepted;
    } else if (status == 'completed') {
      color = Colors.green;
      label = AppLocalizations.of(context)!.bookStatusCompleted;
    } else if (status == 'rejected') {
      color = Colors.red;
      label = AppLocalizations.of(context)!.bookStatusRejected;
    } else if (status == 'cancelled') {
        color = Colors.red.shade300;
        label = AppLocalizations.of(context)!.bookStatusCancelled;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
