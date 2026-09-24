import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/clinic_app_bar.dart';
import '../profile_data.dart';
import '../notification_navigation.dart';

class GrowthDevelopmentPage extends StatefulWidget {
  const GrowthDevelopmentPage({super.key, required this.child});

  final ChildProfile child;

  @override
  State<GrowthDevelopmentPage> createState() => _GrowthDevelopmentPageState();
}

class _GrowthDevelopmentPageState extends State<GrowthDevelopmentPage> {
  bool _showExplanation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const _GrowthAppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(19, 20, 19, 28),
        children: [
          const Text(
            "Monitor your child's growth over time.",
            style: TextStyle(color: AppColors.gray, fontSize: 11),
          ),
          const SizedBox(height: 14),
          _GrowthMetrics(child: widget.child),
          const SizedBox(height: 13),
          _ChartCard(child: widget.child),
          const SizedBox(height: 11),
          _ExplanationCard(
            isExpanded: _showExplanation,
            onToggle: () =>
                setState(() => _showExplanation = !_showExplanation),
          ),
          const SizedBox(height: 11),
          const _MedicalReminder(),
        ],
      ),
    );
  }
}

class _GrowthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _GrowthAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    return ClinicHeader(
      title: 'Growth & Development',
      showBackButton: true,
      onBack: () => Navigator.of(context).pop(),
      onNotificationTap: () => openNotifications(context),
      onProfileTap: () => openProfile(context),
    );
  }
}

class _GrowthMetrics extends StatelessWidget {
  const _GrowthMetrics({required this.child});

  final ChildProfile child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _MetricCard('Height', child.height)),
        SizedBox(width: 6),
        Expanded(child: _MetricCard('Weight', child.weight)),
        SizedBox(width: 6),
        Expanded(child: _MetricCard('Last Updated', child.lastUpdated)),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.fromLTRB(8, 9, 6, 7),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.gray, fontSize: 8),
          ),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.child});

  final ChildProfile child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 14, 10, 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Growth Chart',
                  style: TextStyle(color: AppColors.ink, fontSize: 14),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.blue,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Search'),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Semantics(
            label: 'Growth chart showing height and weight progress',
            child: Container(
              height: 266,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFAFBFD),
                border: Border.all(color: AppColors.borderLight),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const CustomPaint(painter: _GrowthChartPainter()),
            ),
          ),
          const SizedBox(height: 7),
          const Center(
            child: Text(
              'IAP Girls Height and Weight Chart 5-18 Years',
              style: TextStyle(color: AppColors.gray, fontSize: 8),
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthChartPainter extends CustomPainter {
  const _GrowthChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.borderLight
      ..strokeWidth = 1;
    final labelStyle = const TextStyle(
      color: AppColors.textSecondary,
      fontSize: 9,
    );

    for (var index = 1; index < 5; index++) {
      final y = size.height * index / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    for (var index = 1; index < 6; index++) {
      final x = size.width * index / 6;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    final heightLine = Paint()
      ..color = AppColors.blue
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final weightLine = Paint()
      ..color = AppColors.green
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final heightPath = Path()..moveTo(0, size.height * .78);
    heightPath.cubicTo(
      size.width * .2,
      size.height * .7,
      size.width * .42,
      size.height * .54,
      size.width * .68,
      size.height * .37,
    );
    heightPath.cubicTo(
      size.width * .8,
      size.height * .3,
      size.width * .9,
      size.height * .23,
      size.width,
      size.height * .16,
    );
    canvas.drawPath(heightPath, heightLine);

    final weightPath = Path()..moveTo(0, size.height * .68);
    weightPath.cubicTo(
      size.width * .2,
      size.height * .65,
      size.width * .43,
      size.height * .57,
      size.width * .68,
      size.height * .44,
    );
    weightPath.cubicTo(
      size.width * .82,
      size.height * .37,
      size.width * .91,
      size.height * .34,
      size.width,
      size.height * .27,
    );
    canvas.drawPath(weightPath, weightLine);

    _drawLabel(canvas, 'Height', Offset(8, 8), labelStyle, AppColors.blue);
    _drawLabel(canvas, 'Weight', Offset(8, 24), labelStyle, AppColors.green);
  }

  void _drawLabel(
    Canvas canvas,
    String text,
    Offset offset,
    TextStyle style,
    Color color,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: style.copyWith(color: color),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ExplanationCard extends StatelessWidget {
  const _ExplanationCard({required this.isExpanded, required this.onToggle});

  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.menu_book_outlined,
                    color: AppColors.ink,
                    size: 17,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Understanding the Chart',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.ink,
                    size: 20,
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 10),
                const Text(
                  'The lines show how your child compares with children of the same age. Trends over time are more useful than a single measurement.',
                  style: TextStyle(
                    color: AppColors.gray,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MedicalReminder extends StatelessWidget {
  const _MedicalReminder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.yellowSoft,
        borderRadius: BorderRadius.circular(13),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.orangeDark,
            size: 14,
          ),
          SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A gentle reminder',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "This chart is a guide, not a diagnosis. Your child's doctor will always consider their complete health and family history.",
                  style: TextStyle(
                    color: AppColors.gray,
                    fontSize: 9,
                    height: 1.3,
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
