class PartnerStation {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? contactPhone;
  final String? contactEmail;
  final String? operatingHours;
  final String status;
  final DateTime createdAt;

  PartnerStation({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.contactPhone,
    this.contactEmail,
    this.operatingHours,
    required this.status,
    required this.createdAt,
  });

  factory PartnerStation.fromJson(Map<String, dynamic> json) {
    return PartnerStation(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      contactPhone: json['contact_phone'],
      contactEmail: json['contact_email'],
      operatingHours: json['operating_hours'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  bool get isActive => status == 'active';
}
