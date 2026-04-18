import "package:dth_v4/data/data.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";
import "package:intl/intl.dart";

class ApplicationViewModel extends BaseChangeNotifierViewModel {
  ApplicationViewModel(this._applicationRepo);

  final ApplicationRepo _applicationRepo;

  ApplicationDraft _draft = ApplicationDraft.empty;

  ApplicationProcess? _applicationProcess;

  ApplicationDraft get draft => _draft;

  /// Last successful [fetchApplicationProcess] payload, if any.
  ApplicationProcess? get applicationProcess => _applicationProcess;

  void setPersonal(PersonalInformationInput input) {
    _draft = _draft.copyWith(
      fullName: input.fullName,
      email: input.email,
      dateOfBirthDisplay: input.dateOfBirthDisplay,
      gender: input.gender,
      phoneNumber: input.phoneNumber,
    );
    notifyListeners();
  }

  void setContact(ContactInformationInput input) {
    _draft = _draft.copyWith(
      residentialAddress: input.residentialAddress,
      stateOfResidence: input.stateOfResidence,
      cityOfResidence: input.cityOfResidence,
      stateOfOrigin: input.stateOfOrigin,
      lga: input.lga,
      nearestCampus: input.nearestCampus,
    );
    notifyListeners();
  }

  void setTalentShowcase(TalentShowcaseInput input) {
    _draft = _draft.copyWith(
      stageName: input.stageName,
      talentCategory: input.talentCategory,
      talentDescription: input.talentDescription,
      presentationMode: input.presentationMode,
      crewSize: input.crewSize,
      participantNames: input.participantNames,
    );
    notifyListeners();
  }

  void setAuditionVideo(AuditionVideoInput input) {
    _draft = _draft.copyWith(
      videoLink: input.videoLink,
      socialMediaLink: input.socialMediaLink,
    );
    notifyListeners();
  }

  void setBankDetails(BankDetailsInput input) {
    _draft = _draft.copyWith(
      bankName: input.bankName,
      accountNumber: input.accountNumber,
      accountName: input.accountName,
    );
    notifyListeners();
  }

  /// When non-null (from route [RoutingArgumentKey.applicationDraft]), replaces in-memory draft.
  void replaceDraft(ApplicationDraft draft) {
    _draft = draft;
    notifyListeners();
  }

  void reset() {
    _draft = ApplicationDraft.empty;
    notifyListeners();
  }

  ApplicationSubmitRequest requestFromDraft(
    ApplicationDraft source, {
    required bool isFinalStep,
    String isoCode = "NG",
    int? talentCategoryId,
  }) {
    final categoryId =
        talentCategoryId ??
        (_applicationProcess?.resolveTalentCategoryId(
              source.talentCategory,
            ) ??
            1);
    final crewSize =
        source.isGroupPresentation && source.crewSize.trim().isNotEmpty
        ? source.crewSize.trim()
        : "1";

    return ApplicationSubmitRequest(
      fullName: source.fullName.trim(),
      email: source.email.trim(),
      gender: _genderToApi(source.gender),
      dateOfBirth: _dobToApiFormat(source.dateOfBirthDisplay),
      isoCode: isoCode,
      phone: source.phoneNumber.trim(),
      residentialAddress: source.residentialAddress.trim(),
      stateOfResidence: source.stateOfResidence.trim(),
      stateOfOrigin: source.stateOfOrigin.trim(),
      city: source.cityOfResidence.trim(),
      lga: source.lga.trim(),
      nearestCampus: source.nearestCampus.trim(),
      stageName: source.stageName.trim(),
      talentCategoryId: categoryId,
      description: source.talentDescription.trim(),
      modeOfPresentation: source.presentationMode.trim(),
      sizeOfCrew: crewSize,
      nameOfParticipants: _participantNames(source.participantNames),
      videoLink: source.videoLink.trim(),
      socialMediaLink: source.socialMediaLink.trim(),
      bankName: source.bankName.trim(),
      accountName: source.accountName.trim(),
      accountNumber: source.accountNumber.trim(),
      isFinalStep: isFinalStep,
    );
  }

  Future<ApplicationProcess?> fetchApplicationProcess() async {
    try {
      changeBaseState(const ViewModelState.busy());
      final response = await _applicationRepo.getApplicationProcess();
      changeBaseState(const ViewModelState.idle());
      final data = response.data;
      _applicationProcess = data;
      notifyListeners();
      return data;
    } on ApiFailure catch (e) {
      changeBaseState(ViewModelState.error(e));
      DthFlushBar.instance.showError(message: e.message, title: "Failed");
      return null;
    }
  }

  Future<ApplicationSubmitResult?> submitApplication(
    ApplicationSubmitRequest body,
  ) async {
    try {
      changeBaseState(const ViewModelState.busy());
      final response = await _applicationRepo.submitApplication(body);
      changeBaseState(const ViewModelState.idle());
      return response.data;
    } on ApiFailure catch (e) {
      changeBaseState(ViewModelState.error(e));
      DthFlushBar.instance.showError(message: e.message, title: "Failed");
      return null;
    }
  }
}

String _dobToApiFormat(String display) {
  if (display.trim().isEmpty) {
    return "";
  }
  try {
    final parsed = DateFormat("dd-MM-yyyy").parseStrict(display.trim());
    return DateFormat("yyyy-MM-dd").format(parsed);
  } on FormatException {
    return display.trim();
  }
}

String _genderToApi(String gender) {
  final g = gender.trim().toLowerCase();
  if (g.startsWith("m")) {
    return "male";
  }
  if (g.startsWith("f")) {
    return "female";
  }
  return g.replaceAll(" ", "_");
}

List<String> _participantNames(String raw) {
  if (raw.trim().isEmpty) {
    return const [];
  }
  return raw
      .replaceAll("\n", ",")
      .split(",")
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

final applicationViewModelProvider =
    ChangeNotifierProvider<ApplicationViewModel>((ref) {
      return ApplicationViewModel(ref.read(applicationRepositoryProvider));
    });
