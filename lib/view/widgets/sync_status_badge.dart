import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class SyncStatusBadge extends StatelessWidget {
  final bool isSynced;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;

  const SyncStatusBadge({
    super.key,
    required this.isSynced,
    this.textColor,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color defaultColor =
    isSynced ? AppTheme.syncedColor : AppTheme.pendingColor;

    final Color finalTextColor = textColor ?? defaultColor;
    final Color finalBorderColor = borderColor ?? defaultColor;
    final Color finalBackgroundColor =
        backgroundColor ?? defaultColor.withOpacity(0.12);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: finalBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: finalBorderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSynced
                ? Icons.cloud_done_rounded
                : Icons.cloud_upload_rounded,
            size: 14,
            color: finalTextColor,
          ),
          const SizedBox(width: 4),
          Text(
            isSynced ? 'Synced' : 'Pending',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: finalTextColor,
            ),
          ),
        ],
      ),
    );
  }
}