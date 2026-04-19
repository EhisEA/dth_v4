import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApplicationWidget extends StatelessWidget {
  const ApplicationWidget({
    super.key,
    required this.participationRole,
    required this.onTap,
  });

  final ParticipationRole participationRole;
  final VoidCallback onTap;

  static String imageAssetForRole(ParticipationRole role) {
    switch (role) {
      case ParticipationRole.contestant:
        return ImageAssets.contestant1;
      case ParticipationRole.applicant:
        return ImageAssets.applicant1;
      case ParticipationRole.user:
      case ParticipationRole.unknown:
        return ImageAssets.user1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final asset = imageAssetForRole(participationRole);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap();
        HapticFeedback.lightImpact();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 88,
          width: double.infinity,
          child: Image.asset(
            asset,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
