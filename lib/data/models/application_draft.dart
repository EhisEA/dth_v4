/// In-progress contestant application data (wizard). Separate from [UserModel].
class ApplicationDraft {
  const ApplicationDraft({
    this.fullName = '',
    this.email = '',
    this.dateOfBirthDisplay = '',
    this.gender = '',
    this.phoneNumber = '',
    this.residentialAddress = '',
    this.stateOfResidence = '',
    this.cityOfResidence = '',
    this.stateOfOrigin = '',
    this.lga = '',
    this.nearestCampus = '',
    this.stageName = '',
    this.talentCategory = '',
    this.talentDescription = '',
    this.presentationMode = '',
    this.crewSize = '',
    this.participantNames = '',
    this.videoLink = '',
    this.socialMediaLink = '',
    this.bankName = '',
    this.accountNumber = '',
    this.accountName = '',
  });

  final String fullName;
  final String email;

  /// User-facing `DD-MM-YYYY` (or empty).
  final String dateOfBirthDisplay;
  final String gender;
  final String phoneNumber;
  final String residentialAddress;
  final String stateOfResidence;
  final String cityOfResidence;
  final String stateOfOrigin;
  final String lga;
  final String nearestCampus;

  final String stageName;
  final String talentCategory;
  final String talentDescription;
  /// `Individual` or `Group` (see [ApplicationStubOptions.presentationModes]).
  final String presentationMode;
  final String crewSize;
  final String participantNames;

  final String videoLink;
  final String socialMediaLink;

  final String bankName;
  final String accountNumber;
  final String accountName;

  static const ApplicationDraft empty = ApplicationDraft();

  bool get isGroupPresentation =>
      presentationMode.toLowerCase() == 'group';

  ApplicationDraft copyWith({
    String? fullName,
    String? email,
    String? dateOfBirthDisplay,
    String? gender,
    String? phoneNumber,
    String? residentialAddress,
    String? stateOfResidence,
    String? cityOfResidence,
    String? stateOfOrigin,
    String? lga,
    String? nearestCampus,
    String? stageName,
    String? talentCategory,
    String? talentDescription,
    String? presentationMode,
    String? crewSize,
    String? participantNames,
    String? videoLink,
    String? socialMediaLink,
    String? bankName,
    String? accountNumber,
    String? accountName,
  }) {
    return ApplicationDraft(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      dateOfBirthDisplay: dateOfBirthDisplay ?? this.dateOfBirthDisplay,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      residentialAddress: residentialAddress ?? this.residentialAddress,
      stateOfResidence: stateOfResidence ?? this.stateOfResidence,
      cityOfResidence: cityOfResidence ?? this.cityOfResidence,
      stateOfOrigin: stateOfOrigin ?? this.stateOfOrigin,
      lga: lga ?? this.lga,
      nearestCampus: nearestCampus ?? this.nearestCampus,
      stageName: stageName ?? this.stageName,
      talentCategory: talentCategory ?? this.talentCategory,
      talentDescription: talentDescription ?? this.talentDescription,
      presentationMode: presentationMode ?? this.presentationMode,
      crewSize: crewSize ?? this.crewSize,
      participantNames: participantNames ?? this.participantNames,
      videoLink: videoLink ?? this.videoLink,
      socialMediaLink: socialMediaLink ?? this.socialMediaLink,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
    );
  }

  /// Shape for a future API `POST`; keys are indicative only.
  Map<String, dynamic> toSubmissionJson() {
    return {
      'full_name': fullName,
      'email': email,
      'date_of_birth': dateOfBirthDisplay,
      'gender': gender,
      'phone': phoneNumber,
      'residential_address': residentialAddress,
      'state_of_residence': stateOfResidence,
      'city_of_residence': cityOfResidence,
      'state_of_origin': stateOfOrigin,
      'lga': lga,
      'nearest_campus': nearestCampus,
      'stage_name': stageName,
      'talent_category': talentCategory,
      'talent_description': talentDescription,
      'presentation_mode': presentationMode,
      'crew_size': crewSize,
      'participant_names': participantNames,
      'video_link': videoLink,
      'social_media_link': socialMediaLink,
      'bank_name': bankName,
      'account_number': accountNumber,
      'account_name': accountName,
    };
  }
}
