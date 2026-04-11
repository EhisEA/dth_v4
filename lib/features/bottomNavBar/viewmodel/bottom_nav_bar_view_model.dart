import 'package:dth_v4/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';

class BottomNavBarViewModel extends BaseChangeNotifierViewModel {
  final UserState userState;
  BottomNavBarViewModel(this.userState);

  ValueNotifier<UserModel?> get userModel => userState.user;
}
