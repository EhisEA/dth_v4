import "package:dth_v4/data/data.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

/// View model for applicant interview slots (API wired; no UI yet).
class InterviewSlotsViewModel extends BaseChangeNotifierViewModel {
  InterviewSlotsViewModel(this._applicationRepo);

  final ApplicationRepo _applicationRepo;

  InterviewSlotsData? _interviewSlots;

  /// Last successful [fetchInterviewSlots] payload, if any.
  InterviewSlotsData? get interviewSlots => _interviewSlots;

  /// [date] must be `YYYY-MM-DD` (ISO date), matching the API `date` query param.
  Future<void> fetchInterviewSlots({
    required String date,
    Function()? onSuccess,
  }) async {
    try {
      changeBaseState(const ViewModelState.busy());
      final response = await _applicationRepo.getInterviewSlots(date: date);
      changeBaseState(const ViewModelState.idle());
      _interviewSlots = response.data;
      notifyListeners();
      onSuccess?.call();
    } on ApiFailure catch (e) {
      changeBaseState(ViewModelState.error(e));
      DthFlushBar.instance.showError(message: e.message, title: "Failed");
    }
  }
}

final interviewSlotsViewModelProvider =
    ChangeNotifierProvider<InterviewSlotsViewModel>((ref) {
      return InterviewSlotsViewModel(ref.read(applicationRepositoryProvider));
    });
