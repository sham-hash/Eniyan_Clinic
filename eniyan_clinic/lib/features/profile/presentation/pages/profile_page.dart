import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../profile_data.dart';
import 'child_profile_page.dart';
import 'profile_detail_pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final List<ChildProfile> _children = [...profileChildren];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 28),
      children: [
        const _ParentSummary(),
        const SizedBox(height: 34),
        Row(
          children: [
            const Expanded(
              child: Text(
                'My Child',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () => _showAddChildSheet(context),
              icon: const Icon(Icons.add_rounded, size: 17),
              label: const Text('Add child'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.blue,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (var index = 0; index < _children.length; index++) ...[
          _ChildSummary(
            child: _children[index],
            onTap: () => _openChildProfile(context, _children[index]),
          ),
          if (index < _children.length - 1) const SizedBox(height: 8),
        ],
        const SizedBox(height: 16),
        _ProfileMenu(onSelected: (label) => _openMenu(context, label)),
      ],
    );
  }

  void _openChildProfile(BuildContext context, ChildProfile child) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ChildProfilePage(child: child)),
    );
  }

  void _openMenu(BuildContext context, String label) {
    final Widget page = switch (label) {
      'Personal Information' => const PersonalInformationPage(),
      'Child Information' => ChildInformationPage(children: _children),
      'Health Records' => HealthRecordsPage(children: _children),
      'Growth & Development' => GrowthDevelopmentSelectionPage(
        children: _children,
      ),
      'Notifications' => const NotificationsPage(),
      'Privacy' => const PrivacyPage(),
      'Help & Support' => const HelpSupportPage(),
      'Terms & Conditions' => const TermsPage(),
      _ => const PersonalInformationPage(),
    };
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  Future<void> _showAddChildSheet(BuildContext context) async {
    final childDraft = await showModalBottomSheet<_ChildDraft>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      builder: (_) => const _AddChildSheet(),
    );
    if (!mounted || childDraft == null) return;
    setState(() {
      _children.add(
        ChildProfile(
          name: childDraft.name,
          dateOfBirth: childDraft.dateOfBirth,
          age: childDraft.age,
          gender: childDraft.gender,
          bloodGroup: childDraft.bloodGroup,
          height: '${childDraft.height}cm',
          weight: '${childDraft.weight}kg',
          lastUpdated: childDraft.lastUpdated,
          records: const [],
        ),
      );
    });
  }
}

class _AddChildSheet extends StatefulWidget {
  const _AddChildSheet();

  @override
  State<_AddChildSheet> createState() => _AddChildSheetState();
}

class _AddChildSheetState extends State<_AddChildSheet> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _dateOfBirth;
  String? _dateError;
  String? _gender;
  String? _bloodGroup;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 20, 20, keyboardInset + 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Child',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Add a child profile to manage their care in one place.',
                style: TextStyle(color: AppColors.gray, fontSize: 12),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Child name',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter the child name'
                    : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _DateField(
                      onTap: _pickDate,
                      date: _dateOfBirth,
                      errorText: _dateError,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        suffixText: 'years',
                      ),
                      validator: _requiredNumber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _gender,
                      decoration: const InputDecoration(labelText: 'Gender'),
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(
                          value: 'Female',
                          child: Text('Female'),
                        ),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (value) => setState(() => _gender = value),
                      validator: (value) =>
                          value == null ? 'Select gender' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _bloodGroup,
                      decoration: const InputDecoration(
                        labelText: 'Blood group',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'A+', child: Text('A+')),
                        DropdownMenuItem(value: 'A-', child: Text('A-')),
                        DropdownMenuItem(value: 'B+', child: Text('B+')),
                        DropdownMenuItem(value: 'B-', child: Text('B-')),
                        DropdownMenuItem(value: 'AB+', child: Text('AB+')),
                        DropdownMenuItem(value: 'AB-', child: Text('AB-')),
                        DropdownMenuItem(value: 'O+', child: Text('O+')),
                        DropdownMenuItem(value: 'O-', child: Text('O-')),
                      ],
                      onChanged: (value) => setState(() => _bloodGroup = value),
                      validator: (value) =>
                          value == null ? 'Select group' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Height',
                        suffixText: 'cm',
                      ),
                      validator: _requiredNumber,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Weight',
                        suffixText: 'kg',
                      ),
                      validator: _requiredNumber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: const Text('Add child'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_dateOfBirth == null) {
      setState(() => _dateError = 'Select date');
      return;
    }
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(
        _ChildDraft(
          name: _nameController.text.trim(),
          dateOfBirth: _formatDate(_dateOfBirth!),
          age: '${_ageController.text.trim()} Years',
          gender: _gender!,
          bloodGroup: _bloodGroup!,
          height: _heightController.text.trim(),
          weight: _weightController.text.trim(),
          lastUpdated: _formatDate(DateTime.now()),
        ),
      );
    }
  }

  String? _requiredNumber(String? value) {
    final number = double.tryParse(value?.trim() ?? '');
    return number == null || number <= 0 ? 'Enter a valid value' : null;
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(DateTime.now().year - 5),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: 'Select date of birth',
    );
    if (selected != null) {
      setState(() {
        _dateOfBirth = selected;
        _dateError = null;
      });
    }
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.onTap, required this.date, this.errorText});

  final VoidCallback onTap;
  final DateTime? date;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of birth',
          suffixIcon: const Icon(Icons.calendar_today_outlined),
          errorText: errorText,
        ),
        child: Text(
          date == null ? 'Select date' : _formatDate(date!),
          style: TextStyle(
            color: date == null ? AppColors.gray : AppColors.ink,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _ChildDraft {
  const _ChildDraft({
    required this.name,
    required this.dateOfBirth,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.lastUpdated,
  });

  final String name;
  final String dateOfBirth;
  final String age;
  final String gender;
  final String bloodGroup;
  final String height;
  final String weight;
  final String lastUpdated;
}

String _formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
}

class _ParentSummary extends StatelessWidget {
  const _ParentSummary();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          currentParent.initials,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentParent.name,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            const Text('Parent', style: _ProfileMetaStyle.textStyle),
            const SizedBox(height: 6),
            _ContactLine(Icons.phone_outlined, currentParent.phone),
            const SizedBox(height: 3),
            _ContactLine(Icons.mail_outline_rounded, currentParent.email),
          ],
        ),
      ),
    ],
  );
}

