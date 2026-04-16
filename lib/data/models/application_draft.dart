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

  static const ApplicationDraft empty = ApplicationDraft();

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
    };
  }
}
