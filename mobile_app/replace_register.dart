import 'dart:io';

void main() async {
  final file = File(r'c:\Users\Y\OneDrive\Desktop\FYP_MOBILE\mobile_app\lib\screens\auth\register_screen.dart');
  var content = await file.readAsString();

  final Map<String, String> replacements = {
    r"const SnackBar(content: Text('No face detected. Please take a clear selfie.'))": r"SnackBar(content: Text(AppLocalizations.of(context)!.registerNoFaceDetected))",
    r"const SnackBar(content: Text('Multiple faces detected. Please ensure only you are in the frame.'))": r"SnackBar(content: Text(AppLocalizations.of(context)!.registerMultipleFacesDetected))",
    r"const SnackBar(content: Text('Please provide all verification documents (Profile Image, National ID, Selfie)'))": r"SnackBar(content: Text(AppLocalizations.of(context)!.registerProvideAllDocs))",
    r"const SnackBar(content: Text('Providers must select at least one service category.'))": r"SnackBar(content: Text(AppLocalizations.of(context)!.registerProviderCategoryRequired))",
    r"const SnackBar(content: Text('Registration successful! Please login.'))": r"SnackBar(content: Text(AppLocalizations.of(context)!.registerSuccess))",
    r"'Create Account'": r"AppLocalizations.of(context)!.registerCreateAccount",
    r"'Join the QuickServe professional network'": r"AppLocalizations.of(context)!.registerJoinNetwork",
    r"'Basic Information'": r"AppLocalizations.of(context)!.registerBasicInformation",
    r"'Full Name'": r"AppLocalizations.of(context)!.registerFullName",
    r"'John Doe'": r"AppLocalizations.of(context)!.registerFullNameHint",
    r"'Please enter your full name'": r"AppLocalizations.of(context)!.registerFullNameRequired",
    r"'john@example.com'": r"AppLocalizations.of(context)!.registerEmailHint",
    r"'Please enter a valid email'": r"AppLocalizations.of(context)!.registerEmailRequired",
    r"'Password must be at least 6 characters'": r"AppLocalizations.of(context)!.registerPasswordLengthError",
    r"'Select Role'": r"AppLocalizations.of(context)!.registerSelectRole",
    r"'I am a Customer'": r"AppLocalizations.of(context)!.registerRoleCustomer",
    r"'I am a Provider'": r"AppLocalizations.of(context)!.registerRoleProvider",
    r"'Service Categories'": r"AppLocalizations.of(context)!.registerServiceCategories",
    r"'Select the services you offer'": r"AppLocalizations.of(context)!.registerSelectServices",
    r"'No categories available.'": r"AppLocalizations.of(context)!.registerNoCategoriesAvailable",
    r"'Verification Documents'": r"AppLocalizations.of(context)!.registerVerificationDocs",
    r"'Profile Photo'": r"AppLocalizations.of(context)!.registerProfilePhoto",
    r"'National ID Card'": r"AppLocalizations.of(context)!.registerNationalIdCard",
    r"'Face Verification'": r"AppLocalizations.of(context)!.registerFaceVerification",
    r"'Capture Verification Selfie'": r"AppLocalizations.of(context)!.registerCaptureSelfie",
    r"'Selfie Captured Successfully'": r"AppLocalizations.of(context)!.registerSelfieCaptured",
    r"'Educational / Certifications'": r"AppLocalizations.of(context)!.registerEducationalDocs",
    r"'+${_educationalDocuments.length - 1} more'": r"'+${_educationalDocuments.length - 1} ${AppLocalizations.of(context)!.registerMore}'",
    r"'Complete Registration'": r"AppLocalizations.of(context)!.registerCompleteBtn",
    r"'Already have an account? Login here'": r"AppLocalizations.of(context)!.registerAlreadyHaveAccount",
    r"'No file chosen'": r"AppLocalizations.of(context)!.registerNoFileChosen",
  };

  content = content.replaceAll(r"const Text('Basic Information'", r"Text(AppLocalizations.of(context)!.registerBasicInformation");
  content = content.replaceAll(r"const Text('Select Role'", r"Text(AppLocalizations.of(context)!.registerSelectRole");
  content = content.replaceAll(r"const Text('Service Categories'", r"Text(AppLocalizations.of(context)!.registerServiceCategories");
  content = content.replaceAll(r"const Text('Verification Documents'", r"Text(AppLocalizations.of(context)!.registerVerificationDocs");
  content = content.replaceAll(r"const Text('Face Verification'", r"Text(AppLocalizations.of(context)!.registerFaceVerification");
  content = content.replaceAll(r"const Text('No categories available.')", r"Text(AppLocalizations.of(context)!.registerNoCategoriesAvailable)");
  content = content.replaceAll(r"const Text('Already have an account? Login here'", r"Text(AppLocalizations.of(context)!.registerAlreadyHaveAccount");
  content = content.replaceAll(r"DropdownMenuItem(value: 'customer', child: Text('I am a Customer'))", r"DropdownMenuItem(value: 'customer', child: Text(AppLocalizations.of(context)!.registerRoleCustomer))");
  content = content.replaceAll(r"DropdownMenuItem(value: 'provider', child: Text('I am a Provider'))", r"DropdownMenuItem(value: 'provider', child: Text(AppLocalizations.of(context)!.registerRoleProvider))");
  content = content.replaceAll(r"const Text('Complete Registration'", r"Text(AppLocalizations.of(context)!.registerCompleteBtn");

  for (var entry in replacements.entries) {
    content = content.replaceAll(entry.key, entry.value);
  }

  if (!content.contains('app_localizations.dart')) {
    content = content.replaceFirst("import 'package:provider/provider.dart';", "import 'package:provider/provider.dart';\nimport 'package:flutter_gen/gen_l10n/app_localizations.dart';");
  }

  await file.writeAsString(content);
  print('Replaced strings in register_screen.dart');
}
