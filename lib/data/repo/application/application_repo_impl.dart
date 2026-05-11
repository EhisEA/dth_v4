import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

class ApplicationRepoImpl implements ApplicationRepo {
  ApplicationRepoImpl({required NetworkService networkService})
    : _networkService = networkService;

  final NetworkService _networkService;

  @override
  Future<ApiResponse> submitApplication(
    ApplicationSubmitRequest request,
  ) async {
    final response = await _networkService.post(
      ApiRoute.application,
      data: request.toJson(),
    );
    final root = response.data as Map<String, dynamic>;
    final data = root["data"];
    return ApiResponse(data: data);
  }

  @override
  Future<ApiResponse<ApplicationProcess>> getApplicationProcess() async {
    final response = await _networkService.get(ApiRoute.applicationProcess);
    final root = response.data as Map<String, dynamic>;
    final data = root["data"] as Map<String, dynamic>;
    final process = data["application_process"] as Map<String, dynamic>;
    return ApiResponse(data: ApplicationProcess.fromJson(process));
  }

  @override
  Future<ApiResponse<ApplicantDashboardData>> getApplicantDashboard() async {
    final response = await _networkService.get(ApiRoute.applicantDashboard);
    final root = response.data as Map<String, dynamic>;
    final data = root["data"] as Map<String, dynamic>;
    return ApiResponse(data: ApplicantDashboardData.fromJson(data));
  }

  @override
  Future<ApiResponse<InterviewSlotsData>> getInterviewSlots({
    required String date,
  }) async {
    final response = await _networkService.get(
      ApiRoute.applicantInterviewSlots,
      queryParams: <String, dynamic>{"date": date},
    );
    final root = response.data as Map<String, dynamic>;
    final data = root["data"] as Map<String, dynamic>;
    return ApiResponse(data: InterviewSlotsData.fromJson(data));
  }
}

final applicationRepositoryProvider = Provider<ApplicationRepo>((ref) {
  return ApplicationRepoImpl(networkService: ref.read(networkServiceProvider));
});
