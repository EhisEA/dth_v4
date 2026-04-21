import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/data/data.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GetStartedViewModel extends BaseChangeNotifierViewModel {
  GetStartedViewModel(
    this._authRepository,
    this._userState,
    this._deviceInfoState,
  );

  final AuthRepo _authRepository;
  final UserProfileState _userState;
  final DeviceInfoState _deviceInfoState;

  // `serverClientId` must match the backend's Google OAuth client audience.
  // Provide via --dart-define=GOOGLE_SERVER_CLIENT_ID=... (required for backend id_token verification).
  static const String _serverClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );

  GoogleSignIn _buildGoogleSignIn() {
    return GoogleSignIn(
      scopes: const ['email', 'profile'],
      serverClientId: _serverClientId.isEmpty ? null : _serverClientId,
    );
  }

  Future<bool> signInWithGoogle() async {
    if (isBaseBusy) return false;
    final googleSignIn = _buildGoogleSignIn();
    try {
      changeBaseState(const ViewModelState.busy());

      final account = await googleSignIn.signIn();
      if (account == null) {
        changeBaseState(const ViewModelState.idle());
        return false;
      }

      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        changeBaseState(const ViewModelState.idle());
        DthFlushBar.instance.showError(
          title: 'Google Sign-In',
          message: 'Could not get Google ID token. Try again.',
        );
        return false;
      }

      final deviceName = await _deviceInfoState.getDeviceName();
      final fcmToken = await PushNotificationService.getToken();

      await _authRepository.loginWithGoogle(
        idToken: idToken,
        deviceName: deviceName,
        fcmToken: fcmToken ?? '',
        fullName: account.displayName,
      );
      await _userState.getUserDetails();

      changeBaseState(const ViewModelState.idle());
      return true;
    } on ApiFailure catch (e) {
      changeBaseState(ViewModelState.error(e));
      DthFlushBar.instance.showError(message: e.message, title: 'Failed');
      await googleSignIn.signOut();
      return false;
    } catch (e) {
      changeBaseState(const ViewModelState.idle());
      DthFlushBar.instance.showError(
        title: 'Google Sign-In',
        message: 'Something went wrong. Please try again.',
      );
      await googleSignIn.signOut();
      return false;
    }
  }
}

final getStartedViewModelProvider =
    ChangeNotifierProvider.autoDispose<GetStartedViewModel>((ref) {
      return GetStartedViewModel(
        ref.read(authRepositoryProvider),
        ref.read(userStateProvider),
        ref.read(deviceInfoStateProvider),
      );
    });
