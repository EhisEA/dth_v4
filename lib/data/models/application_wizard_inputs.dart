/// Wizard personal step fields (merged into [ApplicationDraft]).
class PersonalInformationInput {
  const PersonalInformationInput({
    required this.fullName,
    required this.email,
    required this.dateOfBirthDisplay,
    required this.gender,
    required this.phoneNumber,
  });

  final String fullName;
  final String email;
  final String dateOfBirthDisplay;
  final String gender;
  final String phoneNumber;
}

/// Wizard contact step fields (merged into [ApplicationDraft]).
class ContactInformationInput {
  const ContactInformationInput({
    required this.residentialAddress,
    required this.stateOfResidence,
    required this.cityOfResidence,
    required this.stateOfOrigin,
    required this.lga,
    required this.nearestCampus,
  });

  final String residentialAddress;
  final String stateOfResidence;
  final String cityOfResidence;
  final String stateOfOrigin;
  final String lga;
  final String nearestCampus;
}

/// Wizard talent step fields (merged into [ApplicationDraft]).
class TalentShowcaseInput {
  const TalentShowcaseInput({
    required this.stageName,
    required this.talentCategory,
    required this.talentDescription,
    required this.presentationMode,
    required this.crewSize,
    required this.participantNames,
  });

  final String stageName;
  final String talentCategory;
  final String talentDescription;
  final String presentationMode;
  final String crewSize;
  final String participantNames;
}

/// Wizard audition video step fields (merged into [ApplicationDraft]).
class AuditionVideoInput {
  const AuditionVideoInput({
    required this.videoLink,
    required this.socialMediaLink,
  });

  final String videoLink;
  final String socialMediaLink;
}

/// Wizard bank step fields (merged into [ApplicationDraft]).
class BankDetailsInput {
  const BankDetailsInput({
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
  });

  final String bankName;
  final String accountNumber;
  final String accountName;
}
