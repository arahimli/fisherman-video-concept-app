import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/design/design_system.dart';
import '../../core/router/app_routes.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../managers/history_bloc/bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<HistoryBloc>().add(LoadHistoryEvent(loadMore: true));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    return _scrollController.offset >= maxScroll * 0.9;
  }

  void _applyFilter(String filter) {
    setState(() => _selectedFilter = filter);

    DateTime? startDate;
    DateTime? endDate = DateTime.now();

    switch (filter) {
      case 'today':
        startDate = DateTime(endDate.year, endDate.month, endDate.day);
        break;
      case 'yesterday':
        final yesterday = endDate.subtract(const Duration(days: 1));
        startDate = DateTime(yesterday.year, yesterday.month, yesterday.day);
        endDate = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
        break;
      case 'week':
        startDate = endDate.subtract(const Duration(days: 7));
        break;
      case 'month':
        startDate = DateTime(endDate.year, endDate.month, 1);
        break;
      default:
        startDate = null;
        endDate = null;
    }

    context.read<HistoryBloc>().add(
      FilterByDateEvent(startDate: startDate, endDate: endDate),
    );
  }

  void _showVideoOptions(BuildContext context, VideoHistoryData video) {
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

              // Share
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: AppRadius.smAll,
                  ),
                  child: const Icon(Icons.send_outlined, color: AppColors.accent, size: 22),
                ),
                title: Text(l10n.share, style: AppTextStyles.historyCardTitle),
                subtitle: Text(l10n.shareSubtitle, style: AppTextStyles.historyCardDate),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  try {
                    await Share.shareXFiles(
                      [XFile(video.videoPath)],
                      text: l10n.shareVideoText,
                    );
                  } catch (_) {}
                },
              ),

              Divider(color: AppColors.surfaceElevated, height: AppSpacing.xl),

              // Save
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: AppRadius.smAll,
                  ),
                  child: const Icon(Icons.save_alt_outlined, color: AppColors.accent, size: 22),
                ),
                title: Text(l10n.saveToGallery, style: AppTextStyles.historyCardTitle),
                subtitle: Text(l10n.saveToGalleryDesc, style: AppTextStyles.historyCardDate),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  final result = await SaverGallery.saveFile(
                    filePath: video.videoPath,
                    fileName: 'fisherman_video_${DateTime.now().millisecondsSinceEpoch}',
                    skipIfExists: true,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result.isSuccess
                              ? l10n.videoSavedSuccess
                              : l10n.error(result.errorMessage ?? ''),
                        ),
                        backgroundColor: result.isSuccess ? AppColors.accent : AppColors.error,
                      ),
                    );
                  }
                },
              ),

              Divider(color: AppColors.surfaceElevated, height: AppSpacing.xl),

              // Delete
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.12),
                    borderRadius: AppRadius.smAll,
                  ),
                  child: const Icon(Icons.delete_outline, color: AppColors.error, size: 22),
                ),
                title: Text(l10n.deleteVideo, style: AppTextStyles.historyCardTitle.copyWith(color: AppColors.error)),
                subtitle: Text(l10n.deleteConfirm, style: AppTextStyles.historyCardDate),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _deleteVideo(context, video.id);
                },
              ),

              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteVideo(BuildContext context, int videoId) {
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
              Text(l10n.deleteVideo, style: AppTextStyles.appBarTitle),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.deleteConfirm,
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
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        context.read<HistoryBloc>().add(DeleteVideoEvent(videoId));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                      ),
                      child: Text(l10n.delete),
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
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(l10n.history, style: AppTextStyles.appBarTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildFilterChips(l10n),
            Expanded(
              child: BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  if (state is HistoryLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    );
                  }
                  if (state is HistoryLoaded) {
                    if (state.videos.isEmpty) return _buildEmptyState(l10n);
                    return _buildVideoGrid(context, state);
                  }
                  if (state is HistoryError) {
                    return Center(
                      child: Text(state.message, style: const TextStyle(color: AppColors.error)),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Filter chips ────────────────────────────────────────────────────────────

  Widget _buildFilterChips(AppLocalizations l10n) {
    final filters = [
      (label: l10n.allDates,  value: 'all'),
      (label: l10n.today,     value: 'today'),
      (label: l10n.yesterday, value: 'yesterday'),
      (label: l10n.thisWeek,  value: 'week'),
      (label: l10n.thisMonth, value: 'month'),
    ];
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final isSelected = _selectedFilter == filters[i].value;
          return ChoiceChip(
            label: Text(filters[i].label),
            selected: isSelected,
            onSelected: (_) => _applyFilter(filters[i].value),
            labelStyle: AppTextStyles.filterChip.copyWith(
              color: isSelected ? AppColors.background : AppColors.textPrimary,
            ),
            selectedColor: AppColors.accent,
            backgroundColor: AppColors.surface,
            side: BorderSide(
              color: isSelected ? AppColors.accent : AppColors.accentBorder,
              width: 1,
            ),
            shape: const StadiumBorder(),
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 2),
          );
        },
      ),
    );
  }

  // ── Empty state ─────────────────────────────────────────────────────────────

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.video_library_outlined, size: 72, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.xl),
          Text(l10n.noVideos, style: AppTextStyles.emptyStateTitle),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.noVideosDesc, style: AppTextStyles.emptyStateBody),
        ],
      ),
    );
  }

  // ── Grid ────────────────────────────────────────────────────────────────────

  Widget _buildVideoGrid(BuildContext context, HistoryLoaded state) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: 0.75,
      ),
      itemCount: state.videos.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.videos.length) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          );
        }
        final video = state.videos[index];
        return _VideoCard(
          video: video,
          onTap: () => context.push(AppRoutes.videoPreview, extra: video.videoPath),
          onDelete: () => _deleteVideo(context, video.id),
          onLongPress: () => _showVideoOptions(context, video),
        );
      },
    );
  }
}


// ── Video Card ────────────────────────────────────────────────────────────────

class _VideoCard extends StatelessWidget {
  final VideoHistoryData video;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onLongPress;

  const _VideoCard({
    required this.video,
    required this.onTap,
    required this.onDelete,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: AppRadius.lgAll,
          border: Border.fromBorderSide(
            BorderSide(color: AppColors.accentBorder, width: 1),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.surfaceElevated, AppColors.surface],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  _buildThumbnail(),
                  Positioned(
                    top: AppSpacing.xs,
                    right: AppSpacing.xs,
                    child: GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        decoration: const BoxDecoration(
                          color: AppColors.overlayDark,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: AppColors.textPrimary,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: AppTextStyles.historyCardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    DateFormat('MMM dd, yyyy • HH:mm').format(video.createdAt),
                    style: AppTextStyles.historyCardDate,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (video.imagePath != null) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        child: Image.file(
          File(video.imagePath!),
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceHighest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: const Center(
        child: Icon(Icons.play_circle_outline, size: 48, color: AppColors.accent),
      ),
    );
  }
}
