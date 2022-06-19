class User {
  late String _userId;
  late String _email;
  late String _username;
  late String _role;
  late String _password;

  constructorUser({
    String? userId,
    String? email,
    String? username,
    String? role,
    String? password,
  }) {
    _userId = userId!;
    _email = email!;
    _username = username!;
    _role = role!;
    _password = password!;
  }

// Properties
  // ignore: unnecessary_getters_setters
  String get userId => _userId;
  set userId(String userId) => _userId = userId;

  //clear fix define
  // ignore: unnecessary_getters_setters
  // String get token => _token;
  // set token(String token) => _token = token;

  // ignore: unnecessary_getters_setters
  String get email => _email;
  set email(String email) => _email = email;
  // ignore: unnecessary_getters_setters
  String get username => _username;
  set username(String username) => _username = username;
  // ignore: unnecessary_getters_setters
  String get role => _role;
  set role(String role) => _role = role;
  // ignore: unnecessary_getters_setters
  String get password => _password;
  set password(String password) => _password = password;

  //end fix define

// create the ambassador profile from json input
  User.fromJson(Map<dynamic, dynamic> json) {
    _userId = json['gpr_usr_id'] ?? '';

    _email = json['gpr_usr_email '] ?? '';
    _username = json['gpr_usr_name'] ?? '';

    _role = json['gpr_role_name'] ?? '';
    _password = json['gpr_company_name'] ?? '';
  }

// Export to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //data['gpr_usr_token'] = _token;
    //data['gpr_role_name'] = _typeRole;

    data['id'] = _userId;

    return data;
  }
}
