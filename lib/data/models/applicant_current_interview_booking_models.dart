// Models for `GET /applicant/interview-bookings/current` (`data` block).

class CurrentInterviewBookingCta {
  const CurrentInterviewBookingCta({required this.label, required this.url});

  final String label;
  final String url;

  factory CurrentInterviewBookingCta.fromJson(Map<String, dynamic> json) {
    return CurrentInterviewBookingCta(
      label: json["label"] as String? ?? "",
      url: json["url"] as String? ?? "",
    );
  }
}

class CurrentInterviewBookingPayload {
  const CurrentInterviewBookingPayload({
    required this.title,
    required this.subtitle,
    required this.joinUrl,
    required this.startsAt,
    this.cta,
  });

  final String title;
  final String subtitle;
  final String joinUrl;
  final DateTime? startsAt;
  final CurrentInterviewBookingCta? cta;

  factory CurrentInterviewBookingPayload.fromJson(Map<String, dynamic> json) {
    CurrentInterviewBookingCta? cta;
    final rawCta = json["cta"];
    if (rawCta is Map<String, dynamic>) {
      cta = CurrentInterviewBookingCta.fromJson(rawCta);
    }
    DateTime? startsAt;
    final rawStart = json["starts_at"];
    if (rawStart is String && rawStart.trim().isNotEmpty) {
      startsAt = DateTime.tryParse(rawStart.trim());
    }
    return CurrentInterviewBookingPayload(
      title: json["title"] as String? ?? "",
      subtitle: json["subtitle"] as String? ?? "",
      joinUrl: json["join_url"] as String? ?? "",
      startsAt: startsAt,
      cta: cta,
    );
  }
}
