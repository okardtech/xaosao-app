import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:xaosao/utils/app_snackbar.dart';

class QrSaver {
  QrSaver._();

  static Future<bool> saveFromUrl(String url) async {
    try {
      final res = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      if (res.data == null) {
        AppSnackbar.error('ໂຫຼດ QR ບໍ່ສຳເລັດ');
        return false;
      }
      final bytes = Uint8List.fromList(res.data!);
      final result = await SaverGallery.saveImage(
        bytes,
        quality: 100,
        fileName: 'xaosao_qr_${DateTime.now().millisecondsSinceEpoch}',
        androidRelativePath: 'Pictures/XAOSAO',
        skipIfExists: false,
      );
      if (result.isSuccess) {
        AppSnackbar.success('ບັນທຶກ QR ໃສ່ຄັງຮູບແລ້ວ');
        return true;
      }
      AppSnackbar.error('ບໍ່ສາມາດບັນທຶກ QR ໄດ້');
      return false;
    } catch (_) {
      AppSnackbar.error('ເກີດຂໍ້ຜິດພາດ ກະລຸນາລອງໃໝ່');
      return false;
    }
  }
}
