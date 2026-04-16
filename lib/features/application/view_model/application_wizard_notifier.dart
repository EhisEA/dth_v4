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

  /// Placeholder for final API call after step 5.
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
