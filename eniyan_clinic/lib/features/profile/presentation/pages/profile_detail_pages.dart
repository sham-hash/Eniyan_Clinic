import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/clinic_app_bar.dart';
import '../notification_navigation.dart';
import '../profile_data.dart';
import 'child_profile_page.dart';
import 'growth_development_page.dart';

class PersonalInformationPage extends StatelessWidget {
  const PersonalInformationPage({super.key, this.parent = currentParent});

  final ParentProfile parent;

  @override
  Widget build(BuildContext context) {
    return _ProfileSubpage(
      title: 'Personal Information',
      children: [
        _AvatarHeader(
          initials: parent.initials,
          title: parent.name,
          subtitle: 'Parent account',
        ),
        _InfoCard(
          title: 'Contact Details',
          children: [
            _DetailRow(Icons.phone_outlined, 'Phone number', parent.phone),
            _DetailRow(
              Icons.mail_outline_rounded,
              'Email address',
              parent.email,
            ),
            _DetailRow(Icons.location_on_outlined, 'Address', parent.address),
          ],
        ),
        _ActionButton(
          label: 'Edit Personal Information',
          icon: Icons.edit_outlined,
          onPressed: () => _showMessage(
            context,
            'Personal information editing will be available soon.',
          ),
        ),
      ],
    );
  }
}

class ChildInformationPage extends StatelessWidget {
  const ChildInformationPage({super.key, this.children = profileChildren});

  final List<ChildProfile> children;

  @override
  Widget build(BuildContext context) {
    return _ProfileSubpage(
      title: 'Child Information',
      children: [
        const _PageIntro(
          title: 'Your children',
          subtitle: 'Select a child to view their complete profile.',
        ),
        for (final child in children)
          _ChildListTile(child: child, onTap: () => _openChild(context, child)),
        _ActionButton(
          label: 'Add another child',
          icon: Icons.add_rounded,
          onPressed: () => _showMessage(
            context,
            'Add Child form is ready for your next child.',
          ),
        ),
      ],
    );
  }
}

class HealthRecordsPage extends StatelessWidget {
  const HealthRecordsPage({super.key, this.children = profileChildren});

  final List<ChildProfile> children;

  @override
  Widget build(BuildContext context) {
    return _ProfileSubpage(
      title: 'Health Records',
      children: [
        const _PageIntro(
          title: 'Choose a child',
          subtitle: 'View appointments, checkups, and vaccinations by child.',
        ),
        for (final child in children)
          _ChildListTile(
            child: child,
            trailing: '${child.records.length} records',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => HealthRecordsChildPage(child: child),
              ),
            ),
          ),
      ],
    );
  }
}

class HealthRecordsChildPage extends StatelessWidget {
  const HealthRecordsChildPage({super.key, required this.child});

  final ChildProfile child;

  @override
  Widget build(BuildContext context) {
    return _ProfileSubpage(
      title: '${child.name} · Records',
      children: [
        _AvatarHeader(
          initials: child.initials,
          title: child.name,
          subtitle: '${child.age} · ${child.gender}',
        ),
        _InfoCard(
          title: 'Recent Health Records',
          children: [
            for (var index = 0; index < child.records.length; index++)
              _TimelineRow(
                record: child.records[index],
                isLast: index == child.records.length - 1,
              ),
          ],
        ),
        _ActionButton(
          label: 'Book a checkup',
          icon: Icons.calendar_month_outlined,
          onPressed: () =>
              _showMessage(context, 'Appointment booking will open here.'),
        ),
      ],
    );
  }
}

class GrowthDevelopmentSelectionPage extends StatelessWidget {
  const GrowthDevelopmentSelectionPage({
    super.key,
    this.children = profileChildren,
  });

  final List<ChildProfile> children;

  @override
  Widget build(BuildContext context) {
    return _ProfileSubpage(
      title: 'Growth & Development',
      children: [
        const _PageIntro(
          title: 'Choose a child',
          subtitle: 'View growth measurements and development trends by child.',
        ),
        for (final child in children)
          _ChildListTile(
            child: child,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => GrowthDevelopmentPage(child: child),
              ),
            ),
          ),
      ],
    );
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _notifications = <_NotificationItem>[
    _NotificationItem(
      icon: Icons.calendar_month_outlined,
      color: AppColors.softBlue,
      iconColor: AppColors.blue,
      title: 'Appointment tomorrow',
      message: 'Arjun has an appointment with Dr. Elamparithi at 10:30 AM.',
      time: '2 hours ago',
    ),
    _NotificationItem(
      icon: Icons.vaccines_outlined,
      color: AppColors.softGreen,
      iconColor: AppColors.green,
      title: 'Vaccination reminder',
      message: 'Ananya’s next vaccination is due this week.',
      time: 'Yesterday',
    ),
    _NotificationItem(
      icon: Icons.show_chart_rounded,
      color: AppColors.orangeSoft,
      iconColor: AppColors.orangeDark,
      title: 'Growth update available',
      message: 'New growth measurements were added to Arjun’s profile.',
      time: '12 Sep 2026',
    ),
    _NotificationItem(
      icon: Icons.favorite_border_rounded,
      color: AppColors.purpleSoft,
      iconColor: AppColors.purple,
      title: 'Health tip for your family',
      message: 'Small bedtime routines can support better sleep for children.',
      time: '08 Sep 2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _ProfileSubpage(
      title: 'Notifications',
      children: [
        Row(
          children: [
            const Expanded(
              child: _PageIntro(
                title: 'Your updates',
                subtitle: 'Important reminders and family health updates.',
              ),
            ),
            if (_notifications.any((item) => !item.isRead))
              TextButton(
                onPressed: () => setState(() {
                  for (final item in _notifications) {
                    item.isRead = true;
                  }
                }),
                child: const Text('Mark all read'),
              ),
          ],
        ),
        _NotificationGroup(items: _notifications, onTap: _markRead),
      ],
    );
  }

  void _markRead(_NotificationItem item) {
    if (!item.isRead) setState(() => item.isRead = true);
  }
}

