class UserSession {
  static final UserSession _instance = UserSession._internal();

  String? userId;
  String? accessToken;

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  void clearSession() {
    userId = null;
    accessToken = null;
  }
}
