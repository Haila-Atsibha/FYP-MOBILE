import 'dart:io';

void main() async {
  final files = [
    r'c:\Users\Y\OneDrive\Desktop\FYP_MOBILE\mobile_app\lib\screens\booking\booking_screen.dart',
    r'c:\Users\Y\OneDrive\Desktop\FYP_MOBILE\mobile_app\lib\screens\booking\my_bookings_screen.dart',
  ];

  final Map<String, String> replacements = {
    r"const SnackBar(content: Text('Please select a service'))": r"SnackBar(content: Text(AppLocalizations.of(context)!.bookSelectServiceWarning))",
    r"'Success'": r"AppLocalizations.of(context)!.bookSuccessTitle",
    r"'Your booking has been placed successfully!'": r"AppLocalizations.of(context)!.bookSuccessMessage",
    r"'OK'": r"AppLocalizations.of(context)!.bookOk",
    r"'Book a Service'": r"AppLocalizations.of(context)!.bookTitle",
    r"'Select a Service'": r"AppLocalizations.of(context)!.bookSelectService",
    r"'This provider has no services listed.'": r"AppLocalizations.of(context)!.bookNoServices",
    r"'Tell us about the job'": r"AppLocalizations.of(context)!.bookJobDetails",
    r"'Confirm Booking'": r"AppLocalizations.of(context)!.bookConfirm",
    r"'Cancel Booking'": r"AppLocalizations.of(context)!.bookCancelBooking",
    r"'Are you sure you want to cancel this booking?'": r"AppLocalizations.of(context)!.bookCancelConfirm",
    r"'No'": r"AppLocalizations.of(context)!.bookNo",
    r"'Yes, Cancel'": r"AppLocalizations.of(context)!.bookYesCancel",
    r"const SnackBar(content: Text('Booking cancelled'))": r"SnackBar(content: Text(AppLocalizations.of(context)!.bookCancelledMessage))",
    r"'My Bookings'": r"AppLocalizations.of(context)!.bookMyBookings",
    r"'No bookings found'": r"AppLocalizations.of(context)!.bookNoBookings",
    r"'Reviewed'": r"AppLocalizations.of(context)!.bookReviewed",
    r"'Rate & Review'": r"AppLocalizations.of(context)!.bookRateReview",
    r"'Cancel'": r"AppLocalizations.of(context)!.bookCancel",
    r"const SnackBar(content: Text('Review submitted successfully!'))": r"SnackBar(content: Text(AppLocalizations.of(context)!.bookReviewSuccess))",
    r"'Submit'": r"AppLocalizations.of(context)!.bookSubmit",
  };

  for (var filePath in files) {
    final file = File(filePath);
    if (!await file.exists()) continue;
    var content = await file.readAsString();

    content = content.replaceAll(r"const Text('Book a Service'", r"Text(AppLocalizations.of(context)!.bookTitle");
    content = content.replaceAll(r"const Text('Select a Service'", r"Text(AppLocalizations.of(context)!.bookSelectService");
    content = content.replaceAll(r"const Text('Confirm Booking'", r"Text(AppLocalizations.of(context)!.bookConfirm");
    content = content.replaceAll(r"const Text('Cancel Booking'", r"Text(AppLocalizations.of(context)!.bookCancelBooking");
    content = content.replaceAll(r"const Text('Are you sure you want to cancel this booking?'", r"Text(AppLocalizations.of(context)!.bookCancelConfirm");
    content = content.replaceAll(r"const Text('My Bookings'", r"Text(AppLocalizations.of(context)!.bookMyBookings");
    content = content.replaceAll(r"const Text('No bookings found'", r"Text(AppLocalizations.of(context)!.bookNoBookings");
    content = content.replaceAll(r"const Text('Reviewed'", r"Text(AppLocalizations.of(context)!.bookReviewed");
    content = content.replaceAll(r"const Text('Rate & Review'", r"Text(AppLocalizations.of(context)!.bookRateReview");

    for (var entry in replacements.entries) {
      content = content.replaceAll(entry.key, entry.value);
    }

    if (!content.contains('app_localizations.dart')) {
      content = content.replaceFirst("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:flutter_gen/gen_l10n/app_localizations.dart';");
    }

    await file.writeAsString(content);
    print('Replaced strings in $filePath');
  }
}
