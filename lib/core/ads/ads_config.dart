import 'dart:io';

abstract class AdsConfig {
  static const String androidAppId = 'ca-app-pub-9530282216810256~3098728908';
  static const String iosAppId = 'ca-app-pub-9530282216810256~6520599906';
  static String get appId => Platform.isAndroid ? androidAppId : iosAppId;

  // Test device IDs — add physical devices here to receive test ads
  static const List<String> testDeviceIds = [];

  // Banner ad units (loading screen — top and bottom)
  static final String bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-9530282216810256/8467110230'
      : 'ca-app-pub-9530282216810256/5194390039';

  // Interstitial ad unit (short video — support page)
  static final String interstitialAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-9530282216810256/6080620040'
      : 'ca-app-pub-9530282216810256/7440404685';

  // Rewarded ad unit (long video — support page)
  static final String rewardedAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-9530282216810256/1992221283'
      : 'ca-app-pub-9530282216810256/7844604109';
}
