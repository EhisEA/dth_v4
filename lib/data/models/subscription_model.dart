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
  final parsed = double.tryParse(v.toString().replaceAll(",", ""));
  if (parsed != null) return parsed.round();
  return 0;
}

double? _nullableDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is num) return v.toDouble();
  if (v is String) {
    final s = v.trim().replaceAll(",", "");
    if (s.isEmpty) return null;
    return double.tryParse(s);
  }
  return double.tryParse(v.toString().replaceAll(",", ""));
}

int? _nullableInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) {
    final s = v.trim();
    if (s.isEmpty) return null;
    return int.tryParse(s) ?? double.tryParse(s)?.toInt();
  }
  return int.tryParse(v.toString());
}

bool _asBool(dynamic v) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final s = v.toLowerCase();
    return s == "true" || s == "1" || s == "yes";
  }
  return false;
}

String? _nullableString(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty ? null : s;
}

List<String> _featuresFromJson(dynamic raw) {
  if (raw is! List<dynamic>) return [];
  return raw
      .map((e) => e?.toString().trim() ?? "")
      .where((s) => s.isNotEmpty)
      .toList();
}

List<String> _permissionsFromJson(dynamic raw) {
  if (raw is! List<dynamic>) return [];
  return raw
      .map((x) => x?.toString() ?? "")
      .where((s) => s.isNotEmpty)
      .toList();
}

/// API `perks` object on a plan (e.g. vote caps / weights).
class PlanPerks {
  const PlanPerks({
    this.voteCount,
    this.voteWeight,
    this.pollVoteWeight,
    this.minVote,
  });

  final int? voteCount;
  final int? voteWeight;
  final int? pollVoteWeight;
  final int? minVote;

  factory PlanPerks.fromJson(dynamic raw) {
    if (raw is! Map) return const PlanPerks();
    final m = Map<String, dynamic>.from(raw);
    return PlanPerks(
      voteCount: _nullableInt(m["vote_count"]),
      voteWeight: _nullableInt(m["vote_weight"]),
      pollVoteWeight: _nullableInt(m["poll_vote_weight"]),
      minVote: _nullableInt(m["min_vote"]),
    );
  }

  Map<String, dynamic> toJson() => {
    if (voteCount != null) "vote_count": voteCount,
    if (voteWeight != null) "vote_weight": voteWeight,
    if (pollVoteWeight != null) "poll_vote_weight": pollVoteWeight,
    if (minVote != null) "min_vote": minVote,
  };
}

class SubscriptionModel {
  const SubscriptionModel({
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
    required this.isActiveSubscription,
  });

  final String uid;
  final String name;
  final String slug;
  final String? tag;
  final int order;

  /// Whole currency units (API may send decimals; stored rounded for display).
  final int amount;
  final String currency;
  final double? amountUsd;
  final String description;
  final List<String> features;
  final List<String> permissions;
  final PlanPerks perks;
  final bool isActiveSubscription;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    final perksRaw = json["perks"];
    return SubscriptionModel(
      uid: json["uid"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      slug: json["slug"]?.toString() ?? "",
      tag: _nullableString(json["tag"]),
      order: _asInt(json["order"]),
      amount: _asInt(json["amount"]),
      currency: json["currency"]?.toString() ?? "",
      amountUsd: _nullableDouble(json["amount_usd"]),
      description: json["description"]?.toString() ?? "",
      features: _featuresFromJson(json["features"]),
      permissions: _permissionsFromJson(json["permissions"]),
      perks: PlanPerks.fromJson(perksRaw),
      isActiveSubscription: _asBool(json["is_active_subscription"]),
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
    "features": features,
    "permissions": permissions,
    "perks": perks.toJson(),
    "is_active_subscription": isActiveSubscription,
  };
}

/// Negative if [a] is a lower tier than [b], positive if higher, zero if tied.
int compareSubscriptionPlanTier(SubscriptionModel a, SubscriptionModel b) {
  final byOrder = a.order.compareTo(b.order);
  if (byOrder != 0) return byOrder;
  final byAmount = a.amount.compareTo(b.amount);
  if (byAmount != 0) return byAmount;
  return a.uid.compareTo(b.uid);
}
