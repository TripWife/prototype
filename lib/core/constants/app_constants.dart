class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'TripWife';
  static const String appTagline = 'Travel is better together';

  // Subscription Tiers
  static const double silverPrice = 199.0; // EUR/month
  static const double goldPrice = 399.0;
  static const double platinumPrice = 799.0;

  // Deposit
  static const double securityDeposit = 2500.0; // USD
  static const String depositCurrency = 'USD';

  // Approval
  static const int approvalHours = 72;

  // Video Call
  static const int maxCallDurationMinutes = 15;

  // Contacts per tier per month
  static const int silverContactsPerMonth = 3;
  static const int goldContactsPerMonth = 10;
  static const int platinumContactsPerMonth = -1; // unlimited

  // Video calls per week
  static const int silverCallsPerWeek = 2;
  static const int goldCallsPerWeek = -1; // unlimited
  static const int platinumCallsPerWeek = -1; // unlimited

  // Supabase (to be configured)
  static const String supabaseUrl = '';
  static const String supabaseAnonKey = '';

  // Agora (to be configured)
  static const String agoraAppId = '';

  // Stripe (to be configured)
  static const String stripePaymentUrl = '';
  static const String stripeDepositUrl = '';
}
