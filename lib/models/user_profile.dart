enum UserGender { male, female }

enum ApprovalStatus { pending, approved, rejected }

enum SubscriptionTier { none, silver, gold, platinum }

enum AvailabilityStatus { available, busy, offline }

class UserProfile {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final UserGender gender;
  final DateTime dateOfBirth;
  final String? bio;
  final List<String> photoUrls;
  final String? avatarUrl;
  final ApprovalStatus approvalStatus;
  final DateTime? approvalRequestedAt;
  final SubscriptionTier subscriptionTier;
  final AvailabilityStatus availability;
  final List<String> preferredDestinations;
  final List<String> interests;
  final List<String> languages;
  final String? city;
  final String? country;
  final String? occupation;
  final bool isVerified;
  final double? rating;
  final int completedTrips;
  final DateTime createdAt;
  final DateTime? lastActiveAt;

  const UserProfile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    this.bio,
    this.photoUrls = const [],
    this.avatarUrl,
    this.approvalStatus = ApprovalStatus.pending,
    this.approvalRequestedAt,
    this.subscriptionTier = SubscriptionTier.none,
    this.availability = AvailabilityStatus.offline,
    this.preferredDestinations = const [],
    this.interests = const [],
    this.languages = const [],
    this.city,
    this.country,
    this.occupation,
    this.isVerified = false,
    this.rating,
    this.completedTrips = 0,
    required this.createdAt,
    this.lastActiveAt,
  });

  String get fullName => '$firstName $lastName';

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  bool get isPaying => gender == UserGender.male && subscriptionTier != SubscriptionTier.none;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      gender: UserGender.values.byName(json['gender'] as String),
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      bio: json['bio'] as String?,
      photoUrls: List<String>.from(json['photo_urls'] ?? []),
      avatarUrl: json['avatar_url'] as String?,
      approvalStatus: ApprovalStatus.values.byName(json['approval_status'] as String? ?? 'pending'),
      approvalRequestedAt: json['approval_requested_at'] != null
          ? DateTime.parse(json['approval_requested_at'] as String)
          : null,
      subscriptionTier: SubscriptionTier.values.byName(json['subscription_tier'] as String? ?? 'none'),
      availability: AvailabilityStatus.values.byName(json['availability'] as String? ?? 'offline'),
      preferredDestinations: List<String>.from(json['preferred_destinations'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      city: json['city'] as String?,
      country: json['country'] as String?,
      occupation: json['occupation'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble(),
      completedTrips: json['completed_trips'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastActiveAt: json['last_active_at'] != null
          ? DateTime.parse(json['last_active_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender.name,
      'date_of_birth': dateOfBirth.toIso8601String().split('T').first,
      'bio': bio,
      'photo_urls': photoUrls,
      'avatar_url': avatarUrl,
      'approval_status': approvalStatus.name,
      'approval_requested_at': approvalRequestedAt?.toIso8601String(),
      'subscription_tier': subscriptionTier.name,
      'availability': availability.name,
      'preferred_destinations': preferredDestinations,
      'interests': interests,
      'languages': languages,
      'city': city,
      'country': country,
      'occupation': occupation,
      'is_verified': isVerified,
      'rating': rating,
      'completed_trips': completedTrips,
      'created_at': createdAt.toIso8601String(),
      'last_active_at': lastActiveAt?.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    UserGender? gender,
    DateTime? dateOfBirth,
    String? bio,
    List<String>? photoUrls,
    String? avatarUrl,
    ApprovalStatus? approvalStatus,
    DateTime? approvalRequestedAt,
    SubscriptionTier? subscriptionTier,
    AvailabilityStatus? availability,
    List<String>? preferredDestinations,
    List<String>? interests,
    List<String>? languages,
    String? city,
    String? country,
    String? occupation,
    bool? isVerified,
    double? rating,
    int? completedTrips,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bio: bio ?? this.bio,
      photoUrls: photoUrls ?? this.photoUrls,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      approvalRequestedAt: approvalRequestedAt ?? this.approvalRequestedAt,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      availability: availability ?? this.availability,
      preferredDestinations: preferredDestinations ?? this.preferredDestinations,
      interests: interests ?? this.interests,
      languages: languages ?? this.languages,
      city: city ?? this.city,
      country: country ?? this.country,
      occupation: occupation ?? this.occupation,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      completedTrips: completedTrips ?? this.completedTrips,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }
}
