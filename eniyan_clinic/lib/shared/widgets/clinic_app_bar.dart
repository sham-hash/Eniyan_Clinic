import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class ClinicHeader extends StatelessWidget implements PreferredSizeWidget {
  const ClinicHeader({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBack,
    this.onNotificationTap,
    this.onProfileTap,
    this.showNotificationButton = true,
    this.showProfileButton = true,
    this.toolbarHeight = 72,
  });

  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final bool showNotificationButton;
  final bool showProfileButton;
  final double toolbarHeight;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[];

    if (showNotificationButton) {
      actions.add(_NotificationAction(onTap: onNotificationTap ?? () {}));
      actions.add(const SizedBox(width: 8));
    }

    if (showProfileButton) {
      actions.add(_ProfileAction(onTap: onProfileTap ?? () {}));
      actions.add(const SizedBox(width: 16));
    }

    return AppBar(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: toolbarHeight,
      leading: showBackButton
          ? IconButton(
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              tooltip: 'Back',
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.blue,
              ),
            )
          : null,
      titleSpacing: showBackButton ? null : 16,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: actions,
    );
  }
}

class _NotificationAction extends StatelessWidget {
  const _NotificationAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onTap,
          tooltip: 'Notifications',
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.blue,
            size: 28,
          ),
        ),
        Positioned(
          top: 6,
          right: 4,
          child: Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.red,
              shape: BoxShape.circle,
            ),
            child: const Text(
              '3',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.softBlue,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(
          Icons.person_outline_rounded,
          color: AppColors.blue,
          size: 26,
        ),
      ),
    );
  }
}
