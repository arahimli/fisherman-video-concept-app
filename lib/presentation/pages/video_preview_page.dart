import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../core/design/design_system.dart';
import '../../l10n/app_localizations.dart';

class VideoPreviewScreen extends StatefulWidget {
  final String videoPath;

  const VideoPreviewScreen({super.key, required this.videoPath});

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.videoPath));
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.accent,
        handleColor: AppColors.accent,
        backgroundColor: AppColors.surfaceHighest,
        bufferedColor: AppColors.accentBorderLight,
      ),
      placeholder: const ColoredBox(
        color: AppColors.background,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      ),
      autoInitialize: true,
      allowFullScreen: true,
      allowMuting: true,
      errorBuilder: (context, errorMessage) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: AppSpacing.lg),
            Text(
              errorMessage,
              style: const TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    setState(() {});
  }

  Future<void> _saveToGallery() async {
    setState(() => _isSaving = true);

    try {
      final result = await SaverGallery.saveFile(
        filePath: widget.videoPath,
        fileName: 'fisherman_video_${DateTime.now().millisecondsSinceEpoch}',
        skipIfExists: true,
      );

      setState(() => _isSaving = false);
      if (!mounted) return;

      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.isSuccess
                ? l10n.videoSavedSuccess
                : l10n.error(result.errorMessage ?? ''),
          ),
          backgroundColor: result.isSuccess ? AppColors.accent : AppColors.error,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.error(e)), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _shareVideo() async {
    final l10n = AppLocalizations.of(context);
    try {
      await Share.shareXFiles([XFile(widget.videoPath)], text: l10n.shareVideoText);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.shareError(e)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showShareOptions() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.topXl),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceHighest,
                  borderRadius: AppRadius.xsAll,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.shareSheet, style: AppTextStyles.appBarTitle),
              const SizedBox(height: AppSpacing.xl),

              // Save to gallery
              _SheetTile(
                icon: Icons.save_alt_outlined,
                title: l10n.saveToGallery,
                subtitle: l10n.saveToGalleryDesc,
                onTap: () {
                  Navigator.pop(context);
                  _saveToGallery();
                },
              ),

              Divider(color: AppColors.surfaceElevated, height: AppSpacing.xl),

              // Share
              _SheetTile(
                icon: Icons.send_outlined,
                title: l10n.share,
                subtitle: l10n.shareSubtitle,
                onTap: () {
                  Navigator.pop(context);
                  _shareVideo();
                },
              ),

              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
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
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.videoPreviewTitle, style: AppTextStyles.appBarTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_outlined, color: AppColors.accent, size: 24),
            onPressed: _showShareOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Video player ────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: AppRadius.lgAll,
                  border: Border.all(color: AppColors.accentBorder, width: 1),
                  boxShadow: AppShadows.accentSubtle,
                ),
                child: ClipRRect(
                  borderRadius: AppRadius.lgAll,
                  child: _chewieController != null &&
                          _chewieController!.videoPlayerController.value.isInitialized
                      ? Chewie(controller: _chewieController!)
                      : const ColoredBox(
                          color: AppColors.surface,
                          child: Center(
                            child: CircularProgressIndicator(color: AppColors.accent),
                          ),
                        ),
                ),
              ),
            ),
          ),

          // ── Action bar ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.md,
              AppSpacing.xl,
              AppSpacing.xl,
            ),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(
                top: BorderSide(color: AppColors.accentBorderFaint, width: 1),
              ),
            ),
            child: Row(
              children: [
                // Save — accent primary button
                Expanded(
                  child: _PreviewActionButton(
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.background,
                            ),
                          )
                        : const Icon(Icons.save_alt_outlined, size: 20),
                    label: _isSaving ? l10n.saving : l10n.save,
                    isAccent: true,
                    onTap: _isSaving ? null : _saveToGallery,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Share — secondary button
                Expanded(
                  child: _PreviewActionButton(
                    icon: const Icon(Icons.send_outlined, size: 20),
                    label: l10n.share,
                    isAccent: false,
                    onTap: _shareVideo,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Action Button ─────────────────────────────────────────────────────────────

class _PreviewActionButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool isAccent;
  final VoidCallback? onTap;

  const _PreviewActionButton({
    required this.icon,
    required this.label,
    required this.isAccent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isAccent ? AppColors.accent : AppColors.surface,
      borderRadius: AppRadius.mdAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdAll,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          decoration: isAccent
              ? null
              : BoxDecoration(
                  borderRadius: AppRadius.mdAll,
                  border: Border.all(color: AppColors.accentBorder, width: 1),
                ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(
                  color: isAccent ? AppColors.background : AppColors.accent,
                  size: 20,
                ),
                child: icon,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: AppTextStyles.actionButton.copyWith(
                  color: isAccent ? AppColors.background : AppColors.accent,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sheet Tile ────────────────────────────────────────────────────────────────

class _SheetTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SheetTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: const BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: AppRadius.smAll,
        ),
        child: Icon(icon, color: AppColors.accent, size: 22),
      ),
      title: Text(title, style: AppTextStyles.historyCardTitle),
      subtitle: Text(subtitle, style: AppTextStyles.historyCardDate),
      onTap: onTap,
    );
  }
}
