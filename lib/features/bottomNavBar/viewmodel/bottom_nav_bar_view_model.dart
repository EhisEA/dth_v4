import "package:dth_v4/data/data.dart";
import "package:flutter/material.dart";
import "package:flutter_utils/flutter_utils.dart";

class BottomNavBarViewModel extends BaseChangeNotifierViewModel {
  BottomNavBarViewModel(this.userState, this.subscriptionPlansState);

  final UserState userState;
  final SubscriptionPlansState subscriptionPlansState;

  ValueNotifier<UserModel?> get userModel => userState.user;
}
