import "package:dth_v4/data/data.dart";
import "package:flutter_utils/flutter_utils.dart";

abstract class ApplicationRepo {
  Future<ApiResponse> submitApplication(
    ApplicationSubmitRequest request,
  );

  Future<ApiResponse<ApplicationProcess>> getApplicationProcess();
}
