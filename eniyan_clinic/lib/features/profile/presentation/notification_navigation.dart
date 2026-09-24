import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/clinic_app_bar.dart';
import 'pages/profile_detail_pages.dart';
import 'pages/profile_page.dart';

void openNotifications(BuildContext context) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const NotificationsPage()));
}

void openProfile(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const _ProfileRoutePage()),
  );
}

class _ProfileRoutePage extends StatelessWidget {
  const _ProfileRoutePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ClinicHeader(
        title: 'Profile',
        showBackButton: true,
        onBack: () => Navigator.of(context).pop(),
        onNotificationTap: () => openNotifications(context),
        showProfileButton: false,
      ),
      body: const ProfilePage(),
    );
  }
}
