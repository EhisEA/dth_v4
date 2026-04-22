import "dart:async";

import "package:dth_v4/firebase_options_dev.dart";
import "package:dth_v4/flavor/flavor_config.dart";
import "package:dth_v4/main_runner.dart" as runner;
import "package:firebase_core/firebase_core.dart";
import "package:flutter/widgets.dart";

import "core/constants/constants.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig(
    flavor: Flavor.dev,
    title: Flavor.dev.title,
    baseUrl: ApiRoute.stagingBaseURL,
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  unawaited(runner.main());
}
