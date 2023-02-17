import 'package:url_launcher/url_launcher.dart';

class OpenUrlService {
  static Future<void> openUrl(String url) async {
    try {
      if (!await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication)) {
        throw Exception("Could not lanch $url");
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
