import "package:dth_v4/data/data.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

class PollViewModel extends BaseChangeNotifierViewModel {
  PollViewModel(this._pollRepo);

  final PollRepo _pollRepo;

  final ValueNotifier<PollModel?> poll = ValueNotifier<PollModel?>(null);

  static const String _voteStateKey = "pollVoteStateKey";

  ViewModelState get voteState =>
      getState(_voteStateKey) ?? const ViewModelState.idle();

  bool get isVoteBusy =>
      voteState.maybeWhen(busy: () => true, orElse: () => false);

  Future<void> loadPoll() async {
    try {
      final result = await _pollRepo.fetchPoll();
      poll.value = result;
    } on ApiFailure catch (e) {
      DthFlushBar.instance.showError(message: e.message, title: "Failed");
    }
  }

  Future<void> vote(String optionUid) async {
    final current = poll.value;
    if (current == null ||
        current.hasEnded ||
        current.hasVoted ||
        isVoteBusy ||
        optionUid.trim().isEmpty) {
      return;
    }

    try {
      setState(_voteStateKey, const ViewModelState.busy());
      final updated = await _pollRepo.submitVote(
        pollUid: current.uid,
        optionUid: optionUid,
      );
      poll.value = updated;
      setState(_voteStateKey, const ViewModelState.idle());
    } on ApiFailure catch (e) {
      setState(_voteStateKey, ViewModelState.error(e));
      DthFlushBar.instance.showError(message: e.message, title: "Failed");
    }
  }

  @override
  void dispose() {
    poll.dispose();
    super.dispose();
  }
}

final pollViewModelProvider = ChangeNotifierProvider<PollViewModel>((ref) {
  return PollViewModel(ref.read(pollRepositoryProvider));
});
