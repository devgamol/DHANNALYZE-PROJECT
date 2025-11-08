class CustomerProfile {
  final String id;
  final String pan;
  final String aadhaar;
  final String email;
  final bool twoFAEnabled;

  CustomerProfile({
    required this.id,
    required this.pan,
    required this.aadhaar,
    required this.email,
    required this.twoFAEnabled,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      id: json['_id'] ?? '',
      pan: json['pan'] ?? '',
      aadhaar: json['aadhaar'] ?? '',
      email: json['email'] ?? '',
      twoFAEnabled: json['twoFAEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pan': pan,
      'aadhaar': aadhaar,
      'email': email,
      'twoFAEnabled': twoFAEnabled,
    };
  }
}
