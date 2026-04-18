import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/models/dth_country.dart";
import "package:dth_v4/data/repo/countries/countries_repo.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

class CountriesRepoImpl implements CountriesRepo {
  CountriesRepoImpl({required NetworkService networkService})
    : _networkService = networkService;

  final NetworkService _networkService;

  @override
  Future<List<DthCountry>> fetchCountries() async {
    final response = await _networkService.get(ApiRoute.countries);

    final data = response.data["data"];
    if (data is! Map<String, dynamic>) {
      return const [];
    }
    final raw = data["countries"];
    if (raw is! List<dynamic>) {
      return const [];
    }
    return raw
        .map((e) => DthCountry.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}

final countriesRepositoryProvider = Provider<CountriesRepo>((ref) {
  return CountriesRepoImpl(networkService: ref.read(networkServiceProvider));
});
