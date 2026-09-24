import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_feedback.dart';
import '../../../../shared/widgets/clinic_app_bar.dart';
import '../../../profile/presentation/notification_navigation.dart';

class FacilitiesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FacilitiesAppBar({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return ClinicHeader(
      title: 'Our Facilities',
      showBackButton: true,
      onBack: onBack ?? () => Navigator.of(context).maybePop(),
      onNotificationTap: () => openNotifications(context),
      onProfileTap: () => openProfile(context),
    );
  }
}

class FacilitiesPage extends StatelessWidget {
  const FacilitiesPage({super.key});

  static const _facilities = [
    _Facility(
      Icons.child_care_rounded,
      'Pediatric Consultation',
      'Thoughtful care for growing children',
      AppColors.softBlue,
      AppColors.blue,
    ),
    _Facility(
      Icons.favorite_border_rounded,
      'Neonatal Care',
      'Specialized support for newborns',
      AppColors.softGreen,
      AppColors.green,
    ),
    _Facility(
      Icons.vaccines_outlined,
      'Vaccination',
      'Safe, gentle immunization',
      AppColors.purpleSoft,
      AppColors.purple,
    ),
    _Facility(
      Icons.show_chart_rounded,
      'Growth Monitoring',
      'Track every milestone',
      AppColors.softBlue,
      AppColors.blue,
    ),
    _Facility(
      Icons.medication_outlined,
      'Pharmacy',
      'Medicines made simple',
      AppColors.softGreen,
      AppColors.green,
    ),
    _Facility(
      Icons.science_outlined,
      'Laboratory',
      'Quick, reliable diagnostics',
      AppColors.orangeSoft,
      AppColors.orangeDark,
    ),
    _Facility(
      Icons.people_outline_rounded,
      'Waiting Area',
      'A calm space for families',
      Color(0xFFE3F7F5),
      Color(0xFF119B91),
    ),
    _Facility(
      Icons.emergency_outlined,
      'Emergency Support',
      'Here when you need us',
      AppColors.redSoft,
      AppColors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 116),
      children: [
        const Text(
          'Comfortable care for your child.',
          style: TextStyle(color: AppColors.gray, fontSize: 13),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _facilities.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.45,
          ),
          itemBuilder: (context, index) {
            final facility = _facilities[index];
            return _FacilityCard(facility: facility);
          },
        ),
        const SizedBox(height: 18),
        const _SupportCard(),
      ],
    );
  }
}

class _FacilityCard extends StatelessWidget {
  const _FacilityCard({required this.facility});

  final _Facility facility;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () =>
            showAppMessage(context, '${facility.title} details opened.'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: facility.iconBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(facility.icon, color: facility.iconColor, size: 20),
              ),
              const Spacer(),
              Text(
                facility.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                facility.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.gray, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
      decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueBorder),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "WE'RE HERE FOR YOU",
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .6,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Have a question?',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Our care team is one tap away.',
                  style: TextStyle(color: AppColors.gray, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => showAppMessage(
                context,
                'Our care team will be with you shortly.',
              ),
              tooltip: 'Contact care team',
              icon: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: AppColors.blue,
                size: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FacilitiesNotificationButton extends StatelessWidget {
  const _FacilitiesNotificationButton();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () => openNotifications(context),
          tooltip: 'Notifications',
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.blue,
            size: 23,
          ),
        ),
        Positioned(
          top: 3,
          right: 4,
          child: Container(
            width: 14,
            height: 14,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.red,
              shape: BoxShape.circle,
            ),
            child: const Text(
              '3',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FacilitiesProfileAvatar extends StatelessWidget {
  const _FacilitiesProfileAvatar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.softBlue,
        borderRadius: BorderRadius.circular(11),
      ),
      child: const Icon(
        Icons.person_outline_rounded,
        color: AppColors.blue,
        size: 20,
      ),
      ),
    );
  }
}

class _Facility {
  const _Facility(
    this.icon,
    this.title,
    this.description,
    this.iconBackground,
    this.iconColor,
  );

  final IconData icon;
  final String title;
  final String description;
  final Color iconBackground;
  final Color iconColor;
}
