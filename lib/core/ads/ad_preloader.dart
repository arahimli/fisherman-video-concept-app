import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_config.dart';

class AdPreloader extends ChangeNotifier {
  RewardedInterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _interstitialLoaded = false;
  bool _rewardedLoaded = false;
  bool _interstitialFailed = false;
  bool _rewardedFailed = false;
  int _interstitialRetries = 0;
  int _rewardedRetries = 0;
  static const _maxRetries = 3;

  bool get interstitialLoaded => _interstitialLoaded;
  bool get rewardedLoaded => _rewardedLoaded;
  bool get interstitialFailed => _interstitialFailed;
  bool get rewardedFailed => _rewardedFailed;

  AdPreloader() {
    // Small delay to let the AdMob SDK fully initialize before requesting ads
    Future.delayed(const Duration(seconds: 1), () {
      loadInterstitial();
      loadRewarded();
    });
  }

  void loadInterstitial() {
    _interstitialFailed = false;
    RewardedInterstitialAd.load(
      adUnitId: AdsConfig.interstitialAdUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialLoaded = true;
          _interstitialFailed = false;
          _interstitialRetries = 0;
          notifyListeners();
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failed to load: ${error.message}');
          _interstitialLoaded = false;
          if (_interstitialRetries >= _maxRetries) {
            _interstitialFailed = true;
          }
          notifyListeners();
          _retryInterstitial();
        },
      ),
    );
  }

  void _retryInterstitial() {
    if (_interstitialRetries >= _maxRetries) return;
    _interstitialRetries++;
    Future.delayed(Duration(seconds: 2 * _interstitialRetries), loadInterstitial);
  }

  void retryAllFailed() {
    if (_interstitialFailed) {
      _interstitialRetries = 0;
      loadInterstitial();
    }
    if (_rewardedFailed) {
      _rewardedRetries = 0;
      loadRewarded();
    }
  }

  void loadRewarded() {
    RewardedAd.load(
      adUnitId: AdsConfig.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedLoaded = true;
          _rewardedRetries = 0;
          notifyListeners();
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded failed to load: ${error.message}');
          _rewardedLoaded = false;
          if (_rewardedRetries >= _maxRetries) {
            _rewardedFailed = true;
          }
          notifyListeners();
          _retryRewarded();
        },
      ),
    );
  }

  void _retryRewarded() {
    if (_rewardedRetries >= _maxRetries) return;
    _rewardedRetries++;
    Future.delayed(Duration(seconds: 2 * _rewardedRetries), loadRewarded);
  }

  /// Shows the rewarded interstitial ad. Returns true if it was shown.
  bool showInterstitial({required VoidCallback onDismissed}) {
    if (_interstitialAd == null) return false;
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _interstitialLoaded = false;
        _interstitialRetries = 0;
        notifyListeners();
        loadInterstitial();
        onDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _interstitialAd = null;
        _interstitialLoaded = false;
        _interstitialRetries = 0;
        notifyListeners();
        loadInterstitial();
      },
    );
    _interstitialAd!.show(onUserEarnedReward: (_, __) {});
    return true;
  }

  /// Shows the rewarded ad. Returns true if it was shown.
  bool showRewarded({
    required VoidCallback onDismissed,
    required VoidCallback onRewardEarned,
  }) {
    if (_rewardedAd == null) return false;
    bool earned = false;
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _rewardedLoaded = false;
        _rewardedRetries = 0;
        notifyListeners();
        loadRewarded();
        if (earned) onDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _rewardedAd = null;
        _rewardedLoaded = false;
        _rewardedRetries = 0;
        notifyListeners();
        loadRewarded();
      },
    );
    _rewardedAd!.show(onUserEarnedReward: (_, __) {
      earned = true;
      onRewardEarned();
    });
    return true;
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }
}
