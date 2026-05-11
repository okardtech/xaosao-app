import 'package:get/get.dart';
import 'package:xaosao/services/storage_service.dart';

class AuthService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();

  final _isAuthenticated = false.obs;
  bool get isAuthenticated => _isAuthenticated.value;

  String? getToken() {
    return _storageService.read<String>('token');
  }

  Future<void> saveToken(String token) async {
    await _storageService.write('token', token);
    _isAuthenticated.value = true;
  }

  Future<void> removeToken() async {
    await _storageService.remove('token');
    _isAuthenticated.value = false;
  }

  Future<void> saveLanguage(String language) async {
    await _storageService.write('language', language);
  }

  String? getLanguage() {
    return _storageService.read<String>('language');
  }

  Future<void> removeLanguage() async {
    await _storageService.remove('language');
  }
}
