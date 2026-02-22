import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/design_system.dart';
import '../../core/router/app_routes.dart';
import '../../l10n/app_localizations.dart';
import '../managers/recent_videos_bloc/bloc.dart';
import '../managers/video_bloc/bloc.dart';
import '../widgets/home/create_mode_widget.dart';
import '../widgets/home/home_sheets.dart';
import '../widgets/home/image_preview_mode_widget.dart';
import '../widgets/home/loading_state_widget.dart';
import '../widgets/home/video_ready_mode_widget.dart';

class NewHomePage extends StatelessWidget {
  const NewHomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
        appBar: _HomeAppBar(l10n: l10n),
        body: SafeArea(
          top: false,
          child: BlocBuilder<VideoBloc, VideoState>(
            builder: (context, state) {
              if (state is VideoLoadingState) {
                return LoadingStateWidget(loadingMessage: state.loadingMessage);
              }
              if (state is VideoGeneratedState) {
                return VideoReadyModeWidget(
                  imageFile: state.imageFile,
                  videoPath: state.videoPath,
                );
              }
              if (state is ImagePickedState || state is VideoErrorState) {
                final File? imageFile = state is ImagePickedState
                    ? state.imageFile
                    : (state as VideoErrorState).imageFile;
                if (imageFile != null) {
                  return ImagePreviewModeWidget(imageFile: imageFile);
                }
              }
              return const CreateModeWidget();
            },
          ),
        ),
      ),
    );
  }
}

// ── AppBar ─────────────────────────────────────────────────────────────────────

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppLocalizations l10n;

  const _HomeAppBar({required this.l10n});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text(l10n.appTitle, style: AppTextStyles.appBarTitle),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.tune, color: AppColors.textTertiary, size: 22),
          onPressed: () => context.push(AppRoutes.settings),
        ),
        BlocBuilder<VideoBloc, VideoState>(
          builder: (context, state) {
            if (state is ImagePickedState ||
                state is VideoGeneratedState ||
                state is VideoErrorState) {
              return IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.accent, size: 26),
                onPressed: () => showResetConfirmSheet(context),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
