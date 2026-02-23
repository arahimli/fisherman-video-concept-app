import 'dart:io';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/design/design_system.dart';
import '../../l10n/app_localizations.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  static final String _interstitialAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  static final String _rewardedAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  static const String _adsWatchedKey = 'ads_watched_count';

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _interstitialLoaded = false;
  bool _rewardedLoaded = false;
  bool _rewardEarned = false;

  late final ConfettiController _confettiController;
  int _adsWatched = 0;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _loadAdsWatched();
    _loadInterstitial();
    _loadRewarded();
  }

  Future<void> _loadAdsWatched() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => _adsWatched = prefs.getInt(_adsWatchedKey) ?? 0);
  }

  Future<void> _incrementAdsWatched() async {
    final prefs = await SharedPreferences.getInstance();
    final newCount = _adsWatched + 1;
    await prefs.setInt(_adsWatchedKey, newCount);
    if (mounted) setState(() => _adsWatched = newCount);
  }

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              setState(() => _interstitialLoaded = false);
              _loadInterstitial();
              _onAdWatched();
            },
            onAdFailedToShowFullScreenContent: (ad, _) {
              ad.dispose();
              _interstitialAd = null;
              setState(() => _interstitialLoaded = false);
              _loadInterstitial();
            },
          );
          setState(() => _interstitialLoaded = true);
        },
        onAdFailedToLoad: (_) => setState(() => _interstitialLoaded = false),
      ),
    );
  }

  void _loadRewarded() {
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              setState(() => _rewardedLoaded = false);
              _loadRewarded();
              if (_rewardEarned) {
                _rewardEarned = false;
                _onAdWatched();
              }
            },
            onAdFailedToShowFullScreenContent: (ad, _) {
              ad.dispose();
              _rewardedAd = null;
              setState(() => _rewardedLoaded = false);
              _loadRewarded();
            },
          );
          setState(() => _rewardedLoaded = true);
        },
        onAdFailedToLoad: (_) => setState(() => _rewardedLoaded = false),
      ),
    );
  }

  void _onAdWatched() {
    _incrementAdsWatched();
    _confettiController.play();
    _showThankYou();
  }

  void _showThankYou() {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.thankYouSupport),
        backgroundColor: AppColors.accent,
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.support, style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              children: [
                const SizedBox(height: AppSpacing.lg),
                const Icon(Icons.favorite_outline, color: AppColors.accent, size: 48),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.supportDesc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _AdsWatchedCounter(count: _adsWatched, label: l10n.adsWatched),
                const SizedBox(height: AppSpacing.xxxl),
                _AdCard(
                  icon: Icons.play_circle_outline,
                  title: l10n.shortVideo,
                  description: l10n.shortVideoDesc,
                  loaded: _interstitialLoaded,
                  onWatch: () => _interstitialAd?.show(),
                  l10n: l10n,
                ),
                const SizedBox(height: AppSpacing.md),
                _AdCard(
                  icon: Icons.movie_outlined,
                  title: l10n.longVideo,
                  description: l10n.longVideoDesc,
                  loaded: _rewardedLoaded,
                  onWatch: () => _rewardedAd?.show(
                    onUserEarnedReward: (_, __) => _rewardEarned = true,
                  ),
                  l10n: l10n,
                ),
              ],
            ),
          ),
          // Confetti burst from top-center after an ad is watched
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2, // straight down
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
              gravity: 0.3,
              emissionFrequency: 0.05,
              colors: const [
                AppColors.accent,
                Colors.white,
                Color(0xFFFFD700),
                Color(0xFF4CAF50),
                Color(0xFF2196F3),
                Color(0xFFE91E63),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Ads watched counter ────────────────────────────────────────────────────────

class _AdsWatchedCounter extends StatelessWidget {
  final int count;
  final String label;

  const _AdsWatchedCounter({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.accentBorderFaint),
      ),
      child: Column(
        children: [
          const Icon(Icons.volunteer_activism, color: AppColors.accent, size: 20),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$count',
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 52,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Ad card ───────────────────────────────────────────────────────────────────

class _AdCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool loaded;
  final VoidCallback onWatch;
  final AppLocalizations l10n;

  const _AdCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.loaded,
    required this.onWatch,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.accentBorderFaint),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.accentOverlay,
              borderRadius: AppRadius.mdAll,
            ),
            child: Icon(icon, color: AppColors.accent, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.historyCardTitle),
                const SizedBox(height: 2),
                Text(description, style: AppTextStyles.historyCardDate),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          loaded
              ? ElevatedButton(
                  onPressed: onWatch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(l10n.watchAd, style: const TextStyle(fontSize: 12)),
                )
              : const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.accent,
                  ),
                ),
        ],
      ),
    );
  }
}
