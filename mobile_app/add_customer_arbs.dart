import 'dart:convert';
import 'dart:io';

void main() {
  final enFile = File('lib/l10n/app_en.arb');
  final amFile = File('lib/l10n/app_am.arb');

  final enMap = jsonDecode(enFile.readAsStringSync()) as Map<String, dynamic>;
  final amMap = jsonDecode(amFile.readAsStringSync()) as Map<String, dynamic>;

  final newEn = {
    "profileUpdateSuccess": "Profile updated successfully!",
    "profileUpdateError": "Failed to update profile: ",
    "profileEdit": "Edit Profile",
    "profileFullName": "Full Name",
    "profileNameRequired": "Please enter your name",
    "profileEmail": "Email Address",
    "profileEmailRequired": "Please enter your email",
    "profileEmailInvalid": "Please enter a valid email",
    "profileSaveChanges": "Save Changes",
    "topRatedProfessionals": "Top Rated Professionals",
    "providerPlaceholder": "Provider",
    "ratingFeedbackSuccess": "Thank you for your feedback!",
    "ratingSubmitError": "Failed to submit: ",
    "ratingTitle": "Rate the platform",
    "ratingSubtitle": "How is your experience with QuickServe so far?",
    "ratingFeedbackHint": "Any specific feedback? (Optional)",
    "ratingSubmit": "Submit Feedback",
    "savedTitle": "Saved",
    "savedComingSoon": "Saved screen coming soon!",
    "notificationsTitle": "Notifications",
    "notificationsComingSoon": "Notifications screen coming soon!"
  };

  final newAm = {
    "profileUpdateSuccess": "መገለጫው በተሳካ ሁኔታ ተዘምኗል!",
    "profileUpdateError": "መገለጫ ማዘመን አልተሳካም: ",
    "profileEdit": "መገለጫ ያርትዑ",
    "profileFullName": "ሙሉ ስም",
    "profileNameRequired": "እባክዎ ስምዎን ያስገቡ",
    "profileEmail": "የኢሜይል አድራሻ",
    "profileEmailRequired": "እባክዎ ኢሜይልዎን ያስገቡ",
    "profileEmailInvalid": "እባክዎ ትክክለኛ ኢሜይል ያስገቡ",
    "profileSaveChanges": "ለውጦችን ያስቀምጡ",
    "topRatedProfessionals": "ከፍተኛ ደረጃ የተሰጣቸው ባለሙያዎች",
    "providerPlaceholder": "አቅራቢ",
    "ratingFeedbackSuccess": "ስለ ግብረ መልስዎ እናመሰግናለን!",
    "ratingSubmitError": "ማስገባት አልተሳካም: ",
    "ratingTitle": "መድረኩን ደረጃ ይስጡ",
    "ratingSubtitle": "እስካሁን በኩዊክ ሰርቭ ላይ ያለዎት ተሞክሮ እንዴት ነው?",
    "ratingFeedbackHint": "ማንኛውም የተለየ ግብረ መልስ አለዎት? (አማራጭ)",
    "ratingSubmit": "ግብረ መልስ ያስገቡ",
    "savedTitle": "የተቀመጡ",
    "savedComingSoon": "የተቀመጡ ማያ ገጽ በቅርቡ ይመጣል!",
    "notificationsTitle": "ማሳወቂያዎች",
    "notificationsComingSoon": "የማሳወቂያዎች ማያ ገጽ በቅርቡ ይመጣል!"
  };

  enMap.addAll(newEn);
  amMap.addAll(newAm);

  enFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(enMap));
  amFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(amMap));
}
