class RegisterRequestModel {
  String account;
  String password;
  String passwordagain;
  String username;
  dynamic time;

  RegisterRequestModel(
      {this.account,
      this.password,
      this.passwordagain,
      this.username,
      this.time});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'account': account.trim(),
      'password': password.trim(),
      'username': username.trim(),
      'time': time,
    };

    return map;
  }
}
