enum TripStatus {
  proposed,
  depositPending,
  depositBlocked,
  depositConfirmed,
  confirmed,
  inProgress,
  completed,
  cancelled,
  disputed,
}

class Trip {
  final String id;
  final String maleUserId;
  final String femaleUserId;
  final String destination;
  final DateTime departureDate;
  final DateTime returnDate;
  final TripStatus status;
  final String? depositId;
  final String? notes;
  final double? maleRating;
  final double? femaleRating;
  final String? maleReview;
  final String? femaleReview;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? cancelledAt;

  const Trip({
    required this.id,
    required this.maleUserId,
    required this.femaleUserId,
    required this.destination,
    required this.departureDate,
    required this.returnDate,
    this.status = TripStatus.proposed,
    this.depositId,
    this.notes,
    this.maleRating,
    this.femaleRating,
    this.maleReview,
    this.femaleReview,
    required this.createdAt,
    this.confirmedAt,
    this.cancelledAt,
  });

  int get durationDays => returnDate.difference(departureDate).inDays;

  bool get isActive =>
      status == TripStatus.confirmed || status == TripStatus.inProgress;

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      maleUserId: json['male_user_id'] as String,
      femaleUserId: json['female_user_id'] as String,
      destination: json['destination'] as String,
      departureDate: DateTime.parse(json['departure_date'] as String),
      returnDate: DateTime.parse(json['return_date'] as String),
      status: TripStatus.values.byName(json['status'] as String? ?? 'proposed'),
      depositId: json['deposit_id'] as String?,
      notes: json['notes'] as String?,
      maleRating: (json['male_rating'] as num?)?.toDouble(),
      femaleRating: (json['female_rating'] as num?)?.toDouble(),
      maleReview: json['male_review'] as String?,
      femaleReview: json['female_review'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.parse(json['confirmed_at'] as String)
          : null,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'male_user_id': maleUserId,
      'female_user_id': femaleUserId,
      'destination': destination,
      'departure_date': departureDate.toIso8601String().split('T').first,
      'return_date': returnDate.toIso8601String().split('T').first,
      'status': status.name,
      'deposit_id': depositId,
      'notes': notes,
      'male_rating': maleRating,
      'female_rating': femaleRating,
      'male_review': maleReview,
      'female_review': femaleReview,
      'created_at': createdAt.toIso8601String(),
      'confirmed_at': confirmedAt?.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
    };
  }
}
