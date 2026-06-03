import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ShareUtils {
  static const _onelinkBase = 'https://xaosao.onelink.me/TfaF/ieh44kax';

  static String buildReferralLink(String refCode) =>
      '$_onelinkBase?code=$refCode';

  static Future<void> shareReferralLink(String refCode) async {
    final link = buildReferralLink(refCode);
    await Share.share(
      'ສະໝັກກັບ Xaosao ຜ່ານລິ້ງຂອງຂ້ອຍ ແລ້ວຮັບ 10,000 ກີບ!\n\n$link',
      subject: 'ເຂົ້າຮ່ວມ Xaosao',
    );
  }

  static Future<void> copyToClipboard(String text) =>
      Clipboard.setData(ClipboardData(text: text));
}
