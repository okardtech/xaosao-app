import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/pages/model_wallet/components/model_wallet_card.dart';
import 'package:xaosao/pages/model_wallet/components/model_wallet_shimmer.dart';
import 'package:xaosao/pages/model_wallet/getx/model_wallet_logic.dart';
import 'package:xaosao/pages/wallet/components/transaction_card.dart';
import 'package:xaosao/pages/wallet/components/wallet_shimmer.dart';
import 'package:xaosao/widgets/empty_state.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

class ModelWalletPage extends StatefulWidget {
  const ModelWalletPage({super.key});

  @override
  State<ModelWalletPage> createState() => _ModelWalletPageState();
}

class _ModelWalletPageState extends State<ModelWalletPage> {
  bool _amountsVisible = true;
  late final ModelWalletLogic _logic;

  static const _chips = <(String, String?)>[
    ('ທັງໝົດ', null),
    ('ສຳເລັດ', 'completed'),
    ('ລໍຖ້າ', 'pending'),
    ('ດຳເນີນການ', 'processing'),
    ('ຍົກເລີກ', 'rejected'),
  ];

  @override
  void initState() {
    super.initState();
    _logic = Get.find<ModelWalletLogic>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(title: 'ກະເປົ໋າເງິນ', subtitle: 'ຍອດ ແລະ ປະຫວັດ'),
      body: Obx(() {
        final st = _logic.state;
        return RefreshIndicator(
          onRefresh: _logic.refresh,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Wallet card ───────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                  child: st.loadingWallet && st.wallet == null
                      ? const ModelWalletCardShimmer()
                      : st.wallet != null
                      ? ModelWalletCard(
                          wallet: st.wallet!,
                          amountsVisible: _amountsVisible,
                          onToggleVisibility: () => setState(
                            () => _amountsVisible = !_amountsVisible,
                          ),
                          onWithdraw: () =>
                              Get.toNamed(AppRoutes.withdraw),
                        )
                      : const SizedBox.shrink(),
                ),
              ),

              // ── Section label ─────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
                  child: Text(
                    'ປະຫວັດລາຍຮັບ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryVariant,
                    ),
                  ),
                ),
              ),

              // ── Filter chips (pinned) ─────────────────────────
              SliverPersistentHeader(
                pinned: true,
                delegate: _ChipsDelegate(
                  filter: st.filter,
                  chips: _chips,
                  onSelect: _logic.setFilter,
                  height: 42,
                ),
              ),

              // ── Transaction shimmer (first load) ─────────────
              if (st.loadingTx && st.transactions.isEmpty)
                const SliverToBoxAdapter(child: TransactionListShimmer()),

              // ── Empty state ───────────────────────────────────
              if (!st.loadingTx && st.transactions.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'ຍັງບໍ່ມີລາຍການ',
                    subtitle: 'ລາຍການລາຍຮັບຂອງທ່ານ\nຈະສະແດງຢູ່ທີ່ນີ້',
                  ),
                ),

              // ── Transaction list with infinite scroll ─────────
              if (st.transactions.isNotEmpty)
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
                  sliver: SliverList.separated(
                    itemCount:
                        st.transactions.length + (st.hasMore ? 1 : 0),
                    separatorBuilder: (_, __) => SizedBox(height: 8.h),
                    itemBuilder: (_, i) {
                      if (i == st.transactions.length) {
                        _logic.loadMore();
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }
                      return TransactionCard(tx: st.transactions[i]);
                    },
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

// ── Pinned filter chips ────────────────────────────────────────
class _ChipsDelegate extends SliverPersistentHeaderDelegate {
  final String? filter;
  final List<(String, String?)> chips;
  final ValueChanged<String?> onSelect;
  final double height;

  const _ChipsDelegate({
    required this.filter,
    required this.chips,
    required this.onSelect,
    required this.height,
  });

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  bool shouldRebuild(_ChipsDelegate old) => true;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      color: AppColors.bg,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: chips.length,
        separatorBuilder: (_, __) => SizedBox(width: 6.w),
        itemBuilder: (_, i) {
          final (label, status) = chips[i];
          final isOn = filter == status;
          return GestureDetector(
            onTap: () => onSelect(status),
            child: AnimatedContainer(
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isOn ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: isOn ? Colors.white : AppColors.textHint,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
