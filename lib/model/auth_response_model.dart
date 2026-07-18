// User Model Class
class AuthResponseModel {
  final int? id;
  final String? type;
  final dynamic verificationCode;
  final String? name;
  final int? membership;
  final String? emailVerifiedAt;
  final int? photoApproved;
  final int? blocked;
  final int? deactivated;
  final int? approved;
  final String? email;
  final int? birthday;
  final dynamic height;
  final MaritalStatus? maritalStatus;
  final String? avatar;
  final String? avatarOriginal;
  final String? phone;
  final String? code;
  final bool? loginWithTempPassword;

  AuthResponseModel(
      {this.id,
      this.type,
      this.verificationCode,
      this.name,
      this.membership,
      this.emailVerifiedAt,
      this.photoApproved,
      this.blocked,
      this.deactivated,
      this.approved,
      this.email,
      this.birthday,
      this.height,
      this.maritalStatus,
      this.avatar,
      required this.avatarOriginal,
      required this.phone,
      this.code,
      this.loginWithTempPassword});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      verificationCode: json['verification_code'] ?? '',
      name: json['name'] ?? '',
      membership: json['membership'] ?? 0,
      emailVerifiedAt: json['email_verified_at'],
      photoApproved: json['photo_approved'] ?? 0,
      blocked: json['blocked'] ?? 0,
      deactivated: json['deactivated'] ?? 0,
      approved: json['approved'] ?? 0,
      email: json['email'] ?? '',
      birthday: json['birthday'] ?? 0,
      height: json['height'] ?? 0,
      maritalStatus: json['marital_status_id'] != null
          ? MaritalStatus.fromJson(json['marital_status_id'])
          : MaritalStatus.empty(),
      avatar: json['avatar'] ?? '',
      avatarOriginal: json['avatar_original'] ?? '',
      phone: json['phone'] ?? '',
      code: json['code'] ?? '',
      loginWithTempPassword: json['loginwithtemppassword'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'membership': membership,
      'email_verified_at': emailVerifiedAt,
      'photo_approved': photoApproved,
      'blocked': blocked,
      'deactivated': deactivated,
      'approved': approved,
      'email': email,
      'birthday': birthday,
      'height': height,
      'marital_status_id': maritalStatus?.toJson(),
      'avatar': avatar,
      'avatar_original': avatarOriginal,
      'phone': phone,
      'code': code,
      'loginwithtemppassword': loginWithTempPassword,
    };
  }
}

// Marital Status Model Class
class MaritalStatus {
  final int? id;
  final String? name;

  MaritalStatus({
    required this.id,
    required this.name,
  });

  factory MaritalStatus.fromJson(Map<String, dynamic> json) {
    return MaritalStatus(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  factory MaritalStatus.empty() {
    return MaritalStatus(id: 0, name: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
