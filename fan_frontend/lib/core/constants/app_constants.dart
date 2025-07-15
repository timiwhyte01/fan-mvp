class AppConstants {
  static const String appName = 'Fuel Advance Network';
  static const String appVersion = '1.0.0';
  
  static const String baseUrl = 'http://localhost:8000';
  
  static const double defaultCreditLimit = 5000.0;
  static const int otpExpiryMinutes = 5;
  static const int advanceExpiryHours = 24;
  
  static const Map<int, double> kycLimits = {
    1: 5000.0,
    2: 25000.0,
    3: 100000.0,
  };
  
  static const List<String> paymentMethods = [
    'Bank Transfer',
    'Card Payment',
    'USSD',
    'Auto Deduction'
  ];
  
  static const String currency = '₦';
}

class ApiEndpoints {
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String createTransaction = '/transactions/create';
  static const String myTransactions = '/transactions/my';
  static const String scanQr = '/transactions/scan-qr';
  static const String createPayment = '/payments/create';
  static const String myPayments = '/payments/my';
  static const String stations = '/stations';
  static const String nearbyStations = '/stations/nearby';
}
