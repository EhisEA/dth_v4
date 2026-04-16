import 'package:dth_v4/data/models/application_draft.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplicationWizardNotifier extends Notifier<ApplicationDraft> {
  @override
  ApplicationDraft build() => ApplicationDraft.empty;

  void setPersonal({
    required String fullName,
    required String email,
    required String dateOfBirthDisplay,
    required String gender,
    required String phoneNumber,
  }) {
    state = state.copyWith(
      fullName: fullName,
      email: email,
      dateOfBirthDisplay: dateOfBirthDisplay,
      gender: gender,
      phoneNumber: phoneNumber,
    );
  }

  void setContact({
    required String residentialAddress,
    required String stateOfResidence,
    required String cityOfResidence,
    required String stateOfOrigin,
    required String lga,
    required String nearestCampus,
  }) {
    state = state.copyWith(
      residentialAddress: residentialAddress,
      stateOfResidence: stateOfResidence,
      cityOfResidence: cityOfResidence,
      stateOfOrigin: stateOfOrigin,
      lga: lga,
      nearestCampus: nearestCampus,
    );
  }

  void setTalentShowcase({
    required String stageName,
    required String talentCategory,
    required String talentDescription,
    required String presentationMode,
    required String crewSize,
    required String participantNames,
  }) {
    state = state.copyWith(
      stageName: stageName,
      talentCategory: talentCategory,
      talentDescription: talentDescription,
      presentationMode: presentationMode,
      crewSize: crewSize,
      participantNames: participantNames,
    );
  }

  void setAuditionVideo({
    required String videoLink,
    required String socialMediaLink,
  }) {
    state = state.copyWith(
      videoLink: videoLink,
      socialMediaLink: socialMediaLink,
    );
  }

  void setBankDetails({
    required String bankName,
    required String accountNumber,
    required String accountName,
  }) {
    state = state.copyWith(
      bankName: bankName,
      accountNumber: accountNumber,
      accountName: accountName,
    );
  }

  /// Replaces the whole draft (e.g. when [ApplicationReviewView] opens with route args).
  void replaceDraft(ApplicationDraft draft) {
    state = draft;
  }

  Future<void> submitApplication() async {
    // ignore: unused_local_variable
    final _ = state.toSubmissionJson();
  }

  void reset() {
    state = ApplicationDraft.empty;
  }
}

final applicationWizardProvider =
    NotifierProvider<ApplicationWizardNotifier, ApplicationDraft>(
      ApplicationWizardNotifier.new,
    );
