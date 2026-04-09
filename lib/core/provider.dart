import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:dth_v4/core/constants/constants.dart";
import "package:dth_v4/core/interceptors/data_manipulation_interceptor.dart";
import "package:dth_v4/data/state/device_info_state.dart";

// DataManipulationInterceptor provider
final dataManipulationInterceptorProvider =
    Provider<DataManipulationInterceptor>((ref) {
      return DataManipulationInterceptor(
        ref.read(deviceInfoStateProvider),
        ref: ref,
      );
    });

final networkServiceProvider = Provider<NetworkServiceImpl>((ref) {
  final network = NetworkServiceImpl(
    interceptors: [
      ref.read(dataManipulationInterceptorProvider),
      LoggingInterceptor(),
    ],
  );
  // Set initial token from cache
  network.accessToken = ref.watch(localCacheProvider).getToken();
  return network;
});
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // This gets overridden in main()
});

final localCacheProvider = Provider<LocalCacheImpl>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return LocalCacheImpl(
    sharedPreferences: sharedPrefs,
    userDataStorageKey: CacheKeys.user,
  );
});
