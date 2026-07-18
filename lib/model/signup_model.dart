class SignupModel {
  String? phoneNumber;
  String? email;
  String? verificationCode;
  String? profilePicPath;
  String? firstName;
  String? lastName;
  String? password;
  String? passwordConfirmation;
  DateTime? dateOfBirth;

  SignupModel({
    this.phoneNumber,
    this.email,
    this.verificationCode,
    this.profilePicPath,
    this.firstName,
    this.lastName,
    this.password,
    this.passwordConfirmation,
    this.dateOfBirth,
  });

  SignupModel copyWith({
    String? phoneNumber,
    String? email,
    String? verificationCode,
    String? profilePicPath,
    String? firstName,
    String? lastName,
    String? password,
    String? passwordConfirmation,
    DateTime? dateOfBirth,
  }) {
    return SignupModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      verificationCode: verificationCode ?? this.verificationCode,
      profilePicPath: profilePicPath ?? this.profilePicPath,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}
