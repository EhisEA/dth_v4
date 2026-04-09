import "package:flutter_utils/flutter_utils.dart";

extension ViewModelStateX on ViewModelState {
  /// if state is busy
  bool get isBusy => maybeWhen<bool>(busy: () => true, orElse: () => false);

  /// if state is idle
  bool get isIdle => maybeWhen<bool>(idle: () => true, orElse: () => false);

  /// if state is error
  bool get isError =>
      maybeWhen<bool>(error: (value) => true, orElse: () => false);

  /// get error message
  String get getError =>
      maybeWhen<String>(error: (value) => value.message, orElse: () => "");
}
