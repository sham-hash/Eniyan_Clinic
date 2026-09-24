import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/clinic_app_bar.dart';
import '../../../appointments/presentation/pages/appointments_page.dart';
import '../../../blog/presentation/pages/blog_page.dart';
import '../../../facilities/presentation/pages/facilities_page.dart';
import '../../../peak_flow/presentation/pages/peak_flow_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../profile/presentation/notification_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const _destinations = [
    _NavDestination(Icons.home_rounded, 'Home'),
    _NavDestination(Icons.calendar_month_outlined, 'Appointments'),
    _NavDestination(Icons.local_hospital_outlined, 'Facilities'),
    _NavDestination(Icons.menu_book_outlined, 'Blog'),
    _NavDestination(Icons.air_rounded, 'Peak Flow'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _appBarForSelectedTab(),
      body: _bodyForSelectedTab(),
      bottomNavigationBar: _ClinicNavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }

  PreferredSizeWidget _appBarForSelectedTab() {
    return switch (_selectedIndex) {
      1 => AppointmentsAppBar(onBack: () => setState(() => _selectedIndex = 0)),
      2 => FacilitiesAppBar(onBack: () => setState(() => _selectedIndex = 0)),
      3 => BlogAppBar(onBack: () => setState(() => _selectedIndex = 0)),
      4 => const _PeakFlowAppBar(),
      _ => _HomeAppBar(onProfile: () => _openProfile(context)),
    };
  }

  Widget _bodyForSelectedTab() {
    return switch (_selectedIndex) {
      1 => const AppointmentsPage(),
      2 => const FacilitiesPage(),
      3 => const BlogPage(),
      4 => const PeakFlowPage(),
      _ => const _DashboardContent(),
    };
  }

  void _openProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const _StandaloneProfilePage()),
    );
  }
}

class _StandaloneProfilePage extends StatelessWidget {
  const _StandaloneProfilePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _ProfileAppBar(onBack: () => Navigator.of(context).pop()),
      body: const ProfilePage(),
    );
  }
}

class _PeakFlowAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _PeakFlowAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return ClinicHeader(
      title: 'Peak Flow',
      showBackButton: false,
      onNotificationTap: () => openNotifications(context),
      onProfileTap: () => openProfile(context),
    );
  }
}

class _ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ProfileAppBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return ClinicHeader(
      title: 'Profile',
      showBackButton: true,
      onBack: onBack,
      onNotificationTap: () => openNotifications(context),
      onProfileTap: () => openProfile(context),
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar({required this.onProfile});

  final VoidCallback onProfile;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      automaticallyImplyLeading: false,
      toolbarHeight: 72,
      titleSpacing: 16,
      title: const SizedBox(
        width: 72,
        height: 64,
        child: Center(child: AppLogo(width: 60)),
      ),
      actions: [
        Stack(
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
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: onProfile,
          borderRadius: BorderRadius.circular(14),
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          child: Tooltip(
            message: 'Open profile',
            child: Container(
              width: 44,
              height: 44,
              margin: const EdgeInsets.only(right: 16),
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
          ),
        ),
      ],
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 32),
      children: const [
        _GreetingHeader(),
        SizedBox(height: 30),
        _ChildProfileCard(),
        SizedBox(height: 36),
        _SectionTitle(title: 'Quick Actions'),
        SizedBox(height: 16),
        _QuickActionsGrid(),
        SizedBox(height: 36),
        _SectionTitle(title: 'Upcoming Appointment', actionLabel: 'See all'),
        SizedBox(height: 14),
        _AppointmentCard(),
        SizedBox(height: 36),
        _SectionTitle(title: 'Child Health', actionLabel: 'Details'),
        SizedBox(height: 14),
        _HealthSummary(),
        SizedBox(height: 36),
        _SectionTitle(title: 'Growth Chart', actionLabel: 'Full chart'),
        SizedBox(height: 14),
        _GrowthCard(),
        SizedBox(height: 36),
        _SectionTitle(title: 'Child Care Services'),
        SizedBox(height: 14),
        _ServicesRow(),
        SizedBox(height: 36),
        _SectionTitle(title: 'Health Tips', actionLabel: 'View All'),
        SizedBox(height: 14),
        _HealthTips(),
        SizedBox(height: 28),
        _SocialFooter(),
      ],
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Morning 👋',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontSize: 18, color: AppColors.gray),
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome to Eniyan Clinics',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.blue,
            fontSize: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Your child's health, all in one place.",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _ChildProfileCard extends StatelessWidget {
  const _ChildProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.bluePale,
        border: Border.all(color: AppColors.blueBorder),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.face_rounded,
              color: AppColors.yellow,
              size: 44,
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MY CHILD',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Arjun Kumar',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  '6 Years · Height 118cm · Weight 22kg',
                  style: TextStyle(color: AppColors.gray, fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  'View Child Profile  →',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.actionLabel});

  final String title;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 21,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (actionLabel != null)
          Text(
            actionLabel!,
            style: const TextStyle(
              color: AppColors.blue,
              fontWeight: FontWeight.w800,
            ),
          ),
      ],
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.22,
      children: const [
        _QuickAction(
          icon: Icons.calendar_month_outlined,
          title: 'Book Appointment',
          subtitle: 'Find the right care',
          color: AppColors.softBlue,
          iconColor: AppColors.blue,
        ),
        _QuickAction(
          icon: Icons.menu_book_outlined,
          title: 'My Appointments',
          subtitle: 'Stay on track',
          color: AppColors.softGreen,
          iconColor: AppColors.green,
        ),
        _QuickAction(
          icon: Icons.show_chart_rounded,
          title: 'Growth Chart',
          subtitle: 'See progress',
          color: AppColors.purpleSoft,
          iconColor: AppColors.purple,
        ),
        _QuickAction(
          icon: Icons.person_outline_rounded,
          title: 'Child Profile',
          subtitle: 'All details',
          color: AppColors.orangeSoft,
          iconColor: AppColors.orangeDark,
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const Spacer(),
          Text(
            title,
            style: TextStyle(color: iconColor, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.gray, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: const Border(left: BorderSide(color: AppColors.blue, width: 5)),
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
                  color: AppColors.softBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'DR',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Elamparithi',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Pediatrician & Neonatologist',
                      style: TextStyle(color: AppColors.gray, fontSize: 13),
                    ),
                  ],
                ),
              ),
              _StatusPill(),
            ],
          ),
          const SizedBox(height: 18),
          const Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _AppointmentMeta(Icons.calendar_today_outlined, '18 Sep 2026'),
              _AppointmentMeta(Icons.schedule_outlined, '10:30 AM'),
              _AppointmentMeta(Icons.videocam_outlined, 'In-person'),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: const Text('View'),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.blue,
                  side: const BorderSide(color: AppColors.blue),
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
  const _StatusPill();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        child: Text(
          'Upcoming',
          style: TextStyle(
            color: AppColors.green,
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

class _HealthSummary extends StatelessWidget {
  const _HealthSummary();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _HealthMetric('Height', '118cm')),
        SizedBox(width: 8),
        Expanded(child: _HealthMetric('Weight', '22kg')),
        SizedBox(width: 8),
        Expanded(child: _HealthMetric('Last Checkup', '05 Sep')),
        SizedBox(width: 8),
        Expanded(child: _HealthMetric('Next Visit', '18 Sep')),
      ],
    );
  }
}

