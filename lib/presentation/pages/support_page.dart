import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/ads/ad_preloader.dart';
import '../../core/di/service_locator.dart';
import '../../core/design/design_system.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_localizations_extension.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  static const String _keyTotal = 'ads_watched_count';
  static const String _keyToday = 'ads_watched_today';
  static const String _keyDate = 'ads_watched_date';

  late final AdPreloader _adPreloader;
  late final ConfettiController _confettiController;
  int _adsWatched = 0;
  int _adsWatchedToday = 0;

  @override
  void initState() {
    super.initState();
    _adPreloader = sl<AdPreloader>();
    _adPreloader.addListener(_onAdStateChanged);
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _loadCounts();
  }

  void _onAdStateChanged() {
    if (mounted) setState(() {});
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> _loadCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayString();
    final storedDate = prefs.getString(_keyDate) ?? '';
    final todayCount = storedDate == today ? (prefs.getInt(_keyToday) ?? 0) : 0;
    if (mounted) {
      setState(() {
        _adsWatched = prefs.getInt(_keyTotal) ?? 0;
        _adsWatchedToday = todayCount;
      });
    }
  }

  Future<void> _incrementCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayString();
    final storedDate = prefs.getString(_keyDate) ?? '';
    final currentToday = storedDate == today ? (prefs.getInt(_keyToday) ?? 0) : 0;
    final newTotal = _adsWatched + 1;
    final newToday = currentToday + 1;
    await prefs.setInt(_keyTotal, newTotal);
    await prefs.setInt(_keyToday, newToday);
    await prefs.setString(_keyDate, today);
    if (mounted) {
      setState(() {
        _adsWatched = newTotal;
        _adsWatchedToday = newToday;
      });
    }
  }

  void _onAdWatched() {
    _incrementCounts();
    _confettiController.play();
    _showThankYou();
  }

  void _showThankYou() {
    if (!mounted) return;
    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.thankYouSupport),
        backgroundColor: AppColors.accent,
      ),
    );
  }

  @override
  void dispose() {
    _adPreloader.removeListener(_onAdStateChanged);
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
                const AppVectorIcon(AppVectors.heartHandDonate, color: AppColors.accent, size: 48),
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
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        count: _adsWatchedToday,
                        label: l10n.adsWatchedToday,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _StatCard(
                        count: _adsWatched,
                        label: l10n.adsWatchedTotal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxxl),
                _AdCard(
                  icon: const AppVectorIcon(AppVectors.playCircle, color: AppColors.accent, size: 24),
                  title: l10n.shortVideo,
                  description: l10n.shortVideoDesc,
                  loaded: _adPreloader.interstitialLoaded,
                  failed: _adPreloader.interstitialFailed,
                  onWatch: () => _adPreloader.showInterstitial(
                    onDismissed: _onAdWatched,
                  ),
                  onRetry: () => _adPreloader.retryAllFailed(),
                  l10n: l10n,
                ),
                const SizedBox(height: AppSpacing.md),
                _AdCard(
                  icon: const AppVectorIcon(AppVectors.videoAds, color: AppColors.accent, size: 24),
                  title: l10n.longVideo,
                  description: l10n.longVideoDesc,
                  loaded: _adPreloader.rewardedLoaded,
                  failed: _adPreloader.rewardedFailed,
                  onWatch: () => _adPreloader.showRewarded(
                    onDismissed: _onAdWatched,
                    onRewardEarned: () {},
                  ),
                  onRetry: () => _adPreloader.retryAllFailed(),
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
              blastDirection: pi / 2,
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

// ── Stat card ─────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final int count;
  final String label;

  const _StatCard({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.accentBorderFaint),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Ad card ───────────────────────────────────────────────────────────────────

class _AdCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String description;
  final bool loaded;
  final bool failed;
  final VoidCallback onWatch;
  final VoidCallback? onRetry;
  final AppLocalizations l10n;

  const _AdCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.loaded,
    this.failed = false,
    required this.onWatch,
    this.onRetry,
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
            child: icon,
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
          if (loaded)
            ElevatedButton(
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
          else if (failed)
            GestureDetector(
              onTap: onRetry,
              child: const AppVectorIcon(AppVectors.refresh, color: AppColors.textSecondary, size: 20),
            )
          else
            const SizedBox(
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
