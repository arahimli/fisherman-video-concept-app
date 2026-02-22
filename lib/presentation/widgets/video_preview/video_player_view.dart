import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

import '../../../core/design/design_system.dart';

class VideoPlayerView extends StatelessWidget {
  final ChewieController? chewieController;
  final bool isCompleted;
  final VoidCallback onReplay;

  const VideoPlayerView({
    super.key,
    required this.chewieController,
    required this.isCompleted,
    required this.onReplay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: AppColors.accentBorder, width: 1),
          boxShadow: AppShadows.accentSubtle,
        ),
        child: ClipRRect(
          borderRadius: AppRadius.lgAll,
          child: _buildPlayer(),
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    final controller = chewieController;
    if (controller == null ||
        !controller.videoPlayerController.value.isInitialized) {
      return const ColoredBox(
        color: AppColors.surface,
        child: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Chewie(controller: controller),
        if (isCompleted) _ReplayOverlay(onTap: onReplay),
      ],
    );
  }
}

class _ReplayOverlay extends StatelessWidget {
  final VoidCallback onTap;

  const _ReplayOverlay({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const ColoredBox(
        color: Color(0x66000000),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.replay_rounded, color: Colors.white, size: 56),
              SizedBox(height: 8),
              Text(
                'Tap to replay',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
