class AppModulesModel {
  const AppModulesModel({
    required this.application,
    required this.livestream,
    required this.timeline,
    required this.ticket,
    required this.voting,
    required this.poll,
    required this.judges,
    required this.subscription,
  });

  final bool application;
  final bool livestream;
  final bool timeline;
  final bool ticket;
  final bool voting;
  final bool poll;
  final bool judges;
  final bool subscription;

  factory AppModulesModel.fromJson(Map<String, dynamic> json) {
    return AppModulesModel(
      application: json["application"],
      livestream: json["livestream"],
      timeline: json["timeline"],
      ticket: json["ticket"],
      voting: json["voting"],
      poll: json["poll"],
      judges: json["judges"],
      subscription: json["subscription"],
    );
  }

  Map<String, dynamic> toJson() => {
    "application": application,
    "livestream": livestream,
    "timeline": timeline,
    "ticket": ticket,
    "voting": voting,
    "poll": poll,
    "judges": judges,
    "subscription": subscription,
  };
}
