import 'dart:convert';
import 'dart:io';

void main() {
  final enFile = File('lib/l10n/app_en.arb');
  final amFile = File('lib/l10n/app_am.arb');

  final enMap = jsonDecode(enFile.readAsStringSync()) as Map<String, dynamic>;
  final amMap = jsonDecode(amFile.readAsStringSync()) as Map<String, dynamic>;

  final newEn = {
    "bookServiceDefault": "Service",
    "bookProviderPrefix": "Provider: ",
    "bookDefaultProviderName": "QuickServe Expert",
    "bookReviewPromptPrefix": "How was your experience with ",
    "bookReviewPromptSuffix": "?",
    "bookReviewComments": "Comments (Optional)",
    "bookReviewFailed": "Failed: ",
    "bookStatusPending": "Pending Approval",
    "bookStatusAccepted": "Accepted",
    "bookStatusCompleted": "Completed",
    "bookStatusRejected": "Rejected",
    "bookStatusCancelled": "Cancelled"
  };

  final newAm = {
    "bookServiceDefault": "አገልግሎት",
    "bookProviderPrefix": "አቅራቢ: ",
    "bookDefaultProviderName": "ኩዊክ ሰርቭ ባለሙያ",
    "bookReviewPromptPrefix": "ከ ",
    "bookReviewPromptSuffix": " ጋር ያለዎት ተሞክሮ እንዴት ነበር?",
    "bookReviewComments": "አስተያየቶች (አማራጭ)",
    "bookReviewFailed": "አልተሳካም: ",
    "bookStatusPending": "ማረጋገጫ በመጠባበቅ ላይ",
    "bookStatusAccepted": "ተቀባይነት አግኝቷል",
    "bookStatusCompleted": "ተጠናቅቋል",
    "bookStatusRejected": "ውድቅ ተደርጓል",
    "bookStatusCancelled": "ተሰርዟል"
  };

  enMap.addAll(newEn);
  amMap.addAll(newAm);

  enFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(enMap));
  amFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(amMap));
}
