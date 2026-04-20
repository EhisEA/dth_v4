import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/data/models/user_model.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_utils/flutter_utils.dart';

class ContestantPill extends StatelessWidget {
  const ContestantPill({super.key, this.user});

  final UserModel? user;

  static const _chipPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
  );

  @override
  Widget build(BuildContext context) {
    final role = user?.participationRole ?? ParticipationRole.user;
    switch (role) {
      case ParticipationRole.contestant:
        final u = user;
        if (u == null) return const SizedBox.shrink();
        return _withProfileSpacing(_dualPills(label: "CONTESTANT", user: u));
      case ParticipationRole.applicant:
        final u = user;
        if (u == null) return const SizedBox.shrink();
        return _withProfileSpacing(_dualPills(label: "APPLICANT", user: u));
      case ParticipationRole.user:
      case ParticipationRole.unknown:
        return const SizedBox.shrink();
    }
  }

  Widget _withProfileSpacing(Widget pillRow) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Gap.h16,
        Center(child: pillRow),
      ],
    );
  }

  Widget _dualPills({required String label, required UserModel user}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _PillShell(
          child: AppText.medium(
            label,
            fontSize: 10,
            color: AppColors.mainBlack,
            letterSpacing: 0.4,
          ),
        ),
        Gap.w8,
        _IdPill(user: user),
      ],
    );
  }
}

class _PillShell extends StatelessWidget {
  const _PillShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ContestantPill._chipPadding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: AppColors.white,
        border: Border.all(color: AppColors.greyTint30),
      ),
      child: child,
    );
  }
}

class _IdPill extends StatelessWidget {
  const _IdPill({required this.user});

  final UserModel user;

  String _displayUid(String raw) {
    if (raw.isEmpty) return "—";
    final u = raw.toUpperCase();
    if (u.length <= 14) return u;
    return "${u.substring(0, 12)}…";
  }

  @override
  Widget build(BuildContext context) {
    final uid = user.participationType.id ?? "";
    final display = _displayUid(uid);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: user.participationType.id == null
            ? null
            : () {
                Clipboard.setData(
                  ClipboardData(text: user.participationType.id ?? ""),
                );
                HapticFeedback.lightImpact();
              },
        borderRadius: BorderRadius.circular(100),
        child: _PillShell(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.medium(
                display,
                fontSize: 10,
                color: AppColors.mainBlack,
                letterSpacing: 0.4,
              ),
              Gap.w4,
              SvgPicture.asset(
                SvgAssets.copy,
                width: 14,
                height: 14,
                colorFilter: ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
