import 'package:dth_v4/features/polls/components/avatar_dot.dart';
import 'package:flutter/material.dart';

class VoterStack extends StatelessWidget {
  const VoterStack({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 20,
      child: Stack(
        children: const [
          Positioned(left: 0, child: AvatarDot()),
          Positioned(left: 10, child: AvatarDot()),
          Positioned(left: 20, child: AvatarDot()),
        ],
      ),
    );
  }
}
