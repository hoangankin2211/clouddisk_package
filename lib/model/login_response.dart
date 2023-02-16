class LoginResponse {
  String? session;
  String? hmail_key;
  bool? success;

  LoginResponse(Map<String, dynamic> map) {
    success = map["success"] ?? false;
    session = map["session"];
    hmail_key = map["hmail_key"];
  }

  Map<String, String> toMap() {
    return {
      'session': session ?? "",
      "hmail_key": hmail_key ?? "",
    };
  }
}
