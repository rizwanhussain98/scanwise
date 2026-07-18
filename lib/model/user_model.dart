class UserModel {
  final int? id;
  final String? email;
  final String? password;
  final String? passwordConfirmation;
  final String? firstName;
  final String? lastName;
  final String? profilePath;
  final DateTime? dateOfBirth;

  UserModel({
    this.id,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.firstName,
    this.lastName,
    this.profilePath,
    this.dateOfBirth,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      passwordConfirmation: json['password_confirmation'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profilePath: json['profile_path'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'first_name': firstName,
      'last_name': lastName,
      'profile_path': profilePath,
      'date_of_birth': dateOfBirth?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? email,
    String? profilePath,
    String? firstName,
    String? lastName,
    String? password,
    String? passwordConfirmation,
    DateTime? dateOfBirth,
  }) {
    return UserModel(
      id: id,
      email: email ?? this.email,
      profilePath: profilePath ?? this.profilePath,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      passwordConfirmation:
      passwordConfirmation ?? this.passwordConfirmation,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}
