class SubscriptionPurchaseInit {
  const SubscriptionPurchaseInit({
    required this.authorizationUrl,
    required this.reference,
    required this.callbackUrl,
  });

  final String authorizationUrl;
  final String reference;
  final String callbackUrl;

  factory SubscriptionPurchaseInit.fromJson(Map<String, dynamic> json) {
    return SubscriptionPurchaseInit(
      authorizationUrl: json["authorization_url"]?.toString() ?? "",
      reference: json["reference"]?.toString() ?? "",
      callbackUrl: json["callback_url"]?.toString() ?? "",
    );
  }
}
