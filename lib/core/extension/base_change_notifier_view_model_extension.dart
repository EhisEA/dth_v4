import "package:flutter_utils/flutter_utils.dart";
import "package:dth_v4/widgets/widgets.dart";

extension X on BaseChangeNotifierViewModel {
  void showErrorFlushbar({required String title, required String message}) {
    DthFlushBar.instance.showError(message: message, title: title);
  }

  void showSuccessFlushbar({required String message, required String title}) {
    DthFlushBar.instance.showSuccess(message: message, title: title);
  }
}
