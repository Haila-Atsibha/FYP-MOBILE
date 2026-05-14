import 'dart:convert';
import 'dart:io';

void main() {
  final enFile = File('lib/l10n/app_en.arb');
  final amFile = File('lib/l10n/app_am.arb');

  final enMap = jsonDecode(enFile.readAsStringSync()) as Map<String, dynamic>;
  final amMap = jsonDecode(amFile.readAsStringSync()) as Map<String, dynamic>;

  final newEn = {
    "complaintSubmitSuccess": "Complaint submitted successfully. We will review it soon.",
    "complaintSubmitError": "Failed to submit complaint: ",
    "complaintReportTitle": "Report a Complaint",
    "complaintHistoryTooltip": "Complaint History",
    "complaintHelpImprove": "Help us improve",
    "complaintHelpDescription": "Please provide details about your issue. We take all complaints seriously.",
    "complaintSubject": "Subject",
    "complaintSubjectHint": "e.g., Service not provided as described",
    "complaintSubjectRequired": "Please enter a subject",
    "complaintPriority": "Priority",
    "complaintPriorityLow": "Low",
    "complaintPriorityMedium": "Medium",
    "complaintPriorityHigh": "High",
    "complaintDescription": "Description",
    "complaintDescriptionHint": "Provide as much detail as possible...",
    "complaintDescriptionRequired": "Please enter a description",
    "complaintSubmitButton": "Submit Complaint",
    "complaintHistoryTitle": "Complaint History",
    "complaintHistoryError": "Error: ",
    "complaintHistoryNoComplaints": "No complaints found.",
    "complaintHistorySubmittedOn": "Submitted on: ",
    "complaintHistoryAdminResponse": "Admin Response",
    "complaintHistoryRespondedOn": "Responded on: "
  };

  final newAm = {
    "complaintSubmitSuccess": "ቅሬታው በተሳካ ሁኔታ ቀርቧል። በቅርቡ እንገመግመዋለን።",
    "complaintSubmitError": "ቅሬታ ማቅረብ አልተሳካም: ",
    "complaintReportTitle": "ቅሬታ ያቅርቡ",
    "complaintHistoryTooltip": "የቅሬታ ታሪክ",
    "complaintHelpImprove": "እንድናሻሽል ያግዙን",
    "complaintHelpDescription": "እባክዎ ስለ ችግርዎ ዝርዝር መረጃ ያቅርቡ። ሁሉንም ቅሬታዎች በትኩረት እንመለከታለን።",
    "complaintSubject": "ርዕስ",
    "complaintSubjectHint": "ለምሳሌ: አገልግሎቱ በተገለጸው መሰረት አልቀረበም",
    "complaintSubjectRequired": "እባክዎ ርዕስ ያስገቡ",
    "complaintPriority": "ቅድሚያ",
    "complaintPriorityLow": "ዝቅተኛ",
    "complaintPriorityMedium": "መካከለኛ",
    "complaintPriorityHigh": "ከፍተኛ",
    "complaintDescription": "መግለጫ",
    "complaintDescriptionHint": "በተቻለ መጠን ብዙ ዝርዝር መረጃ ያቅርቡ...",
    "complaintDescriptionRequired": "እባክዎ መግለጫ ያስገቡ",
    "complaintSubmitButton": "ቅሬታ ያስገቡ",
    "complaintHistoryTitle": "የቅሬታ ታሪክ",
    "complaintHistoryError": "ስህተት: ",
    "complaintHistoryNoComplaints": "ምንም ቅሬታዎች አልተገኙም።",
    "complaintHistorySubmittedOn": "የቀረበበት ቀን: ",
    "complaintHistoryAdminResponse": "የአስተዳዳሪ ምላሽ",
    "complaintHistoryRespondedOn": "ምላሽ የተሰጠበት ቀን: "
  };

  enMap.addAll(newEn);
  amMap.addAll(newAm);

  enFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(enMap));
  amFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(amMap));
}
