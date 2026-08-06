import 'package:xaosao/models/gift_model.dart';
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/my_gift_history_model.dart';
import '../services/base_repo.dart';

class GiftRepo extends BaseRepository {
  Future<ApiResponse<List<GiftModel>>> getGifts() {
    return safeCall(
      () => api.get(ApiConstants.gift),
      fromJson: (json) => (json as List)
          .map((item) => GiftModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<bool>> giveGift({
    required String postId,
    required String giftId,
  }) {
    return safeCall(
      () => api.post(
        '${ApiConstants.gift}/post/$postId',
        data: {"giftId": giftId},
      ),
      fromJson: (json) => true,
    );
  }

  Future<ApiResponse<List<MyGiftHistoryModel>>> myGiftHistory() {
    return safeCall(
      () => api.get('${ApiConstants.gift}/history'),
      fromJson: (json) => (json['data'] as List)
          .map((item) => MyGiftHistoryModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
