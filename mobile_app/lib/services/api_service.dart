import 'dart:convert';
import 'package:flutter/foundation.dart' hide Category;
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/core/constants.dart';
import 'package:mobile_app/models/models.dart';

class ApiService {
  final String _baseUrl = ApiConfig.baseUrl;
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  // Auth
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Login Failed');
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    required XFile profileImage,
    required dynamic nationalId, // XFile or PlatformFile
    required XFile selfie,
    List<PlatformFile>? educationalDocs,
    List<int>? categories,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/auth/register'));
    
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['role'] = role;

    if (categories != null && categories.isNotEmpty) {
      for (final catId in categories) {
        request.fields['categories[]'] = catId.toString();
      }
    }

    Future<void> addFileToRequest(String fieldName, dynamic file) async {
      if (file is XFile) {
        final bytes = await file.readAsBytes();
        String fName = file.name;
        if (fName.isEmpty || fName.contains(r'\')) fName = '${fieldName}.jpg';
        request.files.add(http.MultipartFile.fromBytes(fieldName, bytes, filename: fName));
      } else if (file is PlatformFile) {
        if (file.bytes != null) {
          request.files.add(http.MultipartFile.fromBytes(fieldName, file.bytes!, filename: file.name));
        } else if (file.path != null) {
          request.files.add(await http.MultipartFile.fromPath(fieldName, file.path!, filename: file.name));
        }
      }
    }

    await addFileToRequest('profileImage', profileImage);
    await addFileToRequest('nationalId', nationalId);
    await addFileToRequest('verificationSelfie', selfie);

    if (educationalDocs != null) {
      for (final doc in educationalDocs) {
        await addFileToRequest('educationalDocuments[]', doc);
      }
    }

    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final message = jsonDecode(response.body)['message'] ?? 'Registration failed';
      throw Exception(message);
    }
  }

  // Services
  Future<List<Service>> getServices({int? categoryId, String? query}) async {
    String url = '$_baseUrl/services?';
    if (categoryId != null) url += 'category=$categoryId&';
    if (query != null) url += 'q=$query';

    final response = await http.get(Uri.parse(url), headers: _headers);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Service.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  // Categories
  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/categories'), headers: _headers);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Bookings
  Future<List<Booking>> getMyBookings() async {
    final response = await http.get(Uri.parse('$_baseUrl/bookings/my'), headers: _headers);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Booking.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  Future<Map<String, dynamic>> createBooking({required int serviceId, String? description}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/bookings'),
      headers: _headers,
      body: jsonEncode({
        'service_id': serviceId,
        'description': description,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateBookingStatus(int bookingId, String status) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/bookings/$bookingId/status'),
      headers: _headers,
      body: jsonEncode({'status': status}),
    );
    return jsonDecode(response.body);
  }

  // Provider
  Future<List<TopProvider>> getProviders({int? categoryId}) async {
    String url = '$_baseUrl/providers?';
    if (categoryId != null) url += 'category=$categoryId';

    final response = await http.get(Uri.parse(url), headers: _headers);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      // Reusing TopProvider model for basic list
      return data.map((item) => TopProvider.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load providers');
    }
  }

  Future<Map<String, dynamic>> getProviderDetails(String providerProfileId) async {
    final response = await http.get(Uri.parse('$_baseUrl/providers/$providerProfileId'), headers: _headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load provider details');
    }
  }

  // Messaging
  Future<List<Conversation>> getConversations() async {
    final response = await http.get(Uri.parse('$_baseUrl/messages/conversations'), headers: _headers);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Conversation.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load conversations');
    }
  }

  Future<List<ChatMessage>> getMessages(int bookingId) async {
    final response = await http.get(Uri.parse('$_baseUrl/messages/booking/$bookingId'), headers: _headers);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => ChatMessage.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<Map<String, dynamic>> sendMessage(int bookingId, String content) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/messages'),
      headers: _headers,
      body: jsonEncode({
        'booking_id': bookingId,
        'content': content,
      }),
    );
    return jsonDecode(response.body);
  }

  // Dashboard Enhancements
  Future<List<TopProvider>> getTopProviders() async {
    final response = await http.get(Uri.parse('$_baseUrl/providers/top'), headers: _headers);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => TopProvider.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load top providers');
    }
  }

