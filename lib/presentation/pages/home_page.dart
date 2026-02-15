// lib/new_home_page.dart
import 'dart:io';
import 'dart:ui';
import 'package:fisherman_video/presentation/pages/video_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_localizations.dart';
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

  void _showResetDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(
          l10n.resetConfirmTitle,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          l10n.resetConfirmMessage,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.no,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<VideoBloc>().add(ResetEvent());
            },
            child: Text(
              l10n.yes,
              style: const TextStyle(color: Color(0xFFB8956A)),
            ),
          ),
        ],
      ),
    );
  }

  void _showVideoPreview(BuildContext context, String videoPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(videoPath: videoPath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context);

    return BlocListener<VideoBloc, VideoState>(
      listener: (context, state) {
        if (state is VideoGeneratedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.videoGenerated),
              backgroundColor: const Color(0xFFB8956A),
            ),
          );
        } else if (state is VideoErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(context, screenWidth, l10n),
        body: BlocBuilder<VideoBloc, VideoState>(
          builder: (context, state) {
            if (state is VideoLoadingState) {
              return _buildLoadingState(
                screenWidth,
                screenHeight,
                state.loadingMessage,
              );
            }
            return _buildMainContent(
                context, screenWidth, screenHeight, state, l10n);
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
      backgroundColor: const Color(0xFF0A0A0A),
      elevation: 0,

      title: Text(
        l10n.appTitle,
        style: TextStyle(
          fontSize: screenWidth * 0.045,
          fontStyle: FontStyle.italic,
          letterSpacing: 2,
          color: Colors.white,
          fontWeight: FontWeight.w300,
        ),
      ),
      centerTitle: true,
      actions: [
        BlocBuilder<VideoBloc, VideoState>(
          builder: (context, state) {
            if (state is ImagePickedState ||
                state is VideoGeneratedState ||
                state is VideoErrorState) {
              return IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: const Color(0xFFB8956A),
                  size: screenWidth * 0.065,
                ),
                onPressed: () => _showResetDialog(context),
              );
            }
            return IconButton(
              icon: Icon(
                Icons.account_circle_outlined,
                color: Colors.white,
                size: screenWidth * 0.065,
              ),
              onPressed: () {},
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState(
      double screenWidth,
      double screenHeight,
      String loadingMessage,
      ) {
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
                        border: Border.all(
                          color: const Color(0xFFB8956A),
                          width: 3,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFB8956A),
                            const Color(0xFFB8956A).withOpacity(0.1),
                          ],
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
                  color: const Color(0xFF0A0A0A),
                  border: Border.all(
                    color: const Color(0xFFB8956A).withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.04),
          Text(
            loadingMessage,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.white70,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          SizedBox(
            width: screenWidth * 0.5,
            child: const LinearProgressIndicator(
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB8956A)),
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

      if(imageFile == null) {
        return _buildCreateMode(context, screenWidth, screenHeight, l10n);
      }
      return _buildImagePreviewMode(
        context,
        screenWidth,
        screenHeight,
        imageFile!,
        videoPath,
        l10n,
      );
    } else {
      return _buildCreateMode(context, screenWidth, screenHeight, l10n);
    }
  }

  Widget _buildCreateMode(
      BuildContext context,
      double screenWidth,
      double screenHeight,
      AppLocalizations l10n,
      ) {
    return Column(
      children: [
        // Create Circle Button
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
                        width: screenWidth * 0.65,
                        height: screenWidth * 0.65,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFB8956A).withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  width: screenWidth * 0.53,
                  height: screenWidth * 0.53,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFB8956A).withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.read<VideoBloc>().add(PickImageEvent()),
                  child: Container(
                    width: screenWidth * 0.42,
                    height: screenWidth * 0.42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFB8956A),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFB8956A).withOpacity(0.3),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: const Color(0xFFB8956A),
                          size: screenWidth * 0.1,
                        ),
                        SizedBox(height: screenHeight * 0.008),
                        Text(
                          l10n.create,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.03,
                            letterSpacing: 3,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
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
                      color: Color(0xFFB8956A),
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
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Action Buttons
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.image_outlined,
                  label: l10n.selectImage,
                  onTap: () => context.read<VideoBloc>().add(PickImageEvent()),
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
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
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: screenHeight * 0.02),

        // Recent Videos Section
        Expanded(
          flex: 4,
          child: _buildRecentVideos(screenWidth, screenHeight, l10n),
        ),

        SizedBox(height: screenHeight * 0.02),
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
        // Image Preview
        Expanded(
          flex: videoPath != null ? 4 : 5,
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
                border: Border.all(
                  color: const Color(0xFFB8956A).withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB8956A).withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(screenWidth * 0.035),
                child: Image.file(
                  imageFile,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),

        // Action Buttons
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.image_outlined,
                  label: l10n.changeImage,
                  onTap: () => context.read<VideoBloc>().add(PickImageEvent()),
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
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
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: screenHeight * 0.02),

        // Show Video Ready Section OR Recent Videos
        Expanded(
          flex: videoPath != null ? 3 : 3,
          child: videoPath != null
              ? _buildVideoReadySection(
            context,
            screenWidth,
            screenHeight,
            videoPath,
            l10n,
          )
              : _buildRecentVideos(screenWidth, screenHeight, l10n),
        ),

        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }

  Widget _buildVideoReadySection(
      BuildContext context,
      double screenWidth,
      double screenHeight,
      String videoPath,
      AppLocalizations l10n,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          border: Border.all(
            color: const Color(0xFFB8956A).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: const BoxDecoration(
                color: Color(0xFFB8956A),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: const Color(0xFF0A0A0A),
                size: screenWidth * 0.06,
              ),
            ),
            SizedBox(height: screenHeight * 0.012),
            Text(
              l10n.videoReady,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                letterSpacing: 2.5,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
            SizedBox(height: screenHeight * 0.018),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showVideoPreview(context, videoPath),
                icon: Icon(
                  Icons.play_circle_outline,
                  size: screenWidth * 0.055,
                ),
                label: Text(
                  l10n.previewVideo,
                  style: TextStyle(
                    letterSpacing: 2,
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB8956A),
                  foregroundColor: const Color(0xFF0A0A0A),
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.016,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentVideos(
      double screenWidth,
      double screenHeight,
      AppLocalizations l10n,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.recentVideos,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: screenWidth * 0.03,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  l10n.viewAll,
                  style: TextStyle(
                    color: const Color(0xFFB8956A),
                    fontSize: screenWidth * 0.03,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Expanded(
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            children: [
              _RecentVideoItem(
                title: 'EDITORIAL_01.MP4',
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8B6F47), Color(0xFF2A1810)],
                ),
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              SizedBox(width: screenWidth * 0.04),
              _RecentVideoItem(
                title: 'MOTION_SILK_V2',
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFB8956A), Color(0xFF6B5539)],
                ),
                showPlayIcon: true,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              SizedBox(width: screenWidth * 0.04),
              _RecentVideoItem(
                title: 'DRAFT_PRO',
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A4A4A), Color(0xFF1A1A1A)],
                ),
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isAccent;
  final VoidCallback onTap;
  final double screenWidth;
  final double screenHeight;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.isAccent = false,
    required this.onTap,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isAccent ? const Color(0xFFE6B84D) : const Color(0xFF1A1A1A),
      borderRadius: BorderRadius.circular(screenWidth * 0.03),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isAccent
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFB8956A),
                size: screenWidth * 0.07,
              ),
              SizedBox(height: screenHeight * 0.008),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isAccent ? const Color(0xFF1A1A1A) : Colors.white,
                  fontSize: screenWidth * 0.026,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentVideoItem extends StatelessWidget {
  final String title;
  final Gradient gradient;
  final bool showPlayIcon;
  final double screenWidth;
  final double screenHeight;

  const _RecentVideoItem({
    required this.title,
    required this.gradient,
    this.showPlayIcon = false,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        gradient: gradient,
        border: Border.all(
          color: const Color(0xFFB8956A).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          if (showPlayIcon)
            Center(
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.025),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: screenWidth * 0.07,
                ),
              ),
            ),
          Positioned(
            bottom: screenHeight * 0.01,
            left: screenWidth * 0.025,
            right: screenWidth * 0.025,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(screenWidth * 0.02),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.006,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.024,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}