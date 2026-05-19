import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'QuickServe'**
  String get appTitle;

  /// No description provided for @languageToggle.
  ///
  /// In en, this message translates to:
  /// **'Am'**
  String get languageToggle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for professional services...'**
  String get searchHint;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResults;

  /// No description provided for @noCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No matching categories found'**
  String get noCategoriesFound;

  /// No description provided for @serviceCategories.
  ///
  /// In en, this message translates to:
  /// **'Service Categories'**
  String get serviceCategories;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @allProfessionals.
  ///
  /// In en, this message translates to:
  /// **'All Professionals'**
  String get allProfessionals;

  /// No description provided for @availableProfessionals.
  ///
  /// In en, this message translates to:
  /// **'Available Professionals'**
  String get availableProfessionals;

  /// No description provided for @professional.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get professional;

  /// No description provided for @professionalBioPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Professional service provider'**
  String get professionalBioPlaceholder;

  /// No description provided for @jobs.
  ///
  /// In en, this message translates to:
  /// **'jobs'**
  String get jobs;

  /// No description provided for @drawerUserPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get drawerUserPlaceholder;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get navMessages;

  /// No description provided for @navMyBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get navMyBookings;

  /// No description provided for @navReportComplaint.
  ///
  /// In en, this message translates to:
  /// **'Report a Complaint'**
  String get navReportComplaint;

  /// No description provided for @navProfileSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get navProfileSettings;

  /// No description provided for @navLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get navLogout;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get loginFailed;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nQuickServe'**
  String get welcomeMessage;

  /// No description provided for @professionalServicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Professional Services at your doorstep'**
  String get professionalServicesSubtitle;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @registerHere.
  ///
  /// In en, this message translates to:
  /// **'Register Here'**
  String get registerHere;

  /// No description provided for @registerNoFaceDetected.
  ///
  /// In en, this message translates to:
  /// **'No face detected. Please take a clear selfie.'**
  String get registerNoFaceDetected;

  /// No description provided for @registerMultipleFacesDetected.
  ///
  /// In en, this message translates to:
  /// **'Multiple faces detected. Please ensure only you are in the frame.'**
  String get registerMultipleFacesDetected;

  /// No description provided for @registerProvideAllDocs.
  ///
  /// In en, this message translates to:
  /// **'Please provide all verification documents (Profile Image, National ID, Selfie)'**
  String get registerProvideAllDocs;

  /// No description provided for @registerProviderCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Providers must select at least one service category.'**
  String get registerProviderCategoryRequired;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Please login.'**
  String get registerSuccess;

  /// No description provided for @registerCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerCreateAccount;

  /// No description provided for @registerJoinNetwork.
  ///
  /// In en, this message translates to:
  /// **'Join the QuickServe professional network'**
  String get registerJoinNetwork;

  /// No description provided for @registerBasicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get registerBasicInformation;

  /// No description provided for @registerFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get registerFullName;

  /// No description provided for @registerFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get registerFullNameHint;

  /// No description provided for @registerFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get registerFullNameRequired;

  /// No description provided for @registerEmailHint.
  ///
  /// In en, this message translates to:
  /// **'john@example.com'**
  String get registerEmailHint;

  /// No description provided for @registerEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get registerEmailRequired;

  /// No description provided for @registerPasswordLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get registerPasswordLengthError;

  /// No description provided for @registerSelectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get registerSelectRole;

  /// No description provided for @registerRoleCustomer.
  ///
  /// In en, this message translates to:
  /// **'I am a Customer'**
  String get registerRoleCustomer;

  /// No description provided for @registerRoleProvider.
  ///
  /// In en, this message translates to:
  /// **'I am a Provider'**
  String get registerRoleProvider;

  /// No description provided for @registerServiceCategories.
  ///
  /// In en, this message translates to:
  /// **'Service Categories'**
  String get registerServiceCategories;

  /// No description provided for @registerSelectServices.
  ///
  /// In en, this message translates to:
  /// **'Select the services you offer'**
  String get registerSelectServices;

  /// No description provided for @registerNoCategoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No categories available.'**
  String get registerNoCategoriesAvailable;

  /// No description provided for @registerVerificationDocs.
  ///
  /// In en, this message translates to:
  /// **'Verification Documents'**
  String get registerVerificationDocs;

  /// No description provided for @registerProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get registerProfilePhoto;

  /// No description provided for @registerNationalIdCard.
  ///
  /// In en, this message translates to:
  /// **'National ID Card'**
  String get registerNationalIdCard;

  /// No description provided for @registerFaceVerification.
  ///
  /// In en, this message translates to:
  /// **'Face Verification'**
  String get registerFaceVerification;

  /// No description provided for @registerCaptureSelfie.
  ///
  /// In en, this message translates to:
  /// **'Capture Verification Selfie'**
  String get registerCaptureSelfie;

  /// No description provided for @registerSelfieCaptured.
  ///
  /// In en, this message translates to:
  /// **'Selfie Captured Successfully'**
  String get registerSelfieCaptured;

  /// No description provided for @registerEducationalDocs.
  ///
  /// In en, this message translates to:
  /// **'Educational / Certifications'**
  String get registerEducationalDocs;

  /// No description provided for @registerMore.
  ///
  /// In en, this message translates to:
  /// **'more'**
  String get registerMore;

  /// No description provided for @registerCompleteBtn.
  ///
  /// In en, this message translates to:
  /// **'Complete Registration'**
  String get registerCompleteBtn;

  /// No description provided for @registerAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login here'**
  String get registerAlreadyHaveAccount;

  /// No description provided for @registerNoFileChosen.
  ///
  /// In en, this message translates to:
  /// **'No file chosen'**
  String get registerNoFileChosen;

  /// No description provided for @bookSelectServiceWarning.
  ///
  /// In en, this message translates to:
  /// **'Please select a service'**
  String get bookSelectServiceWarning;

  /// No description provided for @bookSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get bookSuccessTitle;

  /// No description provided for @bookSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your booking has been placed successfully!'**
  String get bookSuccessMessage;

  /// No description provided for @bookOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get bookOk;

  /// No description provided for @bookTitle.
  ///
  /// In en, this message translates to:
  /// **'Book a Service'**
  String get bookTitle;

  /// No description provided for @bookSelectService.
  ///
  /// In en, this message translates to:
  /// **'Select a Service'**
  String get bookSelectService;

  /// No description provided for @bookNoServices.
  ///
  /// In en, this message translates to:
  /// **'This provider has no services listed.'**
  String get bookNoServices;

  /// No description provided for @bookJobDetails.
  ///
  /// In en, this message translates to:
  /// **'Tell us about the job'**
  String get bookJobDetails;

  /// No description provided for @bookConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get bookConfirm;

  /// No description provided for @bookCancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get bookCancelBooking;

  /// No description provided for @bookCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking?'**
  String get bookCancelConfirm;

  /// No description provided for @bookNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get bookNo;

  /// No description provided for @bookYesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get bookYesCancel;

  /// No description provided for @bookCancelledMessage.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled'**
  String get bookCancelledMessage;

  /// No description provided for @bookMyBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get bookMyBookings;

  /// No description provided for @bookNoBookings.
  ///
  /// In en, this message translates to:
  /// **'No bookings found'**
  String get bookNoBookings;

  /// No description provided for @bookReviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get bookReviewed;

  /// No description provided for @bookRateReview.
  ///
  /// In en, this message translates to:
  /// **'Rate & Review'**
  String get bookRateReview;

  /// No description provided for @bookCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get bookCancel;

  /// No description provided for @bookReviewSuccess.
  ///
  /// In en, this message translates to:
  /// **'Review submitted successfully!'**
  String get bookReviewSuccess;

  /// No description provided for @bookSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get bookSubmit;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdateSuccess;

  /// No description provided for @profileUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile: '**
  String get profileUpdateError;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEdit;

  /// No description provided for @profileFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profileFullName;

  /// No description provided for @profileNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get profileNameRequired;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get profileEmail;

  /// No description provided for @profileEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get profileEmailRequired;

  /// No description provided for @profileEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get profileEmailInvalid;

  /// No description provided for @profileSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get profileSaveChanges;

  /// No description provided for @topRatedProfessionals.
  ///
  /// In en, this message translates to:
  /// **'Top Rated Professionals'**
  String get topRatedProfessionals;

  /// No description provided for @providerPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get providerPlaceholder;

  /// No description provided for @ratingFeedbackSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get ratingFeedbackSuccess;

  /// No description provided for @ratingSubmitError.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit: '**
  String get ratingSubmitError;

  /// No description provided for @ratingTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate the platform'**
  String get ratingTitle;

  /// No description provided for @ratingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How is your experience with QuickServe so far?'**
  String get ratingSubtitle;

  /// No description provided for @ratingFeedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Any specific feedback? (Optional)'**
  String get ratingFeedbackHint;

  /// No description provided for @ratingSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get ratingSubmit;

  /// No description provided for @savedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedTitle;

  /// No description provided for @savedComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Saved screen coming soon!'**
  String get savedComingSoon;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Notifications screen coming soon!'**
  String get notificationsComingSoon;

  /// No description provided for @complaintSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Complaint submitted successfully. We will review it soon.'**
  String get complaintSubmitSuccess;

  /// No description provided for @complaintSubmitError.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit complaint: '**
  String get complaintSubmitError;

  /// No description provided for @complaintReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report a Complaint'**
  String get complaintReportTitle;

  /// No description provided for @complaintHistoryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Complaint History'**
  String get complaintHistoryTooltip;

  /// No description provided for @complaintHelpImprove.
  ///
  /// In en, this message translates to:
  /// **'Help us improve'**
  String get complaintHelpImprove;

  /// No description provided for @complaintHelpDescription.
  ///
  /// In en, this message translates to:
  /// **'Please provide details about your issue. We take all complaints seriously.'**
  String get complaintHelpDescription;

  /// No description provided for @complaintSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get complaintSubject;

  /// No description provided for @complaintSubjectHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Service not provided as described'**
  String get complaintSubjectHint;

  /// No description provided for @complaintSubjectRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a subject'**
  String get complaintSubjectRequired;

  /// No description provided for @complaintPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get complaintPriority;

  /// No description provided for @complaintPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get complaintPriorityLow;

  /// No description provided for @complaintPriorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get complaintPriorityMedium;

  /// No description provided for @complaintPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get complaintPriorityHigh;

  /// No description provided for @complaintDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get complaintDescription;

  /// No description provided for @complaintDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Provide as much detail as possible...'**
  String get complaintDescriptionHint;

  /// No description provided for @complaintDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get complaintDescriptionRequired;

  /// No description provided for @complaintSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Complaint'**
  String get complaintSubmitButton;

  /// No description provided for @complaintHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Complaint History'**
  String get complaintHistoryTitle;

  /// No description provided for @complaintHistoryError.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get complaintHistoryError;

  /// No description provided for @complaintHistoryNoComplaints.
  ///
  /// In en, this message translates to:
  /// **'No complaints found.'**
  String get complaintHistoryNoComplaints;

  /// No description provided for @complaintHistorySubmittedOn.
  ///
  /// In en, this message translates to:
  /// **'Submitted on: '**
  String get complaintHistorySubmittedOn;

  /// No description provided for @complaintHistoryAdminResponse.
  ///
  /// In en, this message translates to:
  /// **'Admin Response'**
  String get complaintHistoryAdminResponse;

  /// No description provided for @complaintHistoryRespondedOn.
  ///
  /// In en, this message translates to:
  /// **'Responded on: '**
  String get complaintHistoryRespondedOn;

  /// No description provided for @bookServiceDefault.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get bookServiceDefault;

  /// No description provided for @bookProviderPrefix.
  ///
  /// In en, this message translates to:
  /// **'Provider: '**
  String get bookProviderPrefix;

  /// No description provided for @bookDefaultProviderName.
  ///
  /// In en, this message translates to:
  /// **'QuickServe Expert'**
  String get bookDefaultProviderName;

  /// No description provided for @bookReviewPromptPrefix.
  ///
  /// In en, this message translates to:
  /// **'How was your experience with '**
  String get bookReviewPromptPrefix;

  /// No description provided for @bookReviewPromptSuffix.
  ///
  /// In en, this message translates to:
  /// **'?'**
  String get bookReviewPromptSuffix;

  /// No description provided for @bookReviewComments.
  ///
  /// In en, this message translates to:
  /// **'Comments (Optional)'**
  String get bookReviewComments;

  /// No description provided for @bookReviewFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed: '**
  String get bookReviewFailed;

  /// No description provided for @bookStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get bookStatusPending;

  /// No description provided for @bookStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get bookStatusAccepted;

  /// No description provided for @bookStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookStatusCompleted;

  /// No description provided for @bookStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get bookStatusRejected;

  /// No description provided for @bookStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bookStatusCancelled;

  /// No description provided for @chatMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get chatMessagesTitle;

  /// No description provided for @chatSecureMessaging.
  ///
  /// In en, this message translates to:
  /// **'Secure Messaging'**
  String get chatSecureMessaging;

  /// No description provided for @chatNoMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages to show yet'**
  String get chatNoMessages;

  /// No description provided for @chatNoMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get chatNoMessagesYet;

  /// No description provided for @chatMessageSendError.
  ///
  /// In en, this message translates to:
  /// **'Your message couldn\'t be sent. Please check your connection.'**
  String get chatMessageSendError;

  /// No description provided for @chatPendingMessageNotice.
  ///
  /// In en, this message translates to:
  /// **'Messaging will be enabled once the provider accepts your request.'**
  String get chatPendingMessageNotice;

  /// No description provided for @chatClosedMessageNoticePrefix.
  ///
  /// In en, this message translates to:
  /// **'Messaging is closed for this '**
  String get chatClosedMessageNoticePrefix;

  /// No description provided for @chatClosedMessageNoticeSuffix.
  ///
  /// In en, this message translates to:
  /// **' booking.'**
  String get chatClosedMessageNoticeSuffix;

  /// No description provided for @chatTypeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get chatTypeMessageHint;

  /// No description provided for @chatWaitingForAcceptanceHint.
  ///
  /// In en, this message translates to:
  /// **'Waiting for provider acceptance...'**
  String get chatWaitingForAcceptanceHint;

  /// No description provided for @providerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Provider Dashboard'**
  String get providerDashboard;

  /// No description provided for @welcomeProvider.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeProvider(Object name);

  /// No description provided for @noStatsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No stats available'**
  String get noStatsAvailable;

  /// No description provided for @addNewService.
  ///
  /// In en, this message translates to:
  /// **'Add New Service'**
  String get addNewService;

  /// No description provided for @statPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statPending;

  /// No description provided for @statActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statActive;

  /// No description provided for @statCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statCompleted;

  /// No description provided for @statEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get statEarnings;

  /// No description provided for @etbAmount.
  ///
  /// In en, this message translates to:
  /// **'ETB {amount}'**
  String etbAmount(Object amount);

  /// No description provided for @activeSubscription.
  ///
  /// In en, this message translates to:
  /// **'Active Subscription'**
  String get activeSubscription;

  /// No description provided for @subscriptionInactive.
  ///
  /// In en, this message translates to:
  /// **'Subscription Inactive'**
  String get subscriptionInactive;

  /// No description provided for @expiresOn.
  ///
  /// In en, this message translates to:
  /// **'Expires on {date}'**
  String expiresOn(Object date);

  /// No description provided for @noActiveSubscription.
  ///
  /// In en, this message translates to:
  /// **'No active subscription'**
  String get noActiveSubscription;

  /// No description provided for @renewEarly.
  ///
  /// In en, this message translates to:
  /// **'Renew Early'**
  String get renewEarly;

  /// No description provided for @renewNow.
  ///
  /// In en, this message translates to:
  /// **'Renew Now'**
  String get renewNow;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @myServices.
  ///
  /// In en, this message translates to:
  /// **'My Services'**
  String get myServices;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @subscriptionHistory.
  ///
  /// In en, this message translates to:
  /// **'Subscription History'**
  String get subscriptionHistory;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettings;

  /// No description provided for @submitComplaint.
  ///
  /// In en, this message translates to:
  /// **'Submit Complaint'**
  String get submitComplaint;

  /// No description provided for @ratePlatform.
  ///
  /// In en, this message translates to:
  /// **'Rate Platform'**
  String get ratePlatform;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @paymentScreenError.
  ///
  /// In en, this message translates to:
  /// **'Could not launch payment screen'**
  String get paymentScreenError;

  /// No description provided for @tabPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get tabPending;

  /// No description provided for @tabActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get tabActive;

  /// No description provided for @tabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tabHistory;

  /// No description provided for @bookingCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Customer: {name}'**
  String bookingCustomerName(Object name);

  /// No description provided for @bookingPrice.
  ///
  /// In en, this message translates to:
  /// **'Price: ETB {price}'**
  String bookingPrice(Object price);

  /// No description provided for @bookingNote.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String bookingNote(Object note);

  /// No description provided for @actionReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get actionReject;

  /// No description provided for @actionAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get actionAccept;

  /// No description provided for @actionMarkCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as Completed'**
  String get actionMarkCompleted;

  /// No description provided for @bookingStatusUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking {status} successfully'**
  String bookingStatusUpdateSuccess(Object status);

  /// No description provided for @customerReviews.
  ///
  /// In en, this message translates to:
  /// **'Customer Reviews'**
  String get customerReviews;

  /// No description provided for @customerReviewsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See what your customers are saying about your services'**
  String get customerReviewsSubtitle;

  /// No description provided for @recentFeedback.
  ///
  /// In en, this message translates to:
  /// **'Recent Feedback'**
  String get recentFeedback;

  /// No description provided for @sortNewestFirst.
  ///
  /// In en, this message translates to:
  /// **'Sort: Newest First'**
  String get sortNewestFirst;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet.'**
  String get noReviewsYet;

  /// No description provided for @overallRating.
  ///
  /// In en, this message translates to:
  /// **'Overall Rating'**
  String get overallRating;

  /// No description provided for @basedOnTotalReviews.
  ///
  /// In en, this message translates to:
  /// **'Based on {count} total reviews'**
  String basedOnTotalReviews(Object count);

  /// No description provided for @verifiedCustomer.
  ///
  /// In en, this message translates to:
  /// **'Verified Customer'**
  String get verifiedCustomer;

  /// No description provided for @booked.
  ///
  /// In en, this message translates to:
  /// **'Booked:'**
  String get booked;

  /// No description provided for @professionalService.
  ///
  /// In en, this message translates to:
  /// **'Professional Service'**
  String get professionalService;

  /// No description provided for @noServicesFound.
  ///
  /// In en, this message translates to:
  /// **'No services found.'**
  String get noServicesFound;

  /// No description provided for @addAService.
  ///
  /// In en, this message translates to:
  /// **'Add a Service'**
  String get addAService;

  /// No description provided for @editService.
  ///
  /// In en, this message translates to:
  /// **'Edit Service'**
  String get editService;

  /// No description provided for @noSubscriptionPaymentsFound.
  ///
  /// In en, this message translates to:
  /// **'No subscription payments found.'**
  String get noSubscriptionPaymentsFound;

  /// No description provided for @subscriptionRef.
  ///
  /// In en, this message translates to:
  /// **'Ref: {ref}'**
  String subscriptionRef(Object ref);

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhone;

  /// No description provided for @profileBio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get profileBio;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get fieldRequired;

  /// No description provided for @addService.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get addService;

  /// No description provided for @serviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Title'**
  String get serviceTitle;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterTitle;

  /// No description provided for @priceETB.
  ///
  /// In en, this message translates to:
  /// **'Price (ETB)'**
  String get priceETB;

  /// No description provided for @pleaseEnterPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a price'**
  String get pleaseEnterPrice;

  /// No description provided for @pleaseEnterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// No description provided for @serviceCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get serviceCategory;

  /// No description provided for @pleaseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get pleaseSelectCategory;

  /// No description provided for @serviceDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get serviceDescription;

  /// No description provided for @pleaseEnterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get pleaseEnterDescription;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @createService.
  ///
  /// In en, this message translates to:
  /// **'Create Service'**
  String get createService;

  /// No description provided for @serviceCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Service created successfully'**
  String get serviceCreatedSuccess;

  /// No description provided for @serviceUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Service updated successfully'**
  String get serviceUpdatedSuccess;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// No description provided for @platformOverview.
  ///
  /// In en, this message translates to:
  /// **'Platform Overview'**
  String get platformOverview;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @totalBookings.
  ///
  /// In en, this message translates to:
  /// **'Total Bookings'**
  String get totalBookings;

  /// No description provided for @activeJobs.
  ///
  /// In en, this message translates to:
  /// **'Active Jobs'**
  String get activeJobs;

  /// No description provided for @avgRating.
  ///
  /// In en, this message translates to:
  /// **'Avg Rating'**
  String get avgRating;

  /// No description provided for @totalPlatformRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Platform Revenue'**
  String get totalPlatformRevenue;

  /// No description provided for @quickManagement.
  ///
  /// In en, this message translates to:
  /// **'Quick Management'**
  String get quickManagement;

  /// No description provided for @manageCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get manageCategories;

  /// No description provided for @reviewComplaints.
  ///
  /// In en, this message translates to:
  /// **'Review Complaints'**
  String get reviewComplaints;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @userDocuments.
  ///
  /// In en, this message translates to:
  /// **'User Documents'**
  String get userDocuments;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @verificationSelfie.
  ///
  /// In en, this message translates to:
  /// **'Verification Selfie'**
  String get verificationSelfie;

  /// No description provided for @educationalDocuments.
  ///
  /// In en, this message translates to:
  /// **'Educational Documents'**
  String get educationalDocuments;

  /// No description provided for @noDocumentsUploaded.
  ///
  /// In en, this message translates to:
  /// **'No documents uploaded for this user.'**
  String get noDocumentsUploaded;

  /// No description provided for @openPdf.
  ///
  /// In en, this message translates to:
  /// **'Open PDF'**
  String get openPdf;

  /// No description provided for @viewInApp.
  ///
  /// In en, this message translates to:
  /// **'View In-App'**
  String get viewInApp;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @errorFetchingData.
  ///
  /// In en, this message translates to:
  /// **'Error fetching data:'**
  String get errorFetchingData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found.'**
  String get noUsersFound;

  /// No description provided for @viewDocuments.
  ///
  /// In en, this message translates to:
  /// **'View Documents'**
  String get viewDocuments;

  /// No description provided for @copyUrl.
  ///
  /// In en, this message translates to:
  /// **'Copy URL'**
  String get copyUrl;

  /// No description provided for @bookingManagement.
  ///
  /// In en, this message translates to:
  /// **'Booking Management'**
  String get bookingManagement;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @unassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get unassigned;

  /// No description provided for @addNewCategory.
  ///
  /// In en, this message translates to:
  /// **'Add New Category'**
  String get addNewCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @categoryCreated.
  ///
  /// In en, this message translates to:
  /// **'Category created!'**
  String get categoryCreated;

  /// No description provided for @providersInCategory.
  ///
  /// In en, this message translates to:
  /// **'{category} Providers'**
  String providersInCategory(Object category);

  /// No description provided for @noProvidersFoundInCategory.
  ///
  /// In en, this message translates to:
  /// **'No providers found in this category.'**
  String get noProvidersFoundInCategory;

  /// No description provided for @ratingJobsCount.
  ///
  /// In en, this message translates to:
  /// **'{rating} • {jobs} jobs'**
  String ratingJobsCount(Object rating, Object jobs);

  /// No description provided for @replyToComplaint.
  ///
  /// In en, this message translates to:
  /// **'Reply to: {subject}'**
  String replyToComplaint(Object subject);

  /// No description provided for @typeReplyHere.
  ///
  /// In en, this message translates to:
  /// **'Type your reply here...'**
  String get typeReplyHere;

  /// No description provided for @replySent.
  ///
  /// In en, this message translates to:
  /// **'Reply sent!'**
  String get replySent;

  /// No description provided for @sendReply.
  ///
  /// In en, this message translates to:
  /// **'Send Reply'**
  String get sendReply;

  /// No description provided for @byUser.
  ///
  /// In en, this message translates to:
  /// **'By: {name}'**
  String byUser(Object name);

  /// No description provided for @adminReply.
  ///
  /// In en, this message translates to:
  /// **'Admin Reply:'**
  String get adminReply;

  /// No description provided for @replyAndResolve.
  ///
  /// In en, this message translates to:
  /// **'Reply & Resolve'**
  String get replyAndResolve;

  /// No description provided for @subscriptionsAndRevenue.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions & Revenue'**
  String get subscriptionsAndRevenue;

  /// No description provided for @recentPayments.
  ///
  /// In en, this message translates to:
  /// **'Recent Payments'**
  String get recentPayments;

  /// No description provided for @monthlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get monthlyRevenue;

  /// No description provided for @activePremium.
  ///
  /// In en, this message translates to:
  /// **'Active Premium'**
  String get activePremium;

  /// No description provided for @providerApprovedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Provider approved successfully'**
  String get providerApprovedSuccess;

  /// No description provided for @rejectProvider.
  ///
  /// In en, this message translates to:
  /// **'Reject Provider'**
  String get rejectProvider;

  /// No description provided for @reasonForRejection.
  ///
  /// In en, this message translates to:
  /// **'Reason for rejection'**
  String get reasonForRejection;

  /// No description provided for @providerRejected.
  ///
  /// In en, this message translates to:
  /// **'Provider rejected'**
  String get providerRejected;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @providerVerifications.
  ///
  /// In en, this message translates to:
  /// **'Provider Verifications'**
  String get providerVerifications;

  /// No description provided for @noPendingVerifications.
  ///
  /// In en, this message translates to:
  /// **'No pending verifications.'**
  String get noPendingVerifications;

  /// No description provided for @identityDocuments.
  ///
  /// In en, this message translates to:
  /// **'Identity Documents'**
  String get identityDocuments;

  /// No description provided for @selfie.
  ///
  /// In en, this message translates to:
  /// **'Selfie'**
  String get selfie;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @pdfDocument.
  ///
  /// In en, this message translates to:
  /// **'PDF Document'**
  String get pdfDocument;

  /// No description provided for @external.
  ///
  /// In en, this message translates to:
  /// **'External'**
  String get external;

  /// No description provided for @errorText.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorText(Object error);

  /// No description provided for @chatAddCaption.
  ///
  /// In en, this message translates to:
  /// **'Add a caption (optional)'**
  String get chatAddCaption;

  /// No description provided for @chatSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chatSend;

  /// No description provided for @chatCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get chatCancel;

  /// No description provided for @landingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get landingGetStarted;

  /// No description provided for @exploreAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Explore as Guest'**
  String get exploreAsGuest;

  /// No description provided for @loginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please login to continue'**
  String get loginToContinue;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['am', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
