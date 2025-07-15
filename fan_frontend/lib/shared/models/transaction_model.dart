class Transaction {
  final int id;
  final int userId;
  final int? stationId;
  final double amount;
  final String qrCode;
  final String status;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime? completedAt;

  Transaction({
    required this.id,
    required this.userId,
    this.stationId,
    required this.amount,
    required this.qrCode,
    required this.status,
    required this.expiresAt,
    required this.createdAt,
    this.completedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['user_id'],
      stationId: json['station_id'],
      amount: json['amount'].toDouble(),
      qrCode: json['qr_code'],
      status: json['status'],
      expiresAt: DateTime.parse(json['expires_at']),
      createdAt: DateTime.parse(json['created_at']),
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at']) 
          : null,
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
  
  Duration get timeRemaining {
    if (isExpired) return Duration.zero;
    return expiresAt.difference(DateTime.now());
  }
}

class Payment {
  final int id;
  final int transactionId;
  final int userId;
  final double amount;
  final String method;
  final String reference;
  final String status;
  final DateTime createdAt;
  final DateTime? processedAt;

  Payment({
    required this.id,
    required this.transactionId,
    required this.userId,
    required this.amount,
    required this.method,
    required this.reference,
    required this.status,
    required this.createdAt,
    this.processedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      transactionId: json['transaction_id'],
      userId: json['user_id'],
      amount: json['amount'].toDouble(),
      method: json['method'],
      reference: json['reference'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      processedAt: json['processed_at'] != null 
          ? DateTime.parse(json['processed_at']) 
          : null,
    );
  }

  bool get isCompleted => status == 'completed';
  bool get isPending => status == 'pending';
}
