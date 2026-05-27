import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:xaosao/models/gallerys_model.dart';
import 'package:xaosao/pages/home/getx/home_logic.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/pages/profile/getx/profile_state.dart';
import 'package:xaosao/repository/gallery_repo.dart';
import 'package:xaosao/repository/login_repo.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/utils/image_picker_util.dart';

import '../../../constants/app_routes.dart';
import '../../../repository/register_repo.dart';
import '../../../widgets/show_loading_alert.dart';
import '../../feedback/getx/feedback_logic.dart';
import '../../model_discover/getx/model_discover_logic.dart';
import '../../notification/getx/notification_setting_logic.dart';
import '../../services_manage/getx/service_logic.dart';

class ProfileLogic extends GetxController {
  final _galleryRepo = GalleryRepo();
  final _registerRepo = RegisterRepo();

  final Rx<ProfileState> _state = const ProfileState().obs;
  ProfileState get state => _state.value;
  Rx<ProfileState> get getXController => _state;

  void _updateState(ProfileState s) => _state.value = s;

  static const _maxPhotos = 6;

  bool get _isClient =>
      Get.find<StorageService>().read<String>('role') == 'customer';
  bool _togglingHidden = false;

  @override
  void onInit() {
    super.onInit();
    SchedulerBinding.instance.addPostFrameCallback((_) => _loadFromProfile());
  }

  void _loadFromProfile() {
    final login = Get.find<LoginLogic>();
    final gallery = _isClient
        ? login.state.customerProfile?.gallery ?? []
        : login.state.modelProfile?.gallery ?? [];

    final hidden = _isClient
        ? false
        : login.state.modelProfile?.isProfileHidden ?? false;

    final photos = gallery
        .take(_maxPhotos)
        .map((g) => GallerysModel(id: g.id, url: g.url))
        .toList();

    _updateState(state.copyWith(hidden: hidden, photos: photos));
  }

  Future<void> toggleHidden() async {
    if (_isClient || _togglingHidden) return;
    _togglingHidden = true;
    final newHidden = !state.hidden;
    _updateState(state.copyWith(hidden: newHidden));
    try {
      final res = await _galleryRepo.visibility(hidden: newHidden);
      if (!res.success) {
        _updateState(state.copyWith(hidden: !newHidden));
        AppSnackbar.error(res.message ?? 'ປ່ຽນສະຖານະບໍ່ສຳເລັດ');
      }
    } catch (_) {
      _updateState(state.copyWith(hidden: !newHidden));
      AppSnackbar.error('ປ່ຽນສະຖານະບໍ່ສຳເລັດ');
    } finally {
      _togglingHidden = false;
    }
  }

  Future<void> pickAndUpload(int slotIndex) async {
    if (state.uploadingIndex != -1) return;
    final file = await ImagePickerUtil.pick();
    if (file == null) return;

    _updateState(state.copyWith(uploadingIndex: slotIndex));
    try {
      final existing = slotIndex < state.photos.length
          ? state.photos[slotIndex]
          : null;

      if (existing?.id != null) {
        final res = await _galleryRepo.updatePhoto(
          isClient: _isClient,
          photoId: existing!.id!,
          filePath: file.path,
        );
        if (res.success && res.data != null) {
          final updated = List<GallerysModel>.from(state.photos);
          updated[slotIndex] = res.data!;
          _updateState(state.copyWith(photos: updated, uploadingIndex: -1));
        } else {
          _updateState(state.copyWith(uploadingIndex: -1));
          AppSnackbar.error(res.message ?? 'ອັບໂຫຼດບໍ່ສຳເລັດ');
        }
      } else {
        final res = await _galleryRepo.addPhoto(
          isClient: _isClient,
          filePath: file.path,
        );
        if (res.success && res.data != null) {
          final updated = List<GallerysModel>.from(state.photos);
          if (slotIndex < updated.length) {
            updated[slotIndex] = res.data!;
          } else {
            updated.add(res.data!);
          }
          _updateState(state.copyWith(photos: updated, uploadingIndex: -1));
        } else {
          _updateState(state.copyWith(uploadingIndex: -1));
          AppSnackbar.error(res.message ?? 'ອັບໂຫຼດບໍ່ສຳເລັດ');
        }
      }
    } catch (_) {
      _updateState(state.copyWith(uploadingIndex: -1));
      AppSnackbar.error('ອັບໂຫຼດບໍ່ສຳເລັດ');
    }
  }

  Future<void> updateProfileImage() async {
    if (state.profileImageUploading) return;
    final file = await ImagePickerUtil.pick();
    if (file == null) return;

    _updateState(state.copyWith(profileImageUploading: true));
    try {
      final res = await _galleryRepo.updateProfileImage(
        isClient: _isClient,
        filePath: file.path,
      );
      if (res.success && res.data?.url != null) {
        Get.find<LoginLogic>().updateProfileUrl(res.data!.url!, _isClient);
      } else {
        AppSnackbar.error(res.message ?? 'ອັບໂຫຼດຮູບໂປຣໄຟບໍ່ສຳເລັດ');
      }
    } catch (_) {
      AppSnackbar.error('ອັບໂຫຼດຮູບໂປຣໄຟບໍ່ສຳເລັດ');
    } finally {
      _updateState(state.copyWith(profileImageUploading: false));
    }
  }

  Future<void> removePhoto(int index) async {
    if (index >= state.photos.length) return;
    final photo = state.photos[index];

    if (photo.id == null) {
      final updated = List<GallerysModel>.from(state.photos)..removeAt(index);
      _updateState(state.copyWith(photos: updated));
      return;
    }

    _updateState(state.copyWith(deletingIndex: index));
    try {
      final res = await _galleryRepo.deletePhoto(
        isClient: _isClient,
        photoId: photo.id!,
      );
      if (res.success) {
        final updated = List<GallerysModel>.from(state.photos)..removeAt(index);
        _updateState(state.copyWith(photos: updated, deletingIndex: -1));
      } else {
        _updateState(state.copyWith(deletingIndex: -1));
        AppSnackbar.error(res.message ?? 'ລຶບບໍ່ສຳເລັດ');
      }
    } catch (_) {
      _updateState(state.copyWith(deletingIndex: -1));
      AppSnackbar.error('ລຶບບໍ່ສຳເລັດ');
    }
  }

  void _deleteUserControllers() {
    Get.delete<HomeLogic>(force: true);
    Get.delete<ProfileLogic>(force: true);
    Get.delete<ServiceLogic>(force: true);
    Get.delete<FeedbackLogic>(force: true);
    Get.delete<NotifSettingLogic>(force: true);
    Get.delete<ModelDiscoverLogic>(force: true);
  }

  Future<void> deleteAccount() async {
    showLoadingDialog();
    try {
      final role = Get.find<StorageService>().read<String>('role');
      bool isCustomer = role == 'customer';
      final res = await _registerRepo.deleteAccount(isCustomer: isCustomer);
      hideLoadingDialog();
      if (!res.success || res.data == null) {
        AppSnackbar.error(res.message ?? 'ເກີດຂໍ້ຜິດພາດ! ກະລຸນາລອງໃໝ່ອີກຄັ້ງ');
        return;
      }
      final storage = Get.find<StorageService>();
      await storage.clear();
      Get.find<LoginLogic>().clearState();
      _deleteUserControllers();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      hideLoadingDialog();
      AppSnackbar.error('ເກີດຂໍ້ຜິດພາດ! ກະລຸນາລອງໃໝ່ອີກຄັ້ງ');
    }
  }
}
