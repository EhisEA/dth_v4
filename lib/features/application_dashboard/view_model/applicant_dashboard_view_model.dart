import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

class ApplicantDashboardViewModel extends BaseChangeNotifierViewModel {
  ApplicantDashboardViewModel(this._applicationRepo, this._userProfile);

  final ApplicationRepo _applicationRepo;
  final UserProfileState _userProfile;

  ApplicantDashboardData? _data;

  ApplicantDashboardData? get data => _data;

  /// Same role gate as the home apply banner; errors are silent (no baseState / toast).
  Future<void> prefetchForHomeUser() async {
    final user = _userProfile.user.value;
    if (user != null && user.participationRole != ParticipationRole.user) {
      return;
    }
    try {
      final response = await _applicationRepo.getApplicantDashboard();
      _data = response.data;
      notifyListeners();
    } on ApiFailure {
      // Prefetch only — surface errors when the user opens the dashboard.
    }
  }

  /// After a successful application submit — no role gate, no busy/toast (home may read this).
  Future<void> refreshAfterApplicationSubmit() async {
    try {
      final response = await _applicationRepo.getApplicantDashboard();
      _data = response.data;
      notifyListeners();
    } on ApiFailure {
      // Silent; user can open dashboard for explicit retry.
    }
  }

  /// Full load with [baseState] busy / idle / error (for screen and retry).
  Future<void> loadDashboard() async {
    try {
      changeBaseState(const ViewModelState.busy());
      final response = await _applicationRepo.getApplicantDashboard();
      _data = response.data;
      changeBaseState(const ViewModelState.idle());
      notifyListeners();
    } on ApiFailure catch (e) {
      changeBaseState(ViewModelState.error(e));
      DthFlushBar.instance.showError(message: e.message, title: "Failed");
      notifyListeners();
    }
  }

  /// When opening the screen with no cached payload yet (e.g. prefetch skipped or failed).
  Future<void> ensureScreenLoaded() async {
    if (_data != null) return;
    if (baseState.isBusy) return;
    await loadDashboard();
  }

  String appBarTitle(ApplicantDashboardData? d) {
    final t = d?.header?.title?.trim();
    if (t != null && t.isNotEmpty) return t;
    return "Applicant Dashboard";
  }

  String performanceCaption(ApplicantDashboardData d) {
    final c = d.performance.caption?.trim();
    if (c != null && c.isNotEmpty) return c;
    return "Based on reviewer evaluations";
  }

  String journeySectionTitle(ApplicantDashboardData d) {
    final t = d.journey.title?.trim();
    if (t != null && t.isNotEmpty) return t;
    final s = d.journey.stage?.trim();
    if (s != null && s.isNotEmpty) return s;
    return "Your Journey";
  }

  Color bannerBackgroundForVariant(String variant) {
    switch (variant.toLowerCase()) {
      case "success":
        return AppColors.primary.withValues(alpha: 0.08);
      case "warning":
        return AppColors.secondaryOrange.withValues(alpha: 0.12);
      case "danger":
      case "error":
        return AppColors.redTint35.withValues(alpha: 0.08);
      default:
        return AppColors.greyTint20;
    }
  }

  void handleBack(BuildContext context) {
    final action = _data?.header?.backAction;
    if (action == "navigate:home") {
      MobileNavigationService.instance.goBack();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  void handleJourneyCta(JourneyCta cta) {
    if (!cta.enabled) return;
    final target = cta.target.toLowerCase();
    final action = cta.action.toLowerCase();
    if (target == "application_form" || action == "submit") {
      MobileNavigationService.instance.navigateTo(NavigatorRoutes.application);
    }
  }

  /// Pairs of cards for a two-column grid; second slot may be null (odd count).
  List<List<JourneyCard?>> journeyGridRows(ApplicantDashboardData d) {
    final cards = d.journey.displayCards;
    final rows = <List<JourneyCard?>>[];
    for (var i = 0; i < cards.length; i += 2) {
      rows.add([cards[i], if (i + 1 < cards.length) cards[i + 1] else null]);
    }
    return rows;
  }
}

final applicantDashboardViewModelProvider =
    ChangeNotifierProvider<ApplicantDashboardViewModel>((ref) {
      return ApplicantDashboardViewModel(
        ref.read(applicationRepositoryProvider),
        ref.read(userProfileStateProvider),
      );
    });
