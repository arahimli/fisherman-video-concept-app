import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/design/design_system.dart';
import '../../l10n/app_localizations_extension.dart';

class ForceUpdatePage extends StatelessWidget {
  final String storeUrl;

  const ForceUpdatePage({super.key, required this.storeUrl});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Icon
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.accentOverlay,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.accentBorder,
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.system_update_outlined,
                    size: 48,
                    color: AppColors.accent,
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  l10n.forceUpdateTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.appBarTitle.copyWith(fontSize: 22),
                ),

                const SizedBox(height: 16),

                // Message
                Text(
                  l10n.forceUpdateMessage,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.emptyStateBody.copyWith(height: 1.6),
                ),

                const Spacer(),

                // Update button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: storeUrl.isNotEmpty
                        ? () => _openStore(storeUrl)
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      textStyle: AppTextStyles.previewButtonLabel,
                    ),
                    child: Text(l10n.forceUpdateButton),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openStore(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
