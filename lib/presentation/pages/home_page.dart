import 'dart:io';
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
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showResetDialog(BuildContext context, List<Widget> actions) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(l10n.resetConfirmTitle, style: AppTextStyles.dialogTitle),
        content: Text(l10n.resetConfirmMessage, style: AppTextStyles.dialogContent),
        actions: actions,
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.videoGenerated),
                  backgroundColor: AppColors.accent,
                ),
              );
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
        body: BlocBuilder<VideoBloc, VideoState>(
          builder: (context, state) {
            if (state is VideoLoadingState) {
              return _buildLoadingState(screenWidth, state.loadingMessage);
            }
            return _buildMainContent(context, screenWidth, screenHeight, state, l10n);
          },
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
                onPressed: () => _showResetDialog(context, [
                  IconButton(
                    icon: const Icon(Icons.history, color: AppColors.accent, size: 26),
                    onPressed: () => context.push(AppRoutes.history),
                  ),
                  BlocBuilder<VideoBloc, VideoState>(
                    builder: (context, state) {
                      if (state is ImagePickedState ||
                          state is VideoGeneratedState ||
                          state is VideoErrorState) {
                        return IconButton(
                          icon: const Icon(Icons.refresh, color: AppColors.accent, size: 26),
                          onPressed: () {},
                        );
                      }
                      return IconButton(
                        icon: const Icon(
                          Icons.account_circle_outlined,
                          color: AppColors.textPrimary,
                          size: 26,
                        ),
                        onPressed: () {},
                      );
                    },
                  ),
                ]),
              );
            }
            return IconButton(
              icon: const Icon(
                Icons.account_circle_outlined,
                color: AppColors.textPrimary,
                size: 26,
              ),
              onPressed: () {},
            );
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
    if (state is ImagePickedState ||
        state is VideoGeneratedState ||
        state is VideoErrorState) {
      File? imageFile;
      String? videoPath;

      if (state is ImagePickedState) {
        imageFile = state.imageFile;
      } else if (state is VideoGeneratedState) {
        imageFile = state.imageFile;
        videoPath = state.videoPath;
      } else if (state is VideoErrorState) {
        imageFile = state.imageFile;
      }

      return _buildImagePreviewMode(
        context, screenWidth, screenHeight, imageFile!, videoPath, l10n,
      );
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
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: screenWidth * 0.55,
                        height: screenWidth * 0.55,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(
                            BorderSide(color: AppColors.accentBorderFaint, width: 1),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  width: screenWidth * 0.43,
                  height: screenWidth * 0.43,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(color: AppColors.accentBorderLight, width: 1),
                    ),
                  ),
                ),
                GestureDetector(
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
                Positioned(
                  top: 0,
                  right: screenWidth * 0.22,
                  child: Container(
                    width: screenWidth * 0.015,
                    height: screenWidth * 0.015,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: screenHeight * 0.03,
                  left: screenWidth * 0.2,
                  child: Container(
                    width: screenWidth * 0.012,
                    height: screenWidth * 0.012,
                    decoration: const BoxDecoration(
                      color: AppColors.textSubtle,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
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
    String? videoPath,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        Expanded(
          flex: videoPath != null ? 4 : 5,
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
        Expanded(
          flex: 3,
          child: videoPath != null
              ? _buildVideoReadySection(context, videoPath, l10n)
              : const RecentVideosWidget(),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  Widget _buildVideoReadySection(
    BuildContext context,
    String videoPath,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: AppColors.accentBorder, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: AppColors.background, size: 24),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.videoReady, style: AppTextStyles.videoReadyTitle),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push(AppRoutes.videoPreview, extra: videoPath),
                icon: const Icon(Icons.play_circle_outline, size: 22),
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
          ],
        ),
      ),
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
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.isAccent = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
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
