import 'package:dth_v4/data/data.dart';
import 'package:dth_v4/data/repo/auth/auth.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_utils/flutter_utils.dart';

class CreateAccountViewModel extends BaseChangeNotifierViewModel {
  final AuthRepo _authRepository;
  final DeviceInfoState deviceInfoState;
  CreateAccountViewModel(this._authRepository, this.deviceInfoState);

  Future<String?> register({
    required String fullName,
    required String email,
    required String isoCode,
    required String phone,
  }) async {
    try {
      changeBaseState(const ViewModelState.busy());
      final response = await _authRepository.register(
        fullName: fullName,
        email: email,
        isoCode: isoCode,
        phone: phone,
        deviceName: await deviceInfoState.getDeviceName(),
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

final createAccountViewModelProvider =
    ChangeNotifierProvider<CreateAccountViewModel>((ref) {
      return CreateAccountViewModel(
        ref.read(authRepositoryProvider),
        ref.read(deviceInfoStateProvider),
      );
    });
