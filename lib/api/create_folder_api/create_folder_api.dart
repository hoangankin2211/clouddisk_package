class CreateApiFolder {
  static const String apiPath = "/cloud/api/mkdir.php";
  static Map<String, dynamic> params({
    required String force,
    required String parentId,
    required String name,
  }) {
    return {
      "force": force,
      "name": name,
      "parentId": parentId,
    };
  }
}
