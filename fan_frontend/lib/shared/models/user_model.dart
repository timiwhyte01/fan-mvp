class User {
  final int id;
  final String phone;
  final String? email;
  final String firstName;
  final String lastName;
  final String? bvn;
  final String? nin;
  final DateTime? dateOfBirth;
  final String? address;
  final int kycLevel;
  final double creditLimit;
  final String status;
  final String userType;
  final DateTime createdAt;

  User({
    required this.id,
    required this.phone,
    this.email,
    required this.firstName,
    required this.lastName,
    this.bvn,
    this.nin,
    this.dateOfBirth,
    this.address,
    required this.kycLevel,
    required this.creditLimit,
    required this.status,
    required this.userType,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phone: json['phone'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      bvn: json['bvn'],
      nin: json['nin'],
      dateOfBirth: json['date_of_birth'] != null 
          ? DateTime.parse(json['date_of_birth']) 
          : null,
      address: json['address'],
      kycLevel: json['kyc_level'],
      creditLimit: json['credit_limit'].toDouble(),
      status: json['status'],
      userType: json['user_type'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'bvn': bvn,
      'nin': nin,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'address': address,
      'kyc_level': kycLevel,
      'credit_limit': creditLimit,
      'status': status,
      'user_type': userType,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName';
}
