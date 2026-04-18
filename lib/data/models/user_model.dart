class UserModel {
  const UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.isoCode,
    required this.isPhoneVerified,
    required this.participationType,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// API field `uid` (replaces legacy `id`).
  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String isoCode;
  final bool isPhoneVerified;
  final ParticipationType participationType;
  final String emailVerifiedAt;
  final String createdAt;
  final String updatedAt;

  /// Parsed [participationType.name] as [ParticipationRole].
  ParticipationRole get participationRole =>
      ParticipationRole.fromName(participationType.name);

  bool get isUserRole => participationRole == ParticipationRole.user;
  bool get isApplicantRole => participationRole == ParticipationRole.applicant;
  bool get isContestantRole =>
      participationRole == ParticipationRole.contestant;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: _stringField(json['uid'] ?? json['id']),
      fullName: _stringField(json['full_name']),
      email: _stringField(json['email']),
      phoneNumber: _stringField(json['phone']),
      isoCode: _stringField(json['iso_code']),
      isPhoneVerified: _boolField(json['is_phone_verified']),
      participationType: ParticipationType.fromJson(json['participation_type']),
      emailVerifiedAt: _stringField(json['email_verified_at']),
      createdAt: _stringField(json['created_at']),
      updatedAt: _stringField(json['updated_at']),
    );
  }

  static String _stringField(Object? value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  static bool _boolField(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final s = value.toLowerCase();
      return s == 'true' || s == '1' || s == 'yes';
    }
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'full_name': fullName,
      'email': email,
      'phone': phoneNumber,
      'iso_code': isoCode,
      'is_phone_verified': isPhoneVerified,
      'participation_type': participationType.toJson(),
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? isoCode,
    bool? isPhoneVerified,
    ParticipationType? participationType,
    String? emailVerifiedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isoCode: isoCode ?? this.isoCode,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      participationType: participationType ?? this.participationType,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.uid == uid &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.isoCode == isoCode &&
        other.isPhoneVerified == isPhoneVerified &&
        other.participationType.name == participationType.name &&
        other.participationType.uid == participationType.uid &&
        other.emailVerifiedAt == emailVerifiedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    uid,
    email,
    phoneNumber,
    isoCode,
    isPhoneVerified,
    participationType.name,
    participationType.uid,
    emailVerifiedAt,
    createdAt,
    updatedAt,
  );

  @override
  String toString() {
    return 'UserModel(uid: $uid, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, isoCode: $isoCode, isPhoneVerified: $isPhoneVerified, participationType: ${participationType.name}, emailVerifiedAt: $emailVerifiedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// API values for [ParticipationType.name] on `GET /auth/user`.
enum ParticipationRole {
  user,
  applicant,
  contestant,
  unknown;

  static ParticipationRole fromName(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'user':
        return ParticipationRole.user;
      case 'applicant':
        return ParticipationRole.applicant;
      case 'contestant':
        return ParticipationRole.contestant;
      default:
        return ParticipationRole.unknown;
    }
  }
}

class ParticipationType {
  const ParticipationType({required this.name, this.uid});

  final String name;
  final String? uid;

  factory ParticipationType.fromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      return const ParticipationType(name: '');
    }
    final m = json;
    return ParticipationType(
      name: _stringField(m['name']),
      uid: m['uid'] == null ? null : _stringField(m['uid']),
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'uid': uid};

  static String _stringField(Object? value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }
}
