enum DepositStatus {
  pending,
  blocked,
  confirmedByHer,
  released,
  refunded,
  disputed,
}

class Deposit {
  final String id;
  final String tripId;
  final String maleUserId;
  final String femaleUserId;
  final double amount;
  final String currency;
  final DepositStatus status;
  final String? stripePaymentIntentId;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? releasedAt;

  const Deposit({
    required this.id,
    required this.tripId,
    required this.maleUserId,
    required this.femaleUserId,
    this.amount = 2500.0,
    this.currency = 'USD',
    this.status = DepositStatus.pending,
    this.stripePaymentIntentId,
    required this.createdAt,
    this.confirmedAt,
    this.releasedAt,
  });

  bool get isConfirmed => status == DepositStatus.confirmedByHer;
  bool get isBlocked => status == DepositStatus.blocked;

  factory Deposit.fromJson(Map<String, dynamic> json) {
    return Deposit(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      maleUserId: json['male_user_id'] as String,
      femaleUserId: json['female_user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      status: DepositStatus.values.byName(json['status'] as String? ?? 'pending'),
      stripePaymentIntentId: json['stripe_payment_intent_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.parse(json['confirmed_at'] as String)
          : null,
      releasedAt: json['released_at'] != null
          ? DateTime.parse(json['released_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trip_id': tripId,
      'male_user_id': maleUserId,
      'female_user_id': femaleUserId,
      'amount': amount,
      'currency': currency,
      'status': status.name,
      'stripe_payment_intent_id': stripePaymentIntentId,
      'created_at': createdAt.toIso8601String(),
      'confirmed_at': confirmedAt?.toIso8601String(),
      'released_at': releasedAt?.toIso8601String(),
    };
  }
}
