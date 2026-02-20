import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
      body: Column(
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
    );
  }

  // ── Filter chips ────────────────────────────────────────────────────────────

  Widget _buildFilterChips(AppLocalizations l10n) {
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.sm,
        ),
        children: [
          _FilterChip(label: l10n.allDates,  value: 'all',       selected: _selectedFilter, onTap: _applyFilter),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(label: l10n.today,     value: 'today',     selected: _selectedFilter, onTap: _applyFilter),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(label: l10n.yesterday, value: 'yesterday', selected: _selectedFilter, onTap: _applyFilter),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(label: l10n.thisWeek,  value: 'week',      selected: _selectedFilter, onTap: _applyFilter),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(label: l10n.thisMonth, value: 'month',     selected: _selectedFilter, onTap: _applyFilter),
        ],
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
        return _VideoCard(
          video: state.videos[index],
          onTap: () => context.push(AppRoutes.videoPreview, extra: state.videos[index].videoPath),
          onLongPress: () => _deleteVideo(context, state.videos[index].id),
        );
      },
    );
  }
}

// ── Filter Chip ───────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final String selected;
  final void Function(String) onTap;

  const _FilterChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.surface,
          borderRadius: AppRadius.pillAll,
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.accentBorder,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.filterChip.copyWith(
            color: isSelected ? AppColors.background : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

// ── Video Card ────────────────────────────────────────────────────────────────

class _VideoCard extends StatelessWidget {
  final VideoHistoryData video;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _VideoCard({
    required this.video,
    required this.onTap,
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
            Expanded(child: _buildThumbnail()),
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
