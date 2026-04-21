import "dart:async";
import "dart:math" show min;

import "package:dth_v4/data/models/subscription_model.dart";
import "package:dth_v4/features/subscription/components/subscription_plan_card.dart";
import "package:dth_v4/features/subscription/view_model/subscription_checkout_view_model.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

class SubscriptionWidget extends ConsumerStatefulWidget {
  const SubscriptionWidget({super.key, required this.plans});

  final List<SubscriptionModel> plans;

  static const double _heightFraction = 0.65;

  /// Pixels scrolled before the top fade mask is applied (avoids bounce flicker).
  static const double _fadeScrollThreshold = 8;

  @override
  ConsumerState<SubscriptionWidget> createState() => _SubscriptionWidgetState();
}

class _SubscriptionWidgetState extends ConsumerState<SubscriptionWidget> {
  late final ScrollController _scrollController;
  bool _showTopFade = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final next =
        _scrollController.offset > SubscriptionWidget._fadeScrollThreshold;
    if (next != _showTopFade) {
      setState(() => _showTopFade = next);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutVm = ref.watch(subscriptionCheckoutViewModelProvider);
    final h = MediaQuery.sizeOf(context).height;
    final target = h * SubscriptionWidget._heightFraction;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final scrollEndPadding = bottomInset + 70;

    final listView = ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(16, 0, 16, scrollEndPadding),
      physics: const BouncingScrollPhysics(),
      itemCount: widget.plans.length,
      separatorBuilder: (_, __) => Gap.h16,
      itemBuilder: (context, index) {
        final plan = widget.plans[index];
        return SubscriptionPlanCard(
          plan: plan,
          isCheckoutBusy: checkoutVm.isBaseBusy,
          onCTATap: () {
            if (plan.isActiveSubscription) return;
            unawaited(checkoutVm.purchasePlan(plan));
            HapticFeedback.lightImpact();
          },
        );
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxParent = constraints.maxHeight;
        final listHeight = maxParent.isFinite && maxParent > 0
            ? min(target, maxParent)
            : target;

        return SizedBox(
          height: listHeight,
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (Rect bounds) {
              if (!_showTopFade) {
                return const LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
                ).createShader(bounds);
              }
              return const LinearGradient(
                begin: Alignment(0, -1),
                end: Alignment(0, -0.78),
                colors: [Color(0x00000000), Color(0xFFFFFFFF)],
              ).createShader(bounds);
            },
            child: listView,
          ),
        );
      },
    );
  }
}
