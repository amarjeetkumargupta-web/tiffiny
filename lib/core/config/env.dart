enum EnvironmentType { dev, staging, prod }

class AppConfig {
  static const EnvironmentType currentEnvironment = EnvironmentType.dev;

  // App Identity
  static const String appName = 'Tiffiny';
  static const String appVersion = '1.0.0';
  static const int appBuildNumber = 1;
  static const String androidPackageId = 'com.tiffiny.app';
  static const String iosBundleId = 'com.tiffiny.app';

  // Razorpay Gateway Keys (Client uses Key ID only; Secret Key stays on Cloud Functions)
  static const String razorpayKeyIdDev = 'rzp_test_51MockKeyTiffiny';
  static const String razorpayKeyIdProd = 'rzp_live_MockKeyTiffiny';

  static String get razorpayKeyId =>
      currentEnvironment == EnvironmentType.prod
          ? razorpayKeyIdProd
          : razorpayKeyIdDev;

  // Google Maps SDK
  static const String googleMapsApiKeyAndroid = 'AIzaSy_MOCK_ANDROID_MAPS_KEY';
  static const String googleMapsApiKeyIos = 'AIzaSy_MOCK_IOS_MAPS_KEY';

  // Subscription & Cut-off Defaults
  static const int defaultSkipCutoffHour = 21; // 9:00 PM previous evening
  static const int defaultMaxSkipsPerMonth = 10;
  static const int defaultDeliveryRadiusKm = 8;
  static const String defaultTimeZone = 'Asia/Kolkata';

  // Support
  static const String supportEmail = 'help@tiffiny.in';
  static const String termsUrl = 'https://tiffiny.in/terms';
  static const String privacyPolicyUrl = 'https://tiffiny.in/privacy';
  static const String accountDeletionUrl = 'https://tiffiny.in/delete-account';
}
