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

  /// Resolves flag (and dial code) from the cached `/countries` list using only
  /// [isoCode] from the backend (case-insensitive). Returns null if not found.
  static DthCountry? findByIso(Iterable<DthCountry> countries, String isoCode) {
    final u = isoCode.trim().toUpperCase();
    if (u.isEmpty) return null;
    for (final c in countries) {
      if (c.isoCode == u) return c;
    }
    return null;
  }
}
