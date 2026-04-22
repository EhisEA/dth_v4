import "package:dth_v4/data/data.dart";
import "package:flutter/foundation.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class AppModulesState extends BaseState {
  AppModulesState(this._repo);

  final AppModulesRepo _repo;

  final ValueNotifier<AppModulesModel?> appModules = ValueNotifier(null);

  Future<void> fetchModules() async {
    final response = await _repo.getAppModules();
    appModules.value = response.data;
  }

  @override
  void dispose() {
    appModules.dispose();
  }
}

final appModulesStateProvider = Provider<AppModulesState>((ref) {
  final state = AppModulesState(ref.read(appModulesRepositoryProvider));
  ref.onDispose(state.dispose);
  return state;
});
