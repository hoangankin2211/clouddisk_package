class Auth {
  static String? hmail_key;
  static String? session;

  static void setAuth(String hmail, String session_key) {
    hmail_key = hmail;
    session = session_key;
  }
}
