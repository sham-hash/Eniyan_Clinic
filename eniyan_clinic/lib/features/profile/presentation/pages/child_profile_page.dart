import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/clinic_app_bar.dart';
import '../profile_data.dart';
import 'growth_development_page.dart';
import '../notification_navigation.dart';

class ChildProfilePage extends StatelessWidget {
  const ChildProfilePage({super.key, required this.child});

  final ChildProfile child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const _ChildProfileAppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 28),
        children: [
          _ChildHero(child: child),
          SizedBox(height: 15),
          _BasicInformationCard(child: child),
          SizedBox(height: 11),
          _HealthOverviewCard(child: child),
          SizedBox(height: 11),
          _HealthRecordsCard(child: child),
        ],
      ),
    );
  }
}

class _ChildProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _ChildProfileAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    return ClinicHeader(
      title: 'Child Profile',
      showBackButton: true,
      onBack: () => Navigator.of(context).pop(),
      onNotificationTap: () => openNotifications(context),
      onProfileTap: () => openProfile(context),
    );
  }
}

class _ChildHero extends StatelessWidget {
  const _ChildHero({required this.child});

  final ChildProfile child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 38,
          backgroundColor: AppColors.blueLight,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.white,
            child: Icon(Icons.face_rounded, color: AppColors.yellow, size: 42),
          ),
        ),
        SizedBox(height: 9),
        Text(
          child.name,
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '${child.age}  ·  ${child.gender}',
          style: _ChildMetaStyle.textStyle,
        ),
      ],
    );
  }
}

class _BasicInformationCard extends StatelessWidget {
  const _BasicInformationCard({required this.child});

  final ChildProfile child;

  @override
  Widget build(BuildContext context) {
    return _ProfileSection(
      title: 'Basic Information',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _InfoValue('Date of Birth', child.dateOfBirth)),
              Expanded(child: _InfoValue('Age', child.age)),
            ],
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _InfoValue('Gender', child.gender)),
              Expanded(child: _InfoValue('Blood Group', child.bloodGroup)),
            ],
          ),
        ],
      ),
    );
  }
}

class _HealthOverviewCard extends StatelessWidget {
  const _HealthOverviewCard({required this.child});

  final ChildProfile child;

  @override
  Widget build(BuildContext context) {
    return _ProfileSection(
      title: 'Health Overview',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _HealthMetric(
                  Icons.show_chart_rounded,
                  'Height',
                  child.height,
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: _HealthMetric(
                  Icons.person_outline_rounded,
                  'Weight',
                  child.weight,
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: _HealthMetric(
                  Icons.calendar_month_outlined,
                  'Checkup',
                  child.lastUpdated,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => GrowthDevelopmentPage(child: child),
                  ),
                );
              },
              icon: const Icon(Icons.show_chart_rounded, size: 17),
              label: const Text('View Growth Chart  →'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthRecordsCard extends StatelessWidget {
  const _HealthRecordsCard({required this.child});

  final ChildProfile child;

  @override
  Widget build(BuildContext context) {
    return _ProfileSection(
      title: 'Health Records',
      child: Column(
        children: [
          for (var index = 0; index < child.records.length; index++)
            _HealthRecordTile(
              record: child.records[index],
              isLast: index == child.records.length - 1,
            ),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.ink, fontSize: 13),
          ),
          const SizedBox(height: 13),
          child,
        ],
      ),
    );
  }
}

class _InfoValue extends StatelessWidget {
  const _InfoValue(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.gray, fontSize: 9)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _HealthMetric extends StatelessWidget {
  const _HealthMetric(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: AppColors.blue),
          const Spacer(),
          Text(
            label,
            style: const TextStyle(color: AppColors.gray, fontSize: 8),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthRecordTile extends StatelessWidget {
  const _HealthRecordTile({required this.record, required this.isLast});

  final HealthRecord record;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 57,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 18,
            child: Column(
              children: [
                Container(
                  width: 6,
                  height: 6,
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
          const SizedBox(width: 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.date,
                style: const TextStyle(
                  color: AppColors.blue,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                record.title,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                record.provider,
                style: const TextStyle(color: AppColors.gray, fontSize: 8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

abstract final class _ChildMetaStyle {
  static const textStyle = TextStyle(color: AppColors.gray, fontSize: 10);
}
