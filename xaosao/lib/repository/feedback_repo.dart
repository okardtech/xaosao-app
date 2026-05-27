import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/my_feedback_model.dart';
import '../services/base_repo.dart';

class FeedbackRepo extends BaseRepository {
  Future<ApiResponse<List<MyFeedbackModel>>> getMyFeedback() {
    return safeCall(
      () => api.get('${ApiConstants.feedback}/my'),
      fromJson: (json) => (json as List)
          .map((item) => MyFeedbackModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<bool>> addFeedback({
    required String subject,
    required String desc,
  }) {
    return safeCall(
      () => api.post(
        ApiConstants.feedback,
        data: {
          "type": "bug",
          "subject": subject,
          "description": desc,
          "deviceInfo": "iPhone 15, iOS 18.1",
          "appVersion": "1.2.3",
        },
      ),
      fromJson: (json) => true,
    );
  }
}
