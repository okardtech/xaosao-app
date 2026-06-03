import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/models/profile_model.dart';
import 'package:xaosao/utils/share_utils.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

import '../referral_analytics/getx/referral_analytics_logic.dart';
import 'components/share_bonus_card.dart';
import 'components/share_header_card.dart';
import 'components/share_how_it_works.dart';
import 'components/share_referral_card.dart';

class ShareLinkedPage extends StatelessWidget {
  final ModelProfileModel model;
  const ShareLinkedPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final refCode = model.referralCode ?? '';
    final link = ShareUtils.buildReferralLink(refCode);
    final totalModels = model.totalReferredModels ?? 0;
    final earnings = totalModels * 10000.0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: 'ແນະນຳໝູ່',
        subtitle: 'ຮັບ 10,000 ກີບ ຕໍ່ການແນະນຳ',
        actions: [
          GestureDetector(
            onTap: () {
              Get.find<ReferralAnalyticsLogic>().fetch();
              Get.toNamed(AppRoutes.referralAnalytics);
            },
            child: Container(
              width: 34.r,
              height: 34.r,
              margin: EdgeInsets.only(right: 6.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.bar_chart_rounded,
                size: 18.r,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 40.h),
        child: Column(
          children: [
            ShareHeaderCard(
              refCode: refCode,
              link: link,
              totalModels: totalModels,
              earnings: earnings,
              modelName: model.fullName,
              profileUrl: model.profile,
            ),
            SizedBox(height: 16.h),
            const ShareHowItWorks(),
            SizedBox(height: 16.h),
            ShareReferralCard(totalModels: totalModels, refCode: refCode),
            SizedBox(height: 16.h),
            ShareBonusCard(current: totalModels, target: 2),
          ],
        ),
      ),
    );
  }
}
