import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/design/design_system.dart';

class LoadingStateWidget extends StatefulWidget {
  final String loadingMessage;

  const LoadingStateWidget({super.key, required this.loadingMessage});

  @override
  State<LoadingStateWidget> createState() => _LoadingStateWidgetState();
}

class _LoadingStateWidgetState extends State<LoadingStateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;

  BannerAd? _topBannerAd;
  BannerAd? _bottomBannerAd;
  bool _topBannerLoaded = false;
  bool _bottomBannerLoaded = false;

  static final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _loadBanners();
  }

  void _loadBanners() {
    _topBannerAd = BannerAd(
      adUnitId: _adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _topBannerLoaded = true),
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    )..load();

    _bottomBannerAd = BannerAd(
      adUnitId: _adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _bottomBannerLoaded = true),
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    )..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    _topBannerAd?.dispose();
    _bottomBannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        if (_topBannerLoaded && _topBannerAd != null)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.md,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
            ),
            child: SizedBox(
              width: _topBannerAd!.size.width.toDouble(),
              height: _topBannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _topBannerAd!),
            ),
          ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _rotateAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotateAnimation.value * 2 * 3.14159,
                          child: Container(
                            width: screenWidth * 0.3,
                            height: screenWidth * 0.3,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.accent, width: 3),
                              gradient: const LinearGradient(
                                colors: [AppColors.accent, AppColors.accentOverlay],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      width: screenWidth * 0.2,
                      height: screenWidth * 0.2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.background,
                        border: Border.all(color: AppColors.accentBorder, width: 2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxxl),
                Text(widget.loadingMessage, style: AppTextStyles.loadingMessage),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: screenWidth * 0.5,
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_bottomBannerLoaded && _bottomBannerAd != null)
          Padding(
            padding: const EdgeInsets.only(
              bottom: AppSpacing.md,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
            ),
            child: SizedBox(
              width: _bottomBannerAd!.size.width.toDouble(),
              height: _bottomBannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bottomBannerAd!),
            ),
          ),
      ],
    );
  }
}
