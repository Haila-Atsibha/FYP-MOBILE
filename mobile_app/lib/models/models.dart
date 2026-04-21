class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final String? profileImageUrl;
  final String? nationalIdUrl;
  final String? verificationSelfieUrl;
  final List<Map<String, dynamic>>? educationalDocuments;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    this.profileImageUrl,
    this.nationalIdUrl,
    this.verificationSelfieUrl,
    this.educationalDocuments,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown User',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      status: json['status'] ?? 'pending',
      profileImageUrl: json['profile_image_url'],
      nationalIdUrl: json['national_id_url'],
      verificationSelfieUrl: json['verification_selfie_url'],
      educationalDocuments: json['educational_documents'] != null
          ? List<Map<String, dynamic>>.from(json['educational_documents'])
          : null,
    );
  }
}

class Service {
  final int id;
  final String title;
  final String? description;
  final double price;
  final int categoryId;
  final String? categoryName;
  final String? providerName;

  Service({
    required this.id,
    required this.title,
    this.description,
    required this.price,
    required this.categoryId,
    this.categoryName,
    this.providerName,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? 'Untitled Service',
      description: json['description']?.toString(),
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      categoryId: json['category_id'] is int ? json['category_id'] : int.tryParse(json['category_id']?.toString() ?? '') ?? 0,
      categoryName: json['category_name']?.toString(),
      providerName: json['provider_name']?.toString(),
    );
  }
}

class Category {
  final int id;
  final String name;
  final String? iconUrl;

  Category({required this.id, required this.name, this.iconUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      iconUrl: json['icon_url'],
    );
  }
}

class Booking {
  final int id;
  final int serviceId;
  final String customerId;
  final String status;
  final DateTime createdAt;
  final Service? service;
  final String? customerName;
  final String? title;
  final String? providerName;
  final double? totalPrice;
  final String? description;
  final bool isReviewed;

  Booking({
    required this.id,
    required this.serviceId,
    required this.customerId,
    this.customerName,
    required this.status,
    required this.createdAt,
    this.service,
    this.title,
    this.providerName,
    this.totalPrice,
    this.description,
    this.isReviewed = false,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    // Handle cases where 'service' might be a string (title) or a map
    Service? serviceData;
    String? bookingTitle;
    
    if (json['service'] != null) {
      if (json['service'] is Map<String, dynamic>) {
        serviceData = Service.fromJson(json['service']);
      } else if (json['service'] is String) {
        bookingTitle = json['service'];
      }
    }

    return Booking(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      serviceId: json['service_id'] is int ? json['service_id'] : int.tryParse(json['service_id']?.toString() ?? '') ?? 0,
      customerId: (json['customer_id'] ?? '').toString(),
      customerName: json['customer_name'] ?? json['customer']?.toString() ?? 'Unknown Customer',
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now() : DateTime.now(),
      service: serviceData,
      title: bookingTitle ?? json['title']?.toString(),
      providerName: json['provider_name'] ?? json['provider']?.toString(),
      totalPrice: double.tryParse((json['total_price'] ?? json['price'] ?? '0').toString()),
      description: json['description']?.toString(),
      isReviewed: json['is_reviewed'] == true || json['is_reviewed'] == 1,
    );
  }
}

class Conversation {
  final int bookingId;
  final String bookingStatus;
  final String serviceTitle;
  final String partnerName;
  final String partnerId;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  Conversation({
    required this.bookingId,
    required this.bookingStatus,
    required this.serviceTitle,
    required this.partnerName,
    required this.partnerId,
    this.lastMessage,
    this.lastMessageTime,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      bookingId: json['booking_id'],
      bookingStatus: json['booking_status'],
      serviceTitle: json['service_title'],
      partnerName: json['partner_name'],
      partnerId: json['partner_id'].toString(),
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'] != null ? DateTime.parse(json['last_message_time']) : null,
    );
  }
}

class ChatMessage {
  final int id;
  final int bookingId;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final String? senderName;

  ChatMessage({
    required this.id,
    required this.bookingId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    this.senderName,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      bookingId: json['booking_id'],
      senderId: json['sender_id'].toString(),
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      senderName: json['sender_name'],
    );
  }
}

class TopProvider {
  final String id; // user id
  final String providerProfileId;
  final String name;
  final String? profileImageUrl;
  final String? bio;
  final double averageRating;
  final int completedJobs;
  final String? category;

  TopProvider({
    required this.id,
    required this.providerProfileId,
    required this.name,
    this.profileImageUrl,
    this.bio,
    required this.averageRating,
    required this.completedJobs,
    this.category,
  });

