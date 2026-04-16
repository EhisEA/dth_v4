class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String isoCode;
  final String emailVerifiedAt;
  final String createdAt;
  final String updatedAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.isoCode,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _stringField(json['id']),
      fullName: _stringField(json['full_name']),
      email: _stringField(json['email']),
      phoneNumber: _stringField(json['phone']),
      isoCode: _stringField(json['iso_code']),
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phoneNumber,
      'iso_code': isoCode,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? isoCode,
    String? emailVerifiedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isoCode: isoCode ?? this.isoCode,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.isoCode == isoCode &&
        other.emailVerifiedAt == emailVerifiedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    email,
    phoneNumber,
    isoCode,
    emailVerifiedAt,
    createdAt,
    updatedAt,
  );

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, isoCode: $isoCode, emailVerifiedAt: $emailVerifiedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