  Future<Map<String, dynamic>> submitPlatformRating(int rating, String feedback) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ratings/platform'),
      headers: _headers,
      body: jsonEncode({
        'rating': rating,
        'feedback': feedback,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateCustomerProfile({
    required String name,
    required String email,
    XFile? profileImage,
  }) async {
    final request = http.MultipartRequest('PUT', Uri.parse('$_baseUrl/customer/profile'));
    if (_token != null) {
      request.headers['Authorization'] = 'Bearer $_token';
    }
    
    request.fields['name'] = name;
    request.fields['email'] = email;

    if (profileImage != null) {
      final bytes = await profileImage.readAsBytes();
      String fName = profileImage.name;
      if (fName.isEmpty || fName.contains(r'\')) fName = 'profileImage.jpg';
      request.files.add(http.MultipartFile.fromBytes('profileImage', bytes, filename: fName));
    }

    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final message = jsonDecode(response.body)['message'] ?? 'Failed to update profile';
      throw Exception(message);
    }
  }

  Future<List<Complaint>> getMyComplaints() async {
    final response = await http.get(Uri.parse('$_baseUrl/complaints/my'), headers: _headers);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Complaint.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load my complaints');
    }
  }

  Future<void> submitReview({
    required int bookingId,
    required double rating,
    required String comment,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/reviews'),
      headers: _headers,
      body: jsonEncode({
        'booking_id': bookingId,
        'rating': rating,
        'comment': comment,
      }),
    );
    if (response.statusCode != 201) {
      final message = jsonDecode(response.body)['message'] ?? 'Failed to submit review';
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> submitComplaint({
    required String subject,
    required String description,
    String priority = 'medium',
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/complaints'),
      headers: _headers,
      body: jsonEncode({
        'subject': subject,
        'description': description,
        'priority': priority,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<ProviderStats> getProviderStats() async {
    final response = await http.get(Uri.parse('$_baseUrl/providers/stats'), headers: _headers);
    if (response.statusCode == 200) {
      return ProviderStats.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load provider stats');
    }
  }

  Future<CustomerStats> getCustomerStats() async {
    final response = await http.get(Uri.parse('$_baseUrl/customer/stats'), headers: _headers);
    if (response.statusCode == 200) {
      return CustomerStats.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load customer stats');
    }
  }

  Future<AdminStats> getAdminStats() async {
    final response = await http.get(Uri.parse('$_baseUrl/admin/stats'), headers: _headers);
    debugPrint('Admin Stats Status: ${response.statusCode}');
    if (response.statusCode == 200) {
      return AdminStats.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load admin stats');
    }
  }

  Future<List<Booking>> getProviderBookings({String? status}) async {
    String url = '$_baseUrl/bookings/provider?';
    if (status != null) url += 'status=$status';
    final response = await http.get(Uri.parse(url), headers: _headers);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Booking.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load provider bookings');
    }
  }

  Future<List<Review>> getProviderReviews() async {
    final response = await http.get(Uri.parse('$_baseUrl/reviews/me'), headers: _headers);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Review.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load provider reviews');
    }
  }

  Future<Map<String, dynamic>> getProviderProfile() async {
    final response = await http.get(Uri.parse('$_baseUrl/providers/profile/me'), headers: _headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load provider profile');
    }
  }

  Future<Map<String, dynamic>> updateProviderProfile({
    required String name,
    required String bio,
    required String phone,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/providers/profile'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'bio': bio,
        'phone': phone,
      }),
    );
    return jsonDecode(response.body);
  }

  // Admin Endpoints
  Future<List<Booking>> getAdminBookings() async {
    final response = await http.get(Uri.parse('$_baseUrl/admin/bookings'), headers: _headers);
    debugPrint('Admin Bookings Status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is! List) throw Exception('Expected list of bookings, but got: $decoded');
      return decoded.map((item) => Booking.fromJson(item)).toList();
    } else {
      final msg = jsonDecode(response.body)['message'] ?? 'Status ${response.statusCode}';
      throw Exception('Failed to load all bookings: $msg');
    }
  }

  Future<List<User>> getAdminUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/admin/users'), headers: _headers);
    debugPrint('Admin Users Status: ${response.statusCode}');
    debugPrint('Admin Users Body: ${response.body}');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is! List) throw Exception('Expected list of users, but got: $decoded');
      return decoded.map((item) => User.fromJson(item)).toList();
    } else {
       final msg = jsonDecode(response.body)['message'] ?? 'Status ${response.statusCode}';
      throw Exception('Failed to load users: $msg');
    }
  }

  Future<List<Complaint>> getAdminComplaints() async {
    final response = await http.get(Uri.parse('$_baseUrl/admin/complaints'), headers: _headers);
    debugPrint('Admin Complaints Status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is! List) throw Exception('Expected list of complaints, but got: $decoded');
      return decoded.map((item) => Complaint.fromJson(item)).toList();
    } else {
      final msg = jsonDecode(response.body)['message'] ?? 'Status ${response.statusCode}';
      throw Exception('Failed to load complaints: $msg');
    }
  }

  Future<AdminSubscriptionData> getAdminSubscriptions() async {
    final response = await http.get(Uri.parse('$_baseUrl/admin/subscriptions'), headers: _headers);
    debugPrint('Admin Subs Status: ${response.statusCode}');
    debugPrint('Admin Subs Body: ${response.body}');
    if (response.statusCode == 200) {
      return AdminSubscriptionData.fromJson(jsonDecode(response.body));
    } else {
      final msg = jsonDecode(response.body)['message'] ?? 'Status ${response.statusCode}';
      throw Exception('Failed to load subscriptions: $msg');
    }
  }

  Future<List<VerificationUser>> getPendingVerifications() async {
    final response = await http.get(Uri.parse('$_baseUrl/admin/pending-users'), headers: _headers);
    debugPrint('Admin Pending Users Status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is! List) throw Exception('Expected list of users, but got: $decoded');
      return decoded.map((item) => VerificationUser.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load pending verifications');
    }
  }

  Future<void> approveProvider(String userId) async {
    final response = await http.post(Uri.parse('$_baseUrl/admin/approve/$userId'), headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to approve user: ${jsonDecode(response.body)['message']}');
    }
  }

  Future<void> rejectProvider(String userId, String reason) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/admin/reject/$userId'),
      headers: _headers,
      body: jsonEncode({'rejection_reason': reason}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to reject user: ${jsonDecode(response.body)['message']}');
    }
  }

  Future<Map<String, dynamic>> createCategory({required String name, String? iconUrl}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/categories'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'icon_url': iconUrl,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create category: ${jsonDecode(response.body)['message']}');
    }
  }

  Future<Map<String, dynamic>> replyToComplaint(int complaintId, String reply) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/complaints/$complaintId/reply'),
      headers: _headers,
      body: jsonEncode({'reply': reply}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to reply to complaint: ${jsonDecode(response.body)['message']}');
    }
  }
}
