import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/data/models/user_model.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_utils/flutter_utils.dart';

/// Role badge(s) under the profile name: **BASIC PLAN** (user), or role + id
/// with copy (applicant / contestant).
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
        return _dualPills(label: "CONTESTANT", uid: user?.uid ?? "");
      case ParticipationRole.applicant:
        return _dualPills(label: "APPLICANT", uid: user?.uid ?? "");
      case ParticipationRole.user:
      case ParticipationRole.unknown:
        return _singlePill("BASIC PLAN");
    }
  }

  Widget _singlePill(String label) {
    return _PillShell(
      child: AppText.medium(
        label,
        fontSize: 10,
        color: AppColors.mainBlack,
        letterSpacing: 0.4,
      ),
    );
  }

  Widget _dualPills({required String label, required String uid}) {
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
        _IdPill(uid: uid),
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
  const _IdPill({required this.uid});

  final String uid;

  String _displayUid(String raw) {
    if (raw.isEmpty) return "—";
    final u = raw.toUpperCase();
    if (u.length <= 14) return u;
    return "${u.substring(0, 12)}…";
  }

  @override
  Widget build(BuildContext context) {
    final display = _displayUid(uid);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: uid.isEmpty
            ? null
            : () {
                Clipboard.setData(ClipboardData(text: uid));
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