class _HealthMetric extends StatelessWidget {
  const _HealthMetric(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.gray, fontSize: 12),
          ),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthCard extends StatelessWidget {
  const _GrowthCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Arjun's height is tracking beautifully",
            style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 112,
            width: double.infinity,
            child: CustomPaint(painter: _GrowthChartPainter()),
          ),
          const SizedBox(height: 10),
          const Text(
            'View Full Growth Chart  →',
            style: TextStyle(
              color: AppColors.blue,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.blueBorderLight
      ..strokeWidth = 1;
    final linePaint = Paint()
      ..color = AppColors.blue
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    for (var index = 0; index < 6; index++) {
      final y = index * size.height / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    for (var index = 0; index < 8; index++) {
      final x = index * size.width / 7;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    final path = Path()..moveTo(0, size.height * .72);
    path.cubicTo(
      size.width * .18,
      size.height * .62,
      size.width * .27,
      size.height * .58,
      size.width * .43,
      size.height * .38,
    );
    path.cubicTo(
      size.width * .58,
      size.height * .2,
      size.width * .74,
      size.height * .27,
      size.width,
      size.height * .1,
    );
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ServicesRow extends StatelessWidget {
  const _ServicesRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          _ServiceCard(
            Icons.child_care_rounded,
            'Pediatrics',
            'Gentle everyday care',
            AppColors.softBlue,
            AppColors.blue,
          ),
          SizedBox(width: 12),
          _ServiceCard(
            Icons.favorite_border_rounded,
            'Neonatal Care',
            'Expert newborn support',
            AppColors.softGreen,
            AppColors.green,
          ),
          SizedBox(width: 12),
          _ServiceCard(
            Icons.show_chart_rounded,
            'Asthma',
            'Breathe easier',
            AppColors.purpleSoft,
            AppColors.purple,
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard(
    this.icon,
    this.title,
    this.subtitle,
    this.color,
    this.iconColor,
  );

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 178,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color,
            foregroundColor: iconColor,
            child: Icon(icon),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.gray, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _HealthTips extends StatelessWidget {
  const _HealthTips();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _TipCard(
            'Nutrition',
            'Building a happy, healthy plate for your child',
            '12 Sep 2026',
            AppColors.blueLight,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _TipCard(
            'Child Health',
            'The little rituals that make bedtime easier',
            '08 Sep 2026',
            AppColors.purpleLight,
          ),
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard(this.category, this.title, this.date, this.color);

  final String category;
  final String title;
  final String date;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 70, color: color),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  date,
                  style: const TextStyle(color: AppColors.gray, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialFooter extends StatelessWidget {
  const _SocialFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Stay Connected',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _SocialIcon(Icons.camera_alt_outlined, AppColors.pink),
            SizedBox(width: 14),
            _SocialIcon(Icons.facebook_rounded, AppColors.blue),
            SizedBox(width: 14),
            _SocialIcon(Icons.play_arrow_rounded, AppColors.red),
            SizedBox(width: 14),
            _SocialIcon(Icons.chat_bubble_outline_rounded, AppColors.green),
          ],
        ),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  const _SocialIcon(this.icon, this.color);

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: color,
      foregroundColor: AppColors.white,
      child: Icon(icon, size: 26),
    );
  }
}

class _ClinicNavigationBar extends StatelessWidget {
  const _ClinicNavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: SafeArea(
        top: false,
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: 0,
          height: 76,
          indicatorColor: AppColors.softBlue,
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          destinations: _HomePageState._destinations
              .map(
                (destination) => NavigationDestination(
                  icon: Icon(destination.icon),
                  selectedIcon: Icon(destination.icon),
                  label: destination.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _NavDestination {
  const _NavDestination(this.icon, this.label);

  final IconData icon;
  final String label;
}
