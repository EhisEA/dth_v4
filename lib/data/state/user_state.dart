import "dart:async";

import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:dth_v4/data/state/state.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

class UserProfileState extends BaseState {
  final LocalCache _localCache;
  // final ProfileRepo _profileRepository;

  UserProfileState(this._localCache);

  final _logger = const AppLogger(UserProfileState);
  final Debouncer _debouncer = Debouncer(milliseconds: 60000);

  late final ValueNotifier<UserModel?> _user = ValueNotifier(null);
  ValueNotifier<UserModel?> get user => _user;

  void setUser(UserModel? newUser) {
    _user.value = newUser;
  }

  void init() {
    unawaited(getUserDetails());
    unawaited(getUserTradeLevelFromServer());
    _debouncer.cancel();
    _debouncer.runPeriodic(() => updateUserDataFromServer());
  }

  Future<void> getUserDetails() async {
    try {
      final userData = _localCache.getUserData();

      if (userData == null) return;
      _user.value = UserModel.fromJson(userData);
      _logger.i(
        "getUserDetails: set _user from local cache: ${_user.value?.toJson()}",
      );
      await getUserDetailsFromServer();
    } catch (e) {
      handleError(e, "getUserDetails");
    }
  }

  Future<void> updateUserDataFromServer() async {
    if (_user.value == null) {
      _debouncer.cancel();
      return;
    }

    await getUserDetailsFromServer();
  }

  Future<void> getUserDetailsFromServer() async {
    // try {
    //   final response = await _profileRepository.getUserData();
    //   _logger.i(
    //     "getUserDetailsFromServer: server response: ${response.data?.toJson()}",
    //   );

    //   if (response.data == null) return;
    //   _user.value = response.data!;
    //   _logger.i(
    //     "getUserDetailsFromServer: set _user to server data: ${_user.value?.toJson()}",
    //   );
    //   await _localCache.saveUserData(response.data!.toJson());
    // } catch (e) {
    //   handleError(e, "getUserDetails");
    // }
  }

  void updateUserData(UserModel user) {
    unawaited(_localCache.saveUserData(user.toJson()));
    unawaited(getUserDetails());
  }

  Future<void> getUserTradeLevel() async {
    final userData = _localCache.getUserData();

    if (userData == null) return;
    unawaited(getUserTradeLevelFromServer());
  }

  Future<void> getUserTradeLevelFromServer() async {
    // try {
    //   final response = await _profileRepository.getTradeLevel();

    //   if (response.data == null) return;
    //   _userTradeLevel.value = response.data!;
    //   unawaited(
    //     _localCache.saveToLocalCache(
    //       key: CacheKeys.userTradeLevel,
    //       value: _userTradeLevel.value?.toJson(),
    //     ),
    //   );
    // } catch (e) {
    //   handleError(e, "getUserTradeLevelFromServer");
    // }
  }

  void logOut() {
    _debouncer.cancel();
    _user.value = null;
  }

  @override
  void dispose() {
    _debouncer.cancel();
    _user.dispose();
  }
}

/// Backward-compatible alias so existing `UserState` references still compile.
typedef UserState = UserProfileState;

final userProfileStateProvider = Provider((ref) {
  final state = UserProfileState(ref.read(localCacheProvider));
  ref.onDispose(state.dispose);
  return state;
});

/// Backward-compatible alias so existing `userStateProvider` references still compile.
final userStateProvider = userProfileStateProvider;
