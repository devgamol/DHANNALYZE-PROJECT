class OtpResponse {
  final String message;
  final String? customerId;

  OtpResponse({
    required this.message,
    this.customerId,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      message: json['message'] ?? '',
      customerId: json['customerId'],
    );
  }
}
