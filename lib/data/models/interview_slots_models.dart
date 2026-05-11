// Models for `GET /applicant/interview-slots?date=YYYY-MM-DD`.

class InterviewSlot {
  const InterviewSlot({
    required this.uid,
    required this.startsAt,
    required this.endsAt,
    required this.remaining,
    required this.mode,
  });

  final String uid;
  final String startsAt;
  final String endsAt;
  final int remaining;
  final String mode;

  factory InterviewSlot.fromJson(Map<String, dynamic> json) {
    final rem = json["remaining"];
    return InterviewSlot(
      uid: json["uid"] as String? ?? "",
      startsAt: json["starts_at"] as String? ?? "",
      endsAt: json["ends_at"] as String? ?? "",
      remaining: rem is num ? rem.toInt() : 0,
      mode: json["mode"] as String? ?? "",
    );
  }
}

class InterviewDaySlots {
  const InterviewDaySlots({
    required this.label,
    required this.iso,
    required this.slots,
  });

  final String label;
  final String iso;
  final List<InterviewSlot> slots;

  factory InterviewDaySlots.fromJson(Map<String, dynamic> json) {
    final raw = json["slots"] as List<dynamic>? ?? const [];
    return InterviewDaySlots(
      label: json["label"] as String? ?? "",
      iso: json["iso"] as String? ?? "",
      slots: raw
          .map(
            (e) => InterviewSlot.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
    );
  }
}

class InterviewSlotsData {
  const InterviewSlotsData({
    required this.title,
    required this.subtitle,
    required this.days,
  });

  final String title;
  final String subtitle;
  final List<InterviewDaySlots> days;

  factory InterviewSlotsData.fromJson(Map<String, dynamic> json) {
    final rawDays = json["days"] as List<dynamic>? ?? const [];
    return InterviewSlotsData(
      title: json["title"] as String? ?? "",
      subtitle: json["subtitle"] as String? ?? "",
      days: rawDays
          .map(
            (e) =>
                InterviewDaySlots.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
    );
  }
}
