// pages/history_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });

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

    context.read<HistoryBloc>().add(FilterByDateEvent(
      startDate: startDate,
      endDate: endDate,
    ));
  }

  void _deleteVideo(BuildContext context, int videoId) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(
          l10n.deleteVideo,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          l10n.deleteConfirm,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<HistoryBloc>().add(DeleteVideoEvent(videoId));
            },
            child: Text(
              l10n.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        title: Text(
          l10n.history,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontStyle: FontStyle.italic,
            letterSpacing: 2,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildFilterChips(screenWidth, l10n),
          Expanded(
            child: BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                if (state is HistoryLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFB8956A),
                    ),
                  );
                } else if (state is HistoryLoaded) {
                  if (state.videos.isEmpty) {
                    return _buildEmptyState(screenWidth, l10n);
                  }
                  return _buildVideoGrid(context, state, screenWidth);
                } else if (state is HistoryError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
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

  Widget _buildFilterChips(double screenWidth, AppLocalizations? l10n) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        children: [
          _buildFilterChip(l10n?.allDates ?? 'All', 'all', screenWidth),
          SizedBox(width: 8),
          _buildFilterChip(l10n?.today ?? 'Today', 'today', screenWidth),
          SizedBox(width: 8),
          _buildFilterChip(l10n?.yesterday ?? 'Yesterday', 'yesterday', screenWidth),
          SizedBox(width: 8),
          _buildFilterChip(l10n?.thisWeek ?? 'This Week', 'week', screenWidth),
          SizedBox(width: 8),
          _buildFilterChip(l10n?.thisMonth ?? 'This Month', 'month', screenWidth),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, double screenWidth) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => _applyFilter(value),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB8956A) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFB8956A)
                : const Color(0xFFB8956A).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0A0A0A) : Colors.white,
            fontSize: screenWidth * 0.032,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(double screenWidth, AppLocalizations? l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: screenWidth * 0.2,
            color: Colors.white24,
          ),
          SizedBox(height: 20),
          Text(
            l10n?.noVideos ?? 'No videos yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 10),
          Text(
            l10n?.noVideosDesc ?? 'Create your first video to see it here',
            style: TextStyle(
              color: Colors.white54,
              fontSize: screenWidth * 0.035,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoGrid(
      BuildContext context,
      HistoryLoaded state,
      double screenWidth,
      ) {
    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(screenWidth * 0.04),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: screenWidth * 0.04,
        mainAxisSpacing: screenWidth * 0.04,
        childAspectRatio: 0.75,
      ),
      itemCount: state.videos.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.videos.length) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFB8956A),
            ),
          );
        }

        final video = state.videos[index];
        return _buildVideoCard(context, video, screenWidth);
      },
    );
  }

  Widget _buildVideoCard(
      BuildContext context,
      VideoHistoryData video,
      double screenWidth,
      ) {
    return GestureDetector(
      onTap: () {
        context.push('/video-preview', extra: video.videoPath);
      },
      onLongPress: () => _deleteVideo(context, video.id),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          border: Border.all(
            color: const Color(0xFFB8956A).withOpacity(0.3),
            width: 1,
          ),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video thumbnail placeholder
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenWidth * 0.04),
                    topRight: Radius.circular(screenWidth * 0.04),
                  ),
                  color: const Color(0xFF3A3A3A),
                ),
                child: video.imagePath != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenWidth * 0.04),
                    topRight: Radius.circular(screenWidth * 0.04),
                  ),
                  child: Image.file(
                    File(video.imagePath!),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                )
                    : Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    size: screenWidth * 0.12,
                    color: const Color(0xFFB8956A),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.032,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd, yyyy • HH:mm').format(video.createdAt),
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: screenWidth * 0.028,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}