import "dart:async";
import "package:dth_v4/core/constants/api_routes.dart";
import "package:dth_v4/flavor/flavor_config.dart";

import "package:dth_v4/main_runner.dart" as runner;

void main() async {
  FlavorConfig(
    flavor: Flavor.prod,
    title: Flavor.prod.title,
    baseUrl: ApiRoute.prodBaseURL,
  );
  unawaited(runner.main());
}
