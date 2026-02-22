import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/design_system.dart';
import '../../core/router/app_routes.dart';
import '../../l10n/app_localizations.dart';
import '../managers/history_bloc/bloc.dart';
import '../widgets/history/history_empty_state.dart';
import '../widgets/history/history_filter_chips.dart';
import '../widgets/history/history_sheets.dart';
import '../widgets/history/history_video_card.dart';

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
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (_scrollController.offset >= maxScroll * 0.9) {
      context.read<HistoryBloc>().add(LoadHistoryEvent(loadMore: true));
    }
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
        final y = endDate.subtract(const Duration(days: 1));
        startDate = DateTime(y.year, y.month, y.day);
        endDate = DateTime(y.year, y.month, y.day, 23, 59, 59);
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
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            HistoryFilterChips(
              selectedFilter: _selectedFilter,
              onFilterChanged: _applyFilter,
            ),
            Expanded(
              child: BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  if (state is HistoryLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    );
                  }
                  if (state is HistoryLoaded) {
                    if (state.videos.isEmpty) return const HistoryEmptyState();
                    return _buildGrid(context, state);
                  }
                  if (state is HistoryError) {
                    return Center(
                      child: Text(state.message,
                          style: const TextStyle(color: AppColors.error)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, HistoryLoaded state) {
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
        return HistoryVideoCard(
          video: video,
          onTap: () => context.push(AppRoutes.videoPreview, extra: video.videoPath),
          onDelete: () => showDeleteConfirmSheet(context, video.id),
          onLongPress: () => showVideoOptionsSheet(context, video),
        );
      },
    );
  }
}
