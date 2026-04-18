class DthCountry {
  const DthCountry({
    required this.dialCode,
    required this.isoCode,
    required this.flagDataUri,
  });

  final String dialCode;
  final String isoCode;

  /// API returns `data:image/png;base64,...`
  final String flagDataUri;

  factory DthCountry.fromJson(Map<String, dynamic> json) {
    return DthCountry(
      dialCode: _stringField(json['dial_code']),
      isoCode: _stringField(json['iso_code']).toUpperCase(),
      flagDataUri: _stringField(json['flag']),
    );
  }

  Map<String, dynamic> toJson() => {
    'dial_code': dialCode,
    'iso_code': isoCode,
    'flag': flagDataUri,
  };

  static String _stringField(Object? value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }
}
