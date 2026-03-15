import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design/design_system.dart';
import '../../../core/router/app_routes.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/app_localizations_extension.dart';
import '../../managers/recent_videos_bloc/bloc.dart';
import '../history/history_sheets.dart';
import 'recent_video_item.dart';

class RecentVideosWidget extends StatelessWidget {
  const RecentVideosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final l10n = context.l10n;

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
                child: RecentVideoItem(
                  video: video,
                  screenWidth: screenWidth,
                  onTap: () => context.push(AppRoutes.videoPreview, extra: video.videoPath),
                  onLongPress: () => showVideoOptionsSheet(context, video),
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
