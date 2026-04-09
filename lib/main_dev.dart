import "dart:async";

import "package:dth_v4/flavor/flavor_config.dart";

import "package:dth_v4/main_runner.dart" as runner;

import "core/constants/constants.dart";

void main() async {
  FlavorConfig(
    flavor: Flavor.dev,
    title: Flavor.dev.title,
    baseUrl: ApiRoute.stagingBaseURL,
  );
  unawaited(runner.main());
}
