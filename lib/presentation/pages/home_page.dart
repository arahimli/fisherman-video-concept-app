import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/design_system.dart';
import '../../core/router/app_routes.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../managers/recent_videos_bloc/bloc.dart';
import '../managers/video_bloc/bloc.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;
  late AnimationController _orbitController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 36),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  void _showResetSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.topXl),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceHighest,
                  borderRadius: AppRadius.xsAll,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.resetConfirmTitle, style: AppTextStyles.appBarTitle),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.resetConfirmMessage,
                style: AppTextStyles.dialogContent,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.accentBorder),
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                      ),
                      child: Text(l10n.no),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        context.read<VideoBloc>().add(ResetEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.background,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                      ),
                      child: Text(l10n.yes),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<VideoBloc, VideoState>(
          listener: (context, state) {
            if (state is VideoGeneratedState) {
              context.read<RecentVideosBloc>().add(LoadRecentVideosEvent());
            } else if (state is VideoErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: _buildAppBar(context, screenWidth, l10n),
        body: SafeArea(
          top: false,
          child: BlocBuilder<VideoBloc, VideoState>(
            builder: (context, state) {
              if (state is VideoLoadingState) {
                return _buildLoadingState(screenWidth, state.loadingMessage);
              }
              return _buildMainContent(context, screenWidth, screenHeight, state, l10n);
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    double screenWidth,
    AppLocalizations l10n,
  ) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text(l10n.appTitle, style: AppTextStyles.appBarTitle),
      centerTitle: true,
      actions: [
        BlocBuilder<VideoBloc, VideoState>(
          builder: (context, state) {
            if (state is ImagePickedState ||
                state is VideoGeneratedState ||
                state is VideoErrorState) {
              return IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.accent, size: 26),
                onPressed: () => _showResetSheet(context),
              );
            }
            return SizedBox();
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState(double screenWidth, String loadingMessage) {
    return Center(
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
          Text(loadingMessage, style: AppTextStyles.loadingMessage),
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
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    VideoState state,
    AppLocalizations l10n,
  ) {
    if (state is VideoGeneratedState) {
      return _buildVideoReadyMode(context, state.imageFile, state.videoPath, l10n);
    }
    if (state is ImagePickedState || state is VideoErrorState) {
      final imageFile = state is ImagePickedState
          ? state.imageFile
          : (state as VideoErrorState).imageFile;
      if (imageFile == null) return _buildCreateMode(context, screenWidth, screenHeight, l10n);
      return _buildImagePreviewMode(context, screenWidth, screenHeight, imageFile, l10n);
    }
    return _buildCreateMode(context, screenWidth, screenHeight, l10n);
  }

  Widget _buildCreateMode(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Center(
            child: AnimatedBuilder(
              animation: _orbitController,
              builder: (context, child) {
                return SizedBox(
                  width: screenWidth * 0.88,
                  height: screenWidth * 0.88,
                  child: CustomPaint(
                    painter: _SolarSystemPainter(_orbitController.value),
                    child: child,
                  ),
                );
              },
              child: Center(
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, _) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: GestureDetector(
                        onTap: () => context.read<VideoBloc>().add(PickImageEvent()),
                        child: Container(
                          width: screenWidth * 0.32,
                          height: screenWidth * 0.32,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(
                              BorderSide(color: AppColors.accent, width: 2),
                            ),
                            boxShadow: AppShadows.accentGlow,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: AppColors.accent,
                                size: screenWidth * 0.1,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(l10n.create, style: AppTextStyles.createLabel),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.image_outlined,
                  label: l10n.selectImage,
                  onTap: () => context.read<VideoBloc>().add(PickImageEvent()),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: _ActionButton(
                  icon: Icons.videocam_outlined,
                  label: l10n.generateVideo,
                  isAccent: true,
                  onTap: null,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Expanded(flex: 4, child: RecentVideosWidget()),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  Widget _buildImagePreviewMode(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    File imageFile,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: AppRadius.lgAll,
                border: Border.all(color: AppColors.accentBorder, width: 2),
                boxShadow: AppShadows.accentSubtle,
              ),
              child: ClipRRect(
                borderRadius: AppRadius.lgAll,
                child: Image.file(imageFile, width: double.infinity, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.image_outlined,
                  label: l10n.changeImage,
                  onTap: () => context.read<VideoBloc>().add(PickImageEvent()),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: _ActionButton(
                  icon: Icons.videocam_outlined,
                  label: l10n.generateVideo,
                  isAccent: true,
                  onTap: () => context.read<VideoBloc>().add(
                        GenerateVideoEvent(
                          processingMessage: l10n.imageProcessing,
                          generatingMessage: l10n.videoGenerating,
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Expanded(flex: 3, child: RecentVideosWidget()),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  Widget _buildVideoReadyMode(
    BuildContext context,
    File imageFile,
    String videoPath,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        // ── Image with play overlay ────────────────────────────────────────
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg,
            ),
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.videoPreview, extra: videoPath),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: AppRadius.lgAll,
                  border: Border.all(color: AppColors.accentBorder, width: 2),
                  boxShadow: AppShadows.accentSubtle,
                ),
                child: ClipRRect(
                  borderRadius: AppRadius.lgAll,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(imageFile, fit: BoxFit.cover),
                      // Dimmed overlay
                      const ColoredBox(color: Color(0x55000000)),
                      // Play button
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: AppShadows.accentGlow,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: AppColors.background,
                            size: 48,
                          ),
                        ),
                      ),
                      // Video ready badge
                      Positioned(
                        top: AppSpacing.md,
                        right: AppSpacing.md,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: AppRadius.pillAll,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_outline,
                                  color: AppColors.background, size: 13),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                l10n.videoReady,
                                style: const TextStyle(
                                  color: AppColors.background,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Preview button ────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.videoPreview, extra: videoPath),
              icon: const Icon(Icons.play_circle_outline, size: 20),
              label: Text(l10n.previewVideo, style: AppTextStyles.previewButtonLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                elevation: 0,
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // ── Change image + Home ───────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.read<VideoBloc>().add(PickImageEvent()),
                  icon: const Icon(Icons.image_outlined, size: 18),
                  label: Text(l10n.changeImage.replaceAll('\n', ' ')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.accentBorder),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.read<VideoBloc>().add(ResetEvent()),
                  icon: const Icon(Icons.home_outlined, size: 18),
                  label: const Text('Home'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.accentBorder),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

// ── Recent Videos ────────────────────────────────────────────────────────────

class RecentVideosWidget extends StatelessWidget {
  const RecentVideosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<RecentVideosBloc, RecentVideosState>(
      builder: (context, state) {
        if (state is RecentVideosLoaded) {
          if (state.videos.isEmpty) {
            return _buildEmpty(l10n);
          }
          return _buildList(context, state.videos, screenWidth, l10n);
        }
        return _buildLoading(l10n);
      },
    );
  }

  Widget _buildEmpty(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Text(l10n.recentVideos, style: AppTextStyles.sectionLabel),
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(child: Text(l10n.noVideos, style: AppTextStyles.noContentText)),
      ],
    );
  }

  Widget _buildList(
    BuildContext context,
    List<VideoHistoryData> videos,
    double screenWidth,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.recentVideos, style: AppTextStyles.sectionLabel),
              TextButton(
                onPressed: () => context.push(AppRoutes.history),
                child: Text(l10n.viewAll, style: AppTextStyles.sectionAction),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < videos.length - 1 ? AppSpacing.lg : 0,
                ),
                child: _RecentVideoItem(
                  video: video,
                  screenWidth: screenWidth,
                  onTap: () => context.push(AppRoutes.videoPreview, extra: video.videoPath),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoading(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Text(l10n.recentVideos, style: AppTextStyles.sectionLabel),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      ],
    );
  }
}

// ── Action Button ─────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isAccent;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.isAccent = false,
    required this.onTap,
  });

  bool get _isDisabled => onTap == null;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isDisabled ? 0.38 : 1.0,
      child: Material(
        color: isAccent ? AppColors.accentStrong : AppColors.surface,
        borderRadius: AppRadius.mdAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdAll,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isAccent ? AppColors.surface : AppColors.accent,
                  size: 26,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.actionButton.copyWith(
                    color: isAccent ? AppColors.surface : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Recent Video Item ─────────────────────────────────────────────────────────

class _RecentVideoItem extends StatelessWidget {
  final VideoHistoryData video;
  final double screenWidth;
  final VoidCallback onTap;

  const _RecentVideoItem({
    required this.video,
    required this.screenWidth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.35,
        decoration: const BoxDecoration(
          borderRadius: AppRadius.lgAll,
          border: Border.fromBorderSide(
            BorderSide(color: AppColors.accentBorderLight, width: 1),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.surfaceElevated, AppColors.surface],
          ),
        ),
        child: Stack(
          children: [
            if (video.imagePath != null)
              ClipRRect(
                borderRadius: AppRadius.lgAll,
                child: Image.file(
                  File(video.imagePath!),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.overlayDark,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  child: Icon(Icons.play_arrow, color: AppColors.textPrimary, size: 26),
                ),
              ),
            ),
            Positioned(
              bottom: AppSpacing.sm,
              left: AppSpacing.sm,
              right: AppSpacing.sm,
              child: ClipRRect(
                borderRadius: AppRadius.smAll,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.overlayMedium,
                      borderRadius: AppRadius.smAll,
                    ),
                    child: Text(
                      video.title,
                      style: AppTextStyles.recentVideoTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Solar System ──────────────────────────────────────────────────────────────

class _Planet {
  final double angleOffset;
  final double radius;
  final Color color;
  final bool glowing;

  const _Planet({
    required this.angleOffset,
    required this.radius,
    required this.color,
    this.glowing = false,
  });
}

class _SolarSystemPainter extends CustomPainter {
  final double progress;

  _SolarSystemPainter(this.progress);

  static const _tau = 2 * pi;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final w = size.width;

    // ── Ring 1 — inner, 3 full rotations/cycle, clockwise ───────────────────
    _drawRing(
      canvas, center,
      radius: w * 0.20,
      baseAngle: progress * _tau * 3,
      strokeWidth: 0.8,
      ringColor: const Color(0x4DB8956A),
      planets: const [
        _Planet(angleOffset: 0,          radius: 3.5, color: Color(0xFFB8956A), glowing: true),
      ],
    );

    // ── Ring 2 — middle, 2 full rotations/cycle, counter-clockwise ──────────
    _drawRing(
      canvas, center,
      radius: w * 0.31,
      baseAngle: -progress * _tau * 2,
      strokeWidth: 0.6,
      ringColor: const Color(0x33B8956A),
      planets: const [
        _Planet(angleOffset: 0,             radius: 2.8, color: Color(0x99FFFFFF)),
        _Planet(angleOffset: pi * 0.75,     radius: 3.2, color: Color(0x99B8956A)),
      ],
    );

    // ── Ring 3 — outer, 1 full rotation/cycle, clockwise ────────────────────
    _drawRing(
      canvas, center,
      radius: w * 0.43,
      baseAngle: progress * _tau * 1,
      strokeWidth: 0.5,
      ringColor: const Color(0x26B8956A),
      planets: const [
        _Planet(angleOffset: 0,             radius: 2.2, color: Color(0x66FFFFFF)),
        _Planet(angleOffset: pi * 1.3,      radius: 2.6, color: Color(0x55B8956A)),
        _Planet(angleOffset: pi * 0.45,     radius: 1.8, color: Color(0x44FFFFFF)),
      ],
    );
  }

  void _drawRing(
    Canvas canvas,
    Offset center, {
    required double radius,
    required double baseAngle,
    required double strokeWidth,
    required Color ringColor,
    required List<_Planet> planets,
  }) {
    // Ring circle
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = ringColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Planets
    for (final planet in planets) {
      final angle = baseAngle + planet.angleOffset;
      final pos = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      if (planet.glowing) {
        canvas.drawCircle(
          pos,
          planet.radius + 3.5,
          Paint()
            ..color = planet.color.withAlpha(50)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
        );
      }

      canvas.drawCircle(
        pos,
        planet.radius,
        Paint()
          ..color = planet.color
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_SolarSystemPainter old) => old.progress != progress;
}
