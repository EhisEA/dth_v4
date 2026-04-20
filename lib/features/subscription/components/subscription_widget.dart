import "dart:math" show min;

import "package:dth_v4/core/router/router.dart";
import "package:dth_v4/data/models/subscription_model.dart";
import "package:dth_v4/features/subscription/subscription.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_utils/flutter_utils.dart";

class SubscriptionPlansList extends StatelessWidget {
  const SubscriptionPlansList({super.key, required this.plans});

  final List<SubscriptionModel> plans;

  static const double _heightFraction = 0.64;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final target = h * _heightFraction;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final scrollEndPadding = bottomInset + 70;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxParent = constraints.maxHeight;
        final listHeight = maxParent.isFinite && maxParent > 0
            ? min(target, maxParent)
            : target;

        return SizedBox(
          height: listHeight,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16, 8, 16, scrollEndPadding),
            itemCount: plans.length,
            separatorBuilder: (_, __) => Gap.h16,
            itemBuilder: (context, index) {
              return SubscriptionPlanCard(
                plan: plans[index],
                onCTATap: () {
                  MobileNavigationService.instance.push(
                    ConfirmationView.path,
                    extra: {RoutingArgumentKey.confirmationSuccess: true},
                  );
                  HapticFeedback.lightImpact();
                },
              );
            },
          ),
        );
      },
    );
  }
}
