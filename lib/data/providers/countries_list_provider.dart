import "dart:convert";

import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/models/dth_country.dart";
import "package:dth_v4/data/repo/countries/countries.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

/// Loads countries once per app session; prefers disk cache to avoid repeat HTTP.
final countriesListProvider = FutureProvider<List<DthCountry>>((ref) async {
  final cache = ref.read(localCacheProvider);
  final raw = cache.getFromLocalCache(CacheKeys.countries);
  if (raw is String && raw.isNotEmpty) {
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final list = decoded
          .map((e) => DthCountry.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      if (list.isNotEmpty) {
        return list;
      }
    } on Object {
      // fall through to network
    }
  }

  final repo = ref.read(countriesRepositoryProvider);
  final list = await repo.fetchCountries();
  if (list.isNotEmpty) {
    await cache.saveToLocalCache(
      key: CacheKeys.countries,
      value: list.map((c) => c.toJson()).toList(),
    );
  }
  return list;
});
