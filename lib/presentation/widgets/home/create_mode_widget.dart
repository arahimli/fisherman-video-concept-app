import 'package:flutter/material.dart';

import '../../../core/design/design_system.dart';
import '../../../l10n/app_localizations.dart';
import 'action_button.dart';
import 'home_sheets.dart';
import 'recent_videos_widget.dart';
import 'solar_system_painter.dart';

class CreateModeWidget extends StatefulWidget {
  const CreateModeWidget({super.key});

  @override
  State<CreateModeWidget> createState() => _CreateModeWidgetState();
}

class _CreateModeWidgetState extends State<CreateModeWidget>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late AnimationController _orbitController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 36),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Center(
            child: AnimatedBuilder(
              animation: _orbitController,
              builder: (context, child) {
                return SizedBox(
                  width: screenWidth * 0.88,
                  height: screenWidth * 0.88,
                  child: CustomPaint(
                    painter: SolarSystemPainter(_orbitController.value),
                    child: child,
                  ),
                );
              },
              child: Center(
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, _) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: GestureDetector(
                        onTap: () => showImageSourceSheet(context),
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
                              Icon(Icons.add, color: AppColors.accent, size: screenWidth * 0.1),
                              const SizedBox(height: AppSpacing.sm),
                              Text(l10n.create, style: AppTextStyles.createLabel),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Row(
            children: [
              Expanded(
                child: HomeActionButton(
                  icon: Icons.image_outlined,
                  label: l10n.selectImage,
                  onTap: () => showImageSourceSheet(context),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: HomeActionButton(
                  icon: Icons.videocam_outlined,
                  label: l10n.generateVideo,
                  isAccent: true,
                  onTap: null,
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
}
