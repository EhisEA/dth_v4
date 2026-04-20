import 'package:dth_v4/data/data.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_utils/flutter_utils.dart';

class LoginViewModel extends BaseChangeNotifierViewModel {
  LoginViewModel(this._authRepository, this._deviceInfoState);

  final AuthRepo _authRepository;
  final DeviceInfoState _deviceInfoState;

  /// Returns OTP [signature] on success.
  Future<String?> login({required String email}) async {
    try {
      changeBaseState(const ViewModelState.busy());
      final response = await _authRepository.login(
        email: email,
        deviceName: await _deviceInfoState.getDeviceName(),
      );
      changeBaseState(const ViewModelState.idle());
      return response.data?.signature;
    } on ApiFailure catch (e) {
      changeBaseState(ViewModelState.error(e));
      DthFlushBar.instance.showError(message: e.message, title: 'Failed');
      return null;
    }
  }
}

final loginViewModelProvider = ChangeNotifierProvider<LoginViewModel>((ref) {
  return LoginViewModel(
    ref.read(authRepositoryProvider),
    ref.read(deviceInfoStateProvider),
  );
});
