import "package:dth_v4/data/models/dth_country.dart";

abstract class CountriesRepo {
  Future<List<DthCountry>> fetchCountries();
}
