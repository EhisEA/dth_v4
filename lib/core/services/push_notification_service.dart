import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_utils/flutter_utils.dart";

class PushNotificationService {
  // final _logger = appLogger(PushNotificationService);
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  PushNotificationService._();
  static final PushNotificationService _i = PushNotificationService._();
  static PushNotificationService get instance => _i;

  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    const logger = AppLogger(PushNotificationService);
    logger.i("Handling a background message: ");
    // locator<HizoFlushBar>().showSuccess(
    //   message: "Notification gotten",
    //   duration: const Duration(seconds: 20),
    // );
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    logger.i("Handling a background message: ${message.messageId}");
    logger.i("Handling a background message: $message");
  }

  Future<void> initialise() async {
    // if (Platform.isIOS) {
    // }
    final NotificationSettings settings = await _fcm.requestPermission();

    //Get first notification
    // RemoteMessage? initialMessage =
    //     await FirebaseMessaging.instance.getInitialMessage();

    // FirebaseMessaging?.onBackgroundMessage((RemoteMessage message) async {
    //   // Parse the message received
    //   //todo: handle notification
    // });
    // String? token = await _fcm.getToken();
    // _logger.d("FirebaseMessaging token: $token");
    // FlutterClipboard.copy(token ?? "no token");
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        const logger = AppLogger(PushNotificationService);
        logger.i("Handling a foreground message: ");
        // locator<HizoFlushBar>().showSuccess(
        //   message: "Notification gotten",
        //   duration: const Duration(seconds: 20),
        // );

        logger.i("Handling a background message: ${message.messageId}");
        logger.i("Handling a background message: ${message.data}");
        logger.i("Handling a background message: ${message.category}");
        logger.i("Handling a background message: ${message.contentAvailable}");
        logger.i("Handling a background message: ${message.from}");
        logger.i("Handling a background message: ${message.messageType}");
        logger.i("Handling a background message: \n${message.toMap()}");

        // ChopsFlushBar.instance.showNotification(
        //   body: message.notification?.body ?? "",
        //   title: message.notification?.title ?? "Notification",
        //   duration: const Duration(seconds: 7),
        // );
      });
    } else {
      // User declined or has not accepted permission
    }
  }

  static Future<String?> getToken() async {
    const logger = AppLogger(PushNotificationService);
    try {
      // On iOS, the APNs token is delivered asynchronously.
      // Retry a few times to allow it to arrive before fetching the FCM token.
      String? apnsToken;

      apnsToken = await FirebaseMessaging.instance.getAPNSToken();

      await Future<void>.delayed(const Duration(seconds: 1));

      logger.i("APNs token: $apnsToken");

      final String? token = await FirebaseMessaging.instance.getToken();
      logger.i("FCM token: $token");
      return token;
    } catch (e) {
      logger.e("Failed to get FCM token: $e");
      return null;
    }
  }
}
