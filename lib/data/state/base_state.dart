import "package:flutter_utils/flutter_utils.dart";

abstract class BaseState {
  late final _logger = AppLogger(runtimeType);

  /// Handles errors from background/init operations (periodic refreshes,
  /// cache reads, server syncs) that have no ViewModel awaiting the result.
  ///
  /// - [Failure] (expected business errors) are rethrown so that any
  ///   ViewModel catch block higher up can handle them with UI feedback.
  /// - All other exceptions (TypeError, StateError, etc.) are logged and
  ///   reported to Crashlytics but **not** rethrown, because these run in
  ///   fire-and-forget contexts where crashing would be worse than degrading
  ///   gracefully. Check the Crashlytics dashboard for these.
  void handleError(Object e, [Object? stackTrace]) {
    if (e is Failure) throw e;
    _logger.e(e);
    if (stackTrace != null) _logger.i(stackTrace);
    // FirebaseCrashlytics.instance.recordError(
    //   e,
    //   stackTrace is StackTrace ? stackTrace : StackTrace.current,
    //   reason: runtimeType.toString(),
    // );
  }

  /// Subclasses override to dispose ValueNotifiers, cancel Debouncers, etc.
  void dispose() {}
}
