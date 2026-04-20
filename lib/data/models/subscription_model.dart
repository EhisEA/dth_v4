int _asInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) {
    final normalized = v.trim().replaceAll(",", "");
    if (normalized.isEmpty) return 0;
    final asDouble = double.tryParse(normalized);
    if (asDouble != null) return asDouble.round();
    return int.tryParse(normalized) ?? 0;
  }
  // e.g. custom numeric types that are not `num` in Dart
  final parsed = double.tryParse(v.toString().replaceAll(",", ""));
  if (parsed != null) return parsed.round();
  return 0;
}

List<dynamic> _featuresFromJson(dynamic raw) {
  if (raw is! List<dynamic>) return [];
  return List<dynamic>.from(raw);
}

List<String> _permissionsFromJson(dynamic raw) {
  if (raw is! List<dynamic>) return [];
  return raw
      .map((x) => x?.toString() ?? "")
      .where((s) => s.isNotEmpty)
      .toList();
}

class SubscriptionModel {
  final String uid;
  final String name;
  final String slug;
  final dynamic tag;
  final int order;
  final int amount;
  final String currency;
  final int amountUsd;
  final String description;
  final List<dynamic> features;
  final List<String> permissions;
  final Perks perks;

  SubscriptionModel({
    required this.uid,
    required this.name,
    required this.slug,
    required this.tag,
    required this.order,
    required this.amount,
    required this.currency,
    required this.amountUsd,
    required this.description,
    required this.features,
    required this.permissions,
    required this.perks,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    final perksRaw = json["perks"];
    return SubscriptionModel(
      uid: json["uid"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      slug: json["slug"]?.toString() ?? "",
      tag: json["tag"],
      order: _asInt(json["order"]),
      amount: _asInt(json["amount"]),
      currency: json["currency"]?.toString() ?? "",
      amountUsd: _asInt(json["amount_usd"]),
      description: json["description"]?.toString() ?? "",
      features: _featuresFromJson(json["features"]),
      permissions: _permissionsFromJson(json["permissions"]),
      perks: perksRaw is Map<String, dynamic>
          ? Perks.fromJson(Map<String, dynamic>.from(perksRaw))
          : Perks(priority: false),
    );
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "slug": slug,
    "tag": tag,
    "order": order,
    "amount": amount,
    "currency": currency,
    "amount_usd": amountUsd,
    "description": description,
    "features": List<dynamic>.from(features.map((x) => x)),
    "permissions": List<dynamic>.from(permissions.map((x) => x)),
    "perks": perks.toJson(),
  };
}

class Perks {
  final bool priority;

  Perks({required this.priority});

  factory Perks.fromJson(Map<String, dynamic> json) =>
      Perks(priority: json["priority"] == true);

  Map<String, dynamic> toJson() => {"priority": priority};
}