class _NotificationGroup extends StatelessWidget {
  const _NotificationGroup({required this.items, required this.onTap});

  final List<_NotificationItem> items;
  final ValueChanged<_NotificationItem> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _NotificationTile(
              item: items[index],
              onTap: () => onTap(items[index]),
            ),
            if (index < items.length - 1)
              const Divider(
                height: 1,
                indent: 66,
                color: AppColors.borderLight,
              ),
          ],
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item, required this.onTap});

  final _NotificationItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.isRead ? AppColors.white : AppColors.bluePale,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 19),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (!item.isRead) const _UnreadDot(),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.message,
                      style: const TextStyle(
                        color: AppColors.gray,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.time,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.ink,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnreadDot extends StatelessWidget {
  const _UnreadDot();

  @override
  Widget build(BuildContext context) => Container(
    width: 7,
    height: 7,
    decoration: const BoxDecoration(
      color: AppColors.blue,
      shape: BoxShape.circle,
    ),
  );
}

class _NotificationItem {
  _NotificationItem({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.time,
  });

  final IconData icon;
  final Color color;
  final Color iconColor;
  final String title;
  final String message;
  final String time;
  bool isRead = false;
}

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileSubpage(
      title: 'Privacy',
      children: [
        _PageIntro(
          title: 'Your data, your control',
          subtitle:
              'We keep your family health information private and secure.',
        ),
        _InfoCard(
          title: 'Data and permissions',
          children: [
            _DetailRow(
              Icons.security_outlined,
              'Data protection',
              'Your information is encrypted and access controlled.',
            ),
            _DetailRow(
              Icons.download_outlined,
              'Download your data',
              'Request a copy of your account information.',
            ),
            _DetailRow(
              Icons.delete_outline_rounded,
              'Delete account',
              'Permanently remove your account and data.',
            ),
          ],
        ),
      ],
    );
  }
}

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProfileSubpage(
      title: 'Help & Support',
      children: [
        const _PageIntro(
          title: 'How can we help?',
          subtitle: 'Find answers or contact the Eniyan Clinics team.',
        ),
        _SupportAction(
          icon: Icons.help_outline_rounded,
          title: 'Frequently asked questions',
          onTap: () => _showMessage(context, 'FAQ support will open here.'),
        ),
        _SupportAction(
          icon: Icons.chat_bubble_outline_rounded,
          title: 'Chat with support',
          onTap: () => _showMessage(context, 'Support chat will open here.'),
        ),
        _SupportAction(
          icon: Icons.phone_outlined,
          title: 'Call the clinic',
          onTap: () =>
              _showMessage(context, 'Clinic contact options will open here.'),
        ),
      ],
    );
  }
}

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileSubpage(
      title: 'Terms & Conditions',
      children: [
        _PageIntro(
          title: 'Eniyan Clinics terms',
          subtitle: 'Last updated 22 September 2026',
        ),
        _InfoCard(
          title: 'Using Eniyan Clinics',
          children: [
            _Paragraph(
              'Eniyan Clinics helps families manage child health information and appointments. Information shown in the app is provided for care coordination and does not replace professional medical advice.',
            ),
            _Paragraph(
              'Please keep your account details accurate and contact your healthcare provider for urgent or emergency concerns.',
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileSubpage extends StatelessWidget {
  const _ProfileSubpage({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ClinicHeader(
        title: title,
        showBackButton: true,
        onBack: () => Navigator.of(context).pop(),
        onNotificationTap: () => openNotifications(context),
        onProfileTap: () => openProfile(context),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
        children: [
          for (var index = 0; index < children.length; index++) ...[
            children[index],
            if (index < children.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _PageIntro extends StatelessWidget {
  const _PageIntro({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(color: AppColors.gray, fontSize: 12),
        ),
      ],
    );
  }
}

class _AvatarHeader extends StatelessWidget {
  const _AvatarHeader({
    required this.initials,
    required this.title,
    required this.subtitle,
  });

  final String initials;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.blue,
            child: Text(
              initials,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.gray, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: AppColors.gray, fontSize: 11),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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

class _ChildListTile extends StatelessWidget {
  const _ChildListTile({
    required this.child,
    required this.onTap,
    this.trailing,
  });

  final ChildProfile child;
  final VoidCallback onTap;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.yellowSoft,
                child: Icon(Icons.face_rounded, color: AppColors.yellow),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child.name,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${child.age} · ${child.gender}',
                      style: const TextStyle(
                        color: AppColors.gray,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null)
                Text(
                  trailing!,
                  style: const TextStyle(color: AppColors.gray, fontSize: 10),
                ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right_rounded, color: AppColors.ink),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.record, required this.isLast});

  final HealthRecord record;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 18,
            child: Column(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.only(top: 3),
                  decoration: const BoxDecoration(
                    color: AppColors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 1, color: AppColors.blueBorder),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.date,
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  record.title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  record.provider,
                  style: const TextStyle(color: AppColors.gray, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
    );
  }
}

class _SupportAction extends StatelessWidget {
  const _SupportAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(icon, color: AppColors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.ink),
            ],
          ),
        ),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      text,
      style: const TextStyle(color: AppColors.gray, fontSize: 12, height: 1.5),
    ),
  );
}

void _openChild(BuildContext context, ChildProfile child) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => ChildProfilePage(child: child)),
  );
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