class _ContactLine extends StatelessWidget {
  const _ContactLine(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 13, color: AppColors.gray),
      const SizedBox(width: 5),
      Flexible(child: Text(label, style: _ProfileMetaStyle.textStyle)),
    ],
  );
}

class _ChildSummary extends StatelessWidget {
  const _ChildSummary({required this.child, required this.onTap});

  final ChildProfile child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(15),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.yellowSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.face_rounded,
                color: AppColors.yellow,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.name,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${child.age} · ${child.gender}',
                    style: _ProfileMetaStyle.textStyle,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.ink,
              size: 21,
            ),
          ],
        ),
      ),
    ),
  );
}

class _ProfileMenu extends StatelessWidget {
  const _ProfileMenu({required this.onSelected});

  final ValueChanged<String> onSelected;

  static const _items = [
    _ProfileMenuItem(
      'Personal Information',
      Icons.person_outline_rounded,
      AppColors.softBlue,
      AppColors.blue,
    ),
    _ProfileMenuItem(
      'Child Information',
      Icons.person_outline_rounded,
      AppColors.softGreen,
      AppColors.green,
    ),
    _ProfileMenuItem(
      'Health Records',
      Icons.person_outline_rounded,
      AppColors.purpleSoft,
      AppColors.purple,
    ),
    _ProfileMenuItem(
      'Growth & Development',
      Icons.show_chart_rounded,
      AppColors.orangeSoft,
      AppColors.orangeDark,
    ),
    _ProfileMenuItem(
      'Notifications',
      Icons.notifications_none_rounded,
      AppColors.softBlue,
      AppColors.blue,
    ),
    _ProfileMenuItem(
      'Privacy',
      Icons.lock_outline_rounded,
      AppColors.softGreen,
      AppColors.green,
    ),
    _ProfileMenuItem(
      'Help & Support',
      Icons.help_outline_rounded,
      AppColors.purpleSoft,
      AppColors.purple,
    ),
    _ProfileMenuItem(
      'Terms & Conditions',
      Icons.description_outlined,
      AppColors.orangeSoft,
      AppColors.orangeDark,
    ),
  ];

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: [
        for (var index = 0; index < _items.length; index++) ...[
          _ProfileMenuRow(
            item: _items[index],
            onTap: () => onSelected(_items[index].label),
          ),
          if (index < _items.length - 1)
            const Divider(height: 1, indent: 58, color: AppColors.borderLight),
        ],
      ],
    ),
  );
}

class _ProfileMenuRow extends StatelessWidget {
  const _ProfileMenuRow({required this.item, required this.onTap});

  final _ProfileMenuItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: SizedBox(
      height: 56,
      child: Row(
        children: [
          const SizedBox(width: 10),
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: item.backgroundColor,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(item.icon, size: 18, color: item.iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              item.label,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.ink,
            size: 21,
          ),
          const SizedBox(width: 10),
        ],
      ),
    ),
  );
}

class _ProfileMenuItem {
  const _ProfileMenuItem(
    this.label,
    this.icon,
    this.backgroundColor,
    this.iconColor,
  );

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
}

abstract final class _ProfileMetaStyle {
  static const textStyle = TextStyle(color: AppColors.gray, fontSize: 10);
}
