import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_feedback.dart';
import '../../../../shared/widgets/clinic_app_bar.dart';
import '../../../profile/presentation/notification_navigation.dart';

class AppointmentsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const AppointmentsAppBar({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return ClinicHeader(
      title: 'My Appointments',
      showBackButton: true,
      onBack: onBack ?? () => Navigator.of(context).maybePop(),
      onNotificationTap: () => openNotifications(context),
      onProfileTap: () => openProfile(context),
    );
  }
}

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 30, 22, 120),
      children: [
        _AppointmentTabs(
          selectedIndex: _selectedTab,
          onSelected: (index) => setState(() => _selectedTab = index),
        ),
        const SizedBox(height: 24),
        if (_selectedTab == 0) ...const [
          _AppointmentDetailCard(
            doctor: 'Dr. Elamparithi',
            specialty: 'Pediatrician & Neonatologist',
            date: '18 Sep 2026',
            time: '10:30 AM',
            accent: AppColors.blue,
            avatarColor: AppColors.softBlue,
            status: 'Upcoming',
          ),
          SizedBox(height: 16),
          _AppointmentDetailCard(
            doctor: 'Dr. Meena R.',
            specialty: 'Asthma & Allergy Specialist',
            date: '04 Oct 2026',
            time: '11:00 AM',
            accent: AppColors.green,
            avatarColor: AppColors.softGreen,
            status: 'Upcoming',
          ),
        ] else
          const _EmptyAppointments(),
      ],
    );
  }
}

class _AppointmentTabs extends StatelessWidget {
  const _AppointmentTabs({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const labels = ['Upcoming', 'Completed', 'Cancelled'];
    return Container(
      height: 58,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          for (var index = 0; index < labels.length; index++)
            Expanded(
              child: GestureDetector(
                onTap: () => onSelected(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? AppColors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: selectedIndex == index
                        ? const [
                            BoxShadow(
                              color: Color(0x140051CE),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      color: selectedIndex == index
                          ? AppColors.blue
                          : AppColors.gray,
                      fontWeight: FontWeight.w700,
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

class _AppointmentDetailCard extends StatelessWidget {
  const _AppointmentDetailCard({
    required this.doctor,
    required this.specialty,
    required this.date,
    required this.time,
    required this.accent,
    required this.avatarColor,
    required this.status,
  });

  final String doctor;
  final String specialty;
  final String date;
  final String time;
  final Color accent;
  final Color avatarColor;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: accent, width: 5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A315D8B),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: avatarColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'DR',
                  style: TextStyle(color: accent, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      specialty,
                      style: const TextStyle(
                        color: AppColors.gray,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(
                color: AppColors.softGreen,
                textColor: AppColors.green,
                label: status,
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'For Arjun Kumar',
            style: TextStyle(
              color: AppColors.textBlueGray,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 17),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _AppointmentMeta(Icons.calendar_today_outlined, date),
              _AppointmentMeta(Icons.schedule_outlined, time),
              const _AppointmentMeta(Icons.videocam_outlined, 'In-person'),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              FilledButton(
                onPressed: () =>
                    showAppMessage(context, 'Appointment details opened.'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                ),
                child: const Text('View Details'),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () =>
                    showAppMessage(context, 'Reschedule options opened.'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.blue,
                  side: const BorderSide(color: AppColors.blue),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('Reschedule'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.color,
    required this.textColor,
    required this.label,
  });

  final Color color;
  final Color textColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _AppointmentMeta extends StatelessWidget {
  const _AppointmentMeta(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: AppColors.gray),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(color: AppColors.gray, fontSize: 13),
        ),
      ],
    );
  }
}

class _EmptyAppointments extends StatelessWidget {
  const _EmptyAppointments();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Icon(Icons.event_available_rounded, color: AppColors.blue, size: 48),
          SizedBox(height: 16),
          Text(
            'No appointments in this section',
            style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton();

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
            size: 30,
          ),
        ),
        Positioned(
          top: 5,
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

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.softBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.person_outline_rounded,
        color: AppColors.blue,
        size: 23,
      ),
      ),
    );
  }
}
