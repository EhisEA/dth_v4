class AppTextFieldState {
  AppTextFieldState({required this.error, required this.isFocus});
  final String? error;
  final bool isFocus;

  bool get hasError => error != null;

  factory AppTextFieldState.defaultValue() =>
      AppTextFieldState(error: null, isFocus: false);

  @override
  operator ==(covariant AppTextFieldState other) =>
      other.hasError == hasError &&
      other.isFocus == isFocus &&
      other.error == error;

  @override
  int get hashCode => hasError.hashCode ^ isFocus.hashCode ^ error.hashCode;

  AppTextFieldState copyWith({String? error, bool? isFocus}) {
    return AppTextFieldState(
      error: (error?.isEmpty ?? false ? null : error ?? this.error),
      isFocus: isFocus ?? this.isFocus,
    );
  }

  @override
  String toString() {
    return "error -> $error, isFocus -> $isFocus";
  }
}