  factory TopProvider.fromJson(Map<String, dynamic> json) {
    return TopProvider(
      id: json['id'].toString(),
      providerProfileId: json['provider_profile_id']?.toString() ?? '',
      name: json['name'],
      profileImageUrl: json['profile_image_url'],
      bio: json['bio'],
      averageRating: double.parse((json['average_rating'] ?? 0).toString()),
      completedJobs: int.parse((json['completedJobs'] ?? 0).toString()),
      category: json['category'],
    );
  }
}

class ProviderDetail {
  final String name;
  final String? profileImageUrl;
  final String providerProfileId;
  final String? bio;
  final double averageRating;
  final String userId;
  final List<Service> services;

  ProviderDetail({
    required this.name,
    this.profileImageUrl,
    required this.providerProfileId,
    this.bio,
    required this.averageRating,
    required this.userId,
    required this.services,
  });

  factory ProviderDetail.fromJson(Map<String, dynamic> json) {
    var servicesList = json['services'] as List;
    return ProviderDetail(
      name: json['name'],
      profileImageUrl: json['profile_image_url'],
      providerProfileId: json['provider_profile_id'].toString(),
      bio: json['bio'],
      averageRating: double.parse((json['average_rating'] ?? 0).toString()),
      userId: json['user_id'].toString(),
      services: servicesList.map((i) => Service.fromJson(i)).toList(),
    );
  }
}

class ProviderStats {
  final int pendingRequests;
  final int activeBookings;
  final int completedJobs;
  final double totalEarnings;
  final double averageRating;
  final int totalReviews;
  final String? subscriptionStatus;
  final DateTime? subscriptionExpiry;

  ProviderStats({
    required this.pendingRequests,
    required this.activeBookings,
    required this.completedJobs,
    required this.totalEarnings,
    required this.averageRating,
    required this.totalReviews,
    this.subscriptionStatus,
    this.subscriptionExpiry,
  });

  factory ProviderStats.fromJson(Map<String, dynamic> json) {
    return ProviderStats(
      pendingRequests: json['pendingRequests'] ?? 0,
      activeBookings: json['activeBookings'] ?? 0,
      completedJobs: json['completedJobs'] ?? 0,
      totalEarnings: double.parse((json['totalEarnings'] ?? 0).toString()),
      averageRating: double.parse((json['averageRating'] ?? 0).toString()),
      totalReviews: json['totalReviews'] ?? 0,
      subscriptionStatus: json['subscriptionStatus'],
      subscriptionExpiry: json['subscriptionExpiry'] != null ? DateTime.parse(json['subscriptionExpiry']) : null,
    );
  }
}

class AdminStats {
  final int totalUsers;
  final int totalBookings;
  final int activeBookings;
  final int completedBookings;
  final int rejectedBookings;
  final double totalRevenue;
  final String avgRating;
  final Map<String, dynamic>? monthlyData;
  final Map<String, dynamic>? revenueData;
  final int activeSubscribers;
  final double subscriptionRevenue;

  AdminStats({
    required this.totalUsers,
    required this.totalBookings,
    required this.activeBookings,
    required this.completedBookings,
    required this.rejectedBookings,
    required this.totalRevenue,
    required this.avgRating,
    this.monthlyData,
    this.revenueData,
    required this.activeSubscribers,
    required this.subscriptionRevenue,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      totalUsers: json['totalUsers'] ?? 0,
      totalBookings: json['totalBookings'] ?? 0,
      activeBookings: json['activeBookings'] ?? 0,
      completedBookings: json['completedBookings'] ?? 0,
      rejectedBookings: json['rejectedBookings'] ?? 0,
      totalRevenue: double.parse((json['totalRevenue'] ?? 0).toString()),
      avgRating: json['avgRating'] ?? '0/5',
      monthlyData: json['monthlyData'],
      revenueData: json['revenueData'],
      activeSubscribers: json['activeSubscribers'] ?? 0,
      subscriptionRevenue: double.parse((json['subscriptionRevenue'] ?? 0).toString()),
    );
  }
}

class Review {
  final int id;
  final int bookingId;
  final int? providerId;
  final int? serviceId;
  final String customerId;
  final double rating;
  final String? comment;
  final DateTime createdAt;
  final String? customerName;
  final String? serviceTitle;

