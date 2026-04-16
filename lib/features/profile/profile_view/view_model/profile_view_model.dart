import 'package:dth_v4/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';

class ProfileViewModel extends BaseChangeNotifierViewModel {
  final UserState userState;
  ProfileViewModel(this.userState);

  ValueNotifier<UserModel?> get userModel => userState.user;
}
