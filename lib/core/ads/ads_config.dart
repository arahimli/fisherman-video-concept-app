import 'dart:io';

abstract class AdsConfig {
  // App ID (used for iOS and as the AdMob app identifier)
  static const String appId = 'ca-app-pub-9530282216810256~3098728908';

  // Banner ad units (loading screen — top and bottom)
  static final String bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-9530282216810256/8467110230'
      : appId;

  // Interstitial ad unit (short video — support page)
  static final String interstitialAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-9530282216810256/6080620040'
      : appId;

  // Rewarded ad unit (long video — support page)
  static final String rewardedAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-9530282216810256/1992221283'
      : appId;
}
