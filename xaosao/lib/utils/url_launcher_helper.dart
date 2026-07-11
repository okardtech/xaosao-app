import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  static Future<bool> launchOnepayQR(String? qrData) async {
    try {
      if (qrData == null) {
        return false;
      }
      final Uri uri = Uri.parse(qrData);
      final bool canLaunch = await canLaunchUrl(uri);

      if (canLaunch) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');
    if (!await launchUrl(uri)) {
      throw Exception('Could not call $phoneNumber');
    }
  }

  static Future<void> sendSMS(String phoneNumber, {String? message}) async {
    final Uri uri = Uri.parse(
      'sms:$phoneNumber${message != null ? '?body=$message' : ''}',
    );
    if (!await launchUrl(uri)) {
      throw Exception('Could not send SMS');
    }
  }

  static Future<void> sendEmail(
    String email, {
    String? subject,
    String? body,
  }) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      query:
          'subject=${Uri.encodeComponent(subject ?? '')}&body=${Uri.encodeComponent(body ?? '')}',
    );
    if (!await launchUrl(uri)) {
      throw Exception('Could not send email');
    }
  }

  static Future<void> openMaps(double latitude, double longitude) async {
    final Uri uri = Uri.parse('geo:$latitude,$longitude');
    if (!await launchUrl(uri)) {
      throw Exception('Could not open maps');
    }
  }

  static Future<void> openWhatsApp(
    String phoneNumber, {
    String? message,
  }) async {
    final Uri uri = Uri.parse(
      'whatsapp://send?phone=$phoneNumber${message != null ? '&text=${Uri.encodeComponent(message)}' : ''}',
    );
    if (!await launchUrl(uri)) {
      throw Exception('Could not open WhatsApp');
    }
  }

  static Future<bool> canLaunchURL(String url) async {
    final Uri uri = Uri.parse(url);
    return await canLaunchUrl(uri);
  }
}