  Review({
    required this.id,
    required this.bookingId,
    this.providerId,
    this.serviceId,
    required this.customerId,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.customerName,
    this.serviceTitle,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      bookingId: json['booking_id'],
      providerId: json['provider_id'],
      serviceId: json['service_id'],
      customerId: json['customer_id'].toString(),
      rating: double.parse((json['rating'] ?? 0).toString()),
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
      customerName: json['customer_name'],
      serviceTitle: json['service_title'],
    );
  }
}

class Complaint {
  final int id;
  final String userId;
  final String userName;
  final String subject;
  final String description;
  final String status;
  final String priority;
  final String? adminReply;
  final DateTime? repliedAt;
  final DateTime createdAt;

  Complaint({
    required this.id,
    required this.userId,
    required this.userName,
    required this.subject,
    required this.description,
    required this.status,
    required this.priority,
    this.adminReply,
    this.repliedAt,
    required this.createdAt,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name'] ?? json['userName'] ?? 'User',
      subject: json['subject'] ?? 'No Subject',
      description: json['description'] ?? '',
      status: json['status'] ?? 'open',
      priority: json['priority'] ?? 'medium',
      adminReply: json['admin_reply'],
      repliedAt: json['replied_at'] != null ? DateTime.parse(json['replied_at']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }
}

class AdminSubscriptionData {
  final double monthlyRevenue;
  final int activePremium;
  final int expiringSoon;
  final List<AdminPaymentHistory> history;

  AdminSubscriptionData({
    required this.monthlyRevenue,
    required this.activePremium,
    required this.expiringSoon,
    required this.history,
  });

  factory AdminSubscriptionData.fromJson(Map<String, dynamic> json) {
    var historyList = (json['history'] as List?) ?? [];
    return AdminSubscriptionData(
      monthlyRevenue: double.tryParse((json['monthlyRevenue'] ?? 0).toString()) ?? 0.0,
      activePremium: int.tryParse((json['activePremium'] ?? 0).toString()) ?? 0,
      expiringSoon: int.tryParse((json['expiringSoon'] ?? 0).toString()) ?? 0,
      history: historyList.map((i) => AdminPaymentHistory.fromJson(i)).toList(),
    );
  }
}

class AdminPaymentHistory {
  final int id;
  final String providerName;
  final double amount;
  final String status;
  final DateTime date;
  final String? txRef;

  AdminPaymentHistory({
    required this.id,
    required this.providerName,
    required this.amount,
    required this.status,
    required this.date,
    this.txRef,
  });

  factory AdminPaymentHistory.fromJson(Map<String, dynamic> json) {
    return AdminPaymentHistory(
      id: int.tryParse((json['id'] ?? 0).toString()) ?? 0,
      providerName: json['providerName'] ?? 'Provider',
      amount: double.tryParse((json['amount'] ?? 0).toString()) ?? 0.0,
      status: json['status'] ?? 'unknown',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      txRef: json['tx_ref'],
    );
  }
}

class VerificationUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? profileImageUrl;
  final String? nationalIdUrl;
  final String? selfieUrl;
  final List<Map<String, dynamic>>? educationalDocuments;

  VerificationUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImageUrl,
    this.nationalIdUrl,
    this.selfieUrl,
    this.educationalDocuments,
  });

  factory VerificationUser.fromJson(Map<String, dynamic> json) {
    return VerificationUser(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user', // Retained from original, added null-safety
      profileImageUrl: json['profile_image_url'],
      nationalIdUrl: json['national_id_url'],
      selfieUrl: json['verification_selfie_url'],
      educationalDocuments: json['educational_documents'] != null
          ? List<Map<String, dynamic>>.from(json['educational_documents'])
          : null,
    );
  }
}

class CustomerStats {
  final int inProgress;
  final int completed;
  final int notifications;
  final int saved;

  CustomerStats({
    required this.inProgress,
    required this.completed,
    required this.notifications,
    required this.saved,
  });

  factory CustomerStats.fromJson(Map<String, dynamic> json) {
    return CustomerStats(
      inProgress: json['active'] ?? 0,
      completed: json['completed'] ?? 0,
      notifications: json['unread'] ?? 0,
      saved: json['saved'] ?? 0,
    );
  }
}

class PaymentTransaction {
  final int id;
  final String txRef;
  final double amount;
  final String status;
  final String method;
  final DateTime createdAt;

  PaymentTransaction({
    required this.id,
    required this.txRef,
    required this.amount,
    required this.status,
    required this.method,
    required this.createdAt,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: int.tryParse(json['id'].toString()) ?? 0,
      txRef: json['tx_ref']?.toString() ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      status: json['status']?.toString() ?? 'unknown',
      method: json['payment_method']?.toString() ?? 'chapa',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'].toString()) : DateTime.now(),
    );
  }
}
