import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PeakFlowPage extends StatefulWidget {
  const PeakFlowPage({super.key});

  @override
  State<PeakFlowPage> createState() => _PeakFlowPageState();
}

class _PeakFlowPageState extends State<PeakFlowPage> {
  static const _personalBest = 160;
  final List<PeakFlowReading> _readings = [
    PeakFlowReading(
      value: 107,
      recordedAt: DateTime(2026, 9, 22, 19, 56),
      symptoms: ['Cough'],
      notes: 'Evening reading',
    ),
  ];
  bool _showGraph = true;
  DateTimeRange? _selectedRange;

  List<PeakFlowReading> get _visibleReadings {
    final range = _selectedRange;
    if (range == null) return _readings;
    return _readings
        .where(
          (reading) =>
              !reading.recordedAt.isBefore(range.start) &&
              !reading.recordedAt.isAfter(
                DateTime(
                  range.end.year,
                  range.end.month,
                  range.end.day,
                  23,
                  59,
                  59,
                ),
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final readings = _visibleReadings;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
      children: [
        const _PeakFlowIntro(),
        const SizedBox(height: 16),
        _DateRangeBar(
          selectedRange: _selectedRange,
          onRangeChanged: (range) => setState(() => _selectedRange = range),
        ),
        const SizedBox(height: 14),
        _ViewSwitch(
          showGraph: _showGraph,
          onChanged: (value) => setState(() => _showGraph = value),
        ),
        const SizedBox(height: 12),
        if (_showGraph)
          _GraphCard(readings: readings, personalBest: _personalBest)
        else
          _TimelineCard(readings: readings, personalBest: _personalBest),
        const SizedBox(height: 12),
        _SummaryGrid(readings: readings),
        const SizedBox(height: 18),
        const Text(
          'Reports',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Export your peak flow history for your healthcare provider.',
          style: TextStyle(color: AppColors.gray, fontSize: 12),
        ),
        const SizedBox(height: 12),
        _ReportButton(
          icon: Icons.picture_as_pdf_outlined,
          label: 'PDF Report',
          filled: true,
          onPressed: () =>
              _showMessage('PDF report export will be available soon.'),
        ),
        const SizedBox(height: 10),
        _ReportButton(
          icon: Icons.table_chart_outlined,
          label: 'CSV Report',
          onPressed: () =>
              _showMessage('CSV report export will be available soon.'),
        ),
        const SizedBox(height: 16),
        const _MedicalGuidance(),
        const SizedBox(height: 14),
        FilledButton.icon(
          onPressed: _openAddReading,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add reading'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.blue,
            foregroundColor: AppColors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }

  Future<void> _openAddReading() async {
    final reading = await showModalBottomSheet<PeakFlowReading>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      builder: (_) => const _AddReadingSheet(personalBest: _personalBest),
    );
    if (!mounted || reading == null) return;
    setState(() => _readings.insert(0, reading));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _PeakFlowIntro extends StatelessWidget {
  const _PeakFlowIntro();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Track your breathing',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Record your peak expiratory flow and spot changes early.',
          style: TextStyle(color: AppColors.gray, fontSize: 12),
        ),
        SizedBox(height: 12),
        _PersonalBestBanner(),
      ],
    );
  }
}

class _PersonalBestBanner extends StatelessWidget {
  const _PersonalBestBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.bluePale,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.blueBorder),
      ),
      child: const Row(
        children: [
          Icon(Icons.air_rounded, color: AppColors.blue, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(color: AppColors.gray, fontSize: 11),
                children: [
                  TextSpan(
                    text: 'Personal best 160 L/min\n',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(text: 'Green zone starts at 128 L/min.'),
                ],
              ),
            ),
          ),
          Icon(Icons.info_outline_rounded, color: AppColors.blue, size: 18),
        ],
      ),
    );
  }
}

class _DateRangeBar extends StatelessWidget {
  const _DateRangeBar({
    required this.selectedRange,
    required this.onRangeChanged,
  });

  final DateTimeRange? selectedRange;
  final ValueChanged<DateTimeRange?> onRangeChanged;

  @override
  Widget build(BuildContext context) {
    final isAll = selectedRange == null;
    return Row(
      children: [
        Expanded(
          child: _RangeButton(
            label: 'All',
            selected: isAll,
            onPressed: () => onRangeChanged(null),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _RangeButton(
            label: 'Last 7 days',
            selected: false,
            onPressed: () {
              final today = DateTime.now();
              onRangeChanged(
                DateTimeRange(
                  start: today.subtract(const Duration(days: 7)),
                  end: today,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        _RangeButton(
          label: 'Custom',
          selected: selectedRange != null,
          icon: Icons.calendar_today_outlined,
          onPressed: () async {
            final range = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              initialDateRange: selectedRange,
            );
            if (range != null) onRangeChanged(range);
          },
        ),
      ],
    );
  }
}

class _RangeButton extends StatelessWidget {
  const _RangeButton({
    required this.label,
    required this.selected,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 15),
      label: Text(label, overflow: TextOverflow.ellipsis),
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? AppColors.blue : AppColors.white,
        foregroundColor: selected ? AppColors.white : AppColors.ink,
        side: BorderSide(
          color: selected ? AppColors.blue : AppColors.borderBlue,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _ViewSwitch extends StatelessWidget {
  const _ViewSwitch({required this.showGraph, required this.onChanged});

  final bool showGraph;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<bool>(
      segments: const [
        ButtonSegment(
          value: true,
          icon: Icon(Icons.show_chart_rounded),
          label: Text('Graph'),
        ),
        ButtonSegment(
          value: false,
          icon: Icon(Icons.view_list_rounded),
          label: Text('Timeline'),
        ),
      ],
      selected: {showGraph},
      onSelectionChanged: (value) => onChanged(value.first),
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _GraphCard extends StatelessWidget {
  const _GraphCard({required this.readings, required this.personalBest});

  final List<PeakFlowReading> readings;
  final int personalBest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Peak flow trend',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                'L/min',
                style: TextStyle(color: AppColors.gray, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            width: double.infinity,
            child: CustomPaint(
              painter: _PeakFlowChartPainter(
                readings: readings,
                personalBest: personalBest,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 6,
            children: [
              _LegendDot(color: AppColors.green, label: 'Green zone'),
              _LegendDot(color: AppColors.yellow, label: 'Caution'),
              _LegendDot(color: AppColors.red, label: 'Action needed'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: AppColors.gray, fontSize: 9)),
      ],
    );
  }
}

class _PeakFlowChartPainter extends CustomPainter {
  const _PeakFlowChartPainter({
    required this.readings,
    required this.personalBest,
  });

  final List<PeakFlowReading> readings;
  final int personalBest;

  @override
  void paint(Canvas canvas, Size size) {
    const maxValue = 800.0;
    const left = 34.0;
    const bottom = 24.0;
    final chart = Rect.fromLTWH(
      left,
      8,
      size.width - left - 8,
      size.height - bottom - 8,
    );
    final gridPaint = Paint()
      ..color = AppColors.borderLight
      ..strokeWidth = 1;
    final zonePaint = Paint()..style = PaintingStyle.fill;
    final labels = const [0, 200, 400, 600, 800];

    final redTop =
        chart.bottom - chart.height * (personalBest * 0.5) / maxValue;
    final yellowTop =
        chart.bottom - chart.height * (personalBest * 0.8) / maxValue;
    zonePaint.color = AppColors.redSoft;
    canvas.drawRect(
      Rect.fromLTRB(chart.left, redTop, chart.right, chart.bottom),
      zonePaint,
    );
    zonePaint.color = AppColors.yellowSoft;
    canvas.drawRect(
      Rect.fromLTRB(chart.left, yellowTop, chart.right, redTop),
      zonePaint,
    );
    zonePaint.color = AppColors.greenPale;
    canvas.drawRect(
      Rect.fromLTRB(chart.left, chart.top, chart.right, yellowTop),
      zonePaint,
    );

    for (final value in labels) {
      final y = chart.bottom - value / maxValue * chart.height;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      _drawText(
        canvas,
        '$value',
        Offset(0, y - 7),
        const TextStyle(color: AppColors.gray, fontSize: 9),
      );
    }
    for (var index = 0; index < 5; index++) {
      final x = chart.left + index * chart.width / 4;
      canvas.drawLine(Offset(x, chart.top), Offset(x, chart.bottom), gridPaint);
    }

    if (readings.isEmpty) {
      _drawText(
        canvas,
        'Add a reading to see your trend',
        Offset(chart.left + 12, chart.center.dy - 8),
        const TextStyle(color: AppColors.gray, fontSize: 11),
      );
      return;
    }

    final linePaint = Paint()
      ..color = AppColors.blue
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final path = Path();
    final ordered = readings.reversed.toList();
    for (var index = 0; index < ordered.length; index++) {
      final x = ordered.length == 1
          ? chart.center.dx
          : chart.left + index * chart.width / (ordered.length - 1);
      final y =
          chart.bottom -
          (ordered[index].value / maxValue).clamp(0.0, 1.0) * chart.height;
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()..color = ordered[index].zone.color,
      );
    }
    canvas.drawPath(path, linePaint);
    final bestY = chart.bottom - personalBest / maxValue * chart.height;
    final bestPaint = Paint()
      ..color = AppColors.blue.withValues(alpha: 0.45)
      ..strokeWidth = 1.2;
    canvas.drawLine(
      Offset(chart.left, bestY),
      Offset(chart.right, bestY),
      bestPaint,
    );
    _drawText(
      canvas,
      'Personal best',
      Offset(chart.right - 72, bestY - 13),
      const TextStyle(color: AppColors.blue, fontSize: 8),
    );
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _PeakFlowChartPainter oldDelegate) =>
      oldDelegate.readings != readings ||
      oldDelegate.personalBest != personalBest;
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.readings, required this.personalBest});

  final List<PeakFlowReading> readings;
  final int personalBest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: readings.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'No readings for this period.',
                  style: TextStyle(color: AppColors.gray),
                ),
              ),
            )
          : Column(
              children: [
                for (var index = 0; index < readings.length; index++)
                  _ReadingTile(
                    reading: readings[index],
                    personalBest: personalBest,
                    isLast: index == readings.length - 1,
                  ),
              ],
            ),
    );
  }
}

class _ReadingTile extends StatelessWidget {
  const _ReadingTile({
    required this.reading,
    required this.personalBest,
    required this.isLast,
  });

  final PeakFlowReading reading;
  final int personalBest;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 18,
          height: 68,
          child: Column(
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  color: reading.zone.color,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 1, color: AppColors.borderBlue),
                ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDateTime(reading.recordedAt),
                        style: const TextStyle(
                          color: AppColors.gray,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${reading.value} L/min',
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (reading.notes.isNotEmpty)
                        Text(
                          reading.notes,
                          style: const TextStyle(
                            color: AppColors.gray,
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ),
                _ZoneBadge(zone: reading.zone),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ZoneBadge extends StatelessWidget {
  const _ZoneBadge({required this.zone});

  final PeakFlowZone zone;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: zone.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        child: Text(
          zone.label,
          style: TextStyle(
            color: zone.color,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.readings});

  final List<PeakFlowReading> readings;

  @override
  Widget build(BuildContext context) {
    final values = readings.map((reading) => reading.value).toList();
    final average = values.isEmpty
        ? 0
        : (values.reduce((a, b) => a + b) / values.length).round();
    final highest = values.isEmpty ? 0 : values.reduce((a, b) => a > b ? a : b);
    final lowest = values.isEmpty ? 0 : values.reduce((a, b) => a < b ? a : b);
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.45,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _SummaryCard('Average', '$average L/min'),
        _SummaryCard('Highest', '$highest L/min'),
        _SummaryCard('Lowest', '$lowest L/min'),
        _SummaryCard('Measurements', '${readings.length} times'),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.gray, fontSize: 11),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportButton extends StatelessWidget {
  const _ReportButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        backgroundColor: filled ? AppColors.blue : AppColors.white,
        foregroundColor: filled ? AppColors.white : AppColors.blue,
        side: BorderSide(color: filled ? AppColors.blue : AppColors.borderBlue),
        minimumSize: const Size.fromHeight(46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _MedicalGuidance extends StatelessWidget {
  const _MedicalGuidance();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
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
            size: 18,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Peak flow readings support asthma monitoring but do not replace medical advice. Follow your written asthma action plan and contact your care team if readings stay low.',
              style: TextStyle(
                color: AppColors.gray,
                fontSize: 10,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddReadingSheet extends StatefulWidget {
  const _AddReadingSheet({required this.personalBest});

  final int personalBest;

  @override
  State<_AddReadingSheet> createState() => _AddReadingSheetState();
}

class _AddReadingSheetState extends State<_AddReadingSheet> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _notesController = TextEditingController();
  final _dayNotesController = TextEditingController();
  DateTime _recordedAt = DateTime.now();
  final _selectedSymptoms = <String>{};
  int _meterValue = 0;
  static const _symptoms = [
    'Cough',
    'Cough at night',
    'Wheeze',
    'Shortness of breath',
    'Chest tightness',
    'Difficult breathing',
  ];

  @override
  void dispose() {
    _valueController.dispose();
    _notesController.dispose();
    _dayNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 18, 20, keyboardInset + 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Add Reading',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Enter the value shown on your peak flow meter.',
                style: TextStyle(color: AppColors.gray, fontSize: 12),
              ),
              const SizedBox(height: 16),
              _PeakFlowMeter(
                value: _meterValue,
                personalBest: widget.personalBest,
                onChanged: (value) {
                  setState(() {
                    _meterValue = value;
                    _valueController.text = value == 0 ? '' : value.toString();
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valueController,
                autofocus: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  final parsed = int.tryParse(value);
                  if (parsed != null &&
                      parsed >= 0 &&
                      parsed <= 800 &&
                      parsed != _meterValue) {
                    setState(() => _meterValue = parsed);
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Peak flow reading',
                  suffixText: 'L/min',
                  prefixIcon: Icon(Icons.air_rounded),
                ),
                validator: (value) {
                  final number = int.tryParse(value?.trim() ?? '');
                  return number == null || number < 20 || number > 800
                      ? 'Enter a value between 20 and 800'
                      : null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _DateTimeField(
                      label: 'Date',
                      value: _formatDate(_recordedAt),
                      icon: Icons.calendar_today_outlined,
                      onTap: _pickDate,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DateTimeField(
                      label: 'Time',
                      value: _formatTime(_recordedAt),
                      icon: Icons.schedule_outlined,
                      onTap: _pickTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Reading notes',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Optional note for this reading',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Symptoms of the day',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select any symptoms that apply.',
                style: TextStyle(color: AppColors.gray, fontSize: 11),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  for (final symptom in _symptoms)
                    FilterChip(
                      label: Text(symptom),
                      selected: _selectedSymptoms.contains(symptom),
                      onSelected: (selected) => setState(() {
                        if (selected) {
                          _selectedSymptoms.add(symptom);
                        } else {
                          _selectedSymptoms.remove(symptom);
                        }
                      }),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _dayNotesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Optional day notes',
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save reading'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: AppColors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: _recordedAt,
    );
    if (date != null) {
      setState(
        () => _recordedAt = DateTime(
          date.year,
          date.month,
          date.day,
          _recordedAt.hour,
          _recordedAt.minute,
        ),
      );
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_recordedAt),
    );
    if (time != null) {
      setState(
        () => _recordedAt = DateTime(
          _recordedAt.year,
          _recordedAt.month,
          _recordedAt.day,
          time.hour,
          time.minute,
        ),
      );
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      PeakFlowReading(
        value: int.parse(_valueController.text.trim()),
        recordedAt: _recordedAt,
        symptoms: _selectedSymptoms.toList(),
        notes: _notesController.text.trim().isEmpty
            ? _dayNotesController.text.trim()
            : _notesController.text.trim(),
      ),
    );
  }
}

class _PeakFlowMeter extends StatelessWidget {
  const _PeakFlowMeter({
    required this.value,
    required this.personalBest,
    required this.onChanged,
  });

  final int value;
  final int personalBest;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final zone = value == 0
        ? PeakFlowZone.amber
        : PeakFlowReading(
            value: value,
            recordedAt: DateTime.now(),
            symptoms: const [],
            notes: '',
          ).zone;
    return Column(
      children: [
        Text(
          '$value',
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 42,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Text(
          'L/min',
          style: TextStyle(color: AppColors.gray, fontSize: 14),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (details) {
              final next =
                  ((details.localPosition.dx / constraints.maxWidth) * 800)
                      .round()
                      .clamp(0, 800);
              onChanged(next);
            },
            onTapDown: (details) {
              final next =
                  ((details.localPosition.dx / constraints.maxWidth) * 800)
                      .round()
                      .clamp(0, 800);
              onChanged(next);
            },
            child: Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 17),
              decoration: BoxDecoration(
                color: AppColors.graySoft,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 80,
                        child: Container(color: AppColors.red),
                      ),
                      Expanded(
                        flex: 48,
                        child: Container(color: AppColors.orange),
                      ),
                      Expanded(
                        flex: 672,
                        child: Container(color: AppColors.green),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment(
                      (value / 800 * 2 - 1).clamp(-1.0, 1.0),
                      0,
                    ),
                    child: Container(
                      width: 24,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: AppColors.blueBorder, blurRadius: 5),
                        ],
                      ),
                      child: const Icon(
                        Icons.drag_handle_rounded,
                        color: AppColors.white,
                        size: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 9),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              zone.label,
              style: TextStyle(color: zone.color, fontWeight: FontWeight.w800),
            ),
            const SizedBox(width: 8),
            Text(
              'Maximum reading: $personalBest L/min',
              style: const TextStyle(color: AppColors.gray, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}

class _DateTimeField extends StatelessWidget {
  const _DateTimeField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Icon(icon, size: 18),
        ),
        child: Text(
          value,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

enum PeakFlowZone {
  red('Action needed', AppColors.red, AppColors.redSoft),
  amber('Caution', AppColors.orangeDark, AppColors.yellowSoft),
  green('Green zone', AppColors.green, AppColors.greenPale);

  const PeakFlowZone(this.label, this.color, this.background);

  final String label;
  final Color color;
  final Color background;
}

class PeakFlowReading {
  const PeakFlowReading({
    required this.value,
    required this.recordedAt,
    required this.symptoms,
    required this.notes,
  });

  final int value;
  final DateTime recordedAt;
  final List<String> symptoms;
  final String notes;

  PeakFlowZone get zone {
    if (value < 80) return PeakFlowZone.red;
    if (value < 128) return PeakFlowZone.amber;
    return PeakFlowZone.green;
  }
}

String _formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
String _formatTime(DateTime date) =>
    '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
String _formatDateTime(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')} ${_month(date.month)} ${date.year} · ${_formatTime(date)}';
String _month(int month) => const [
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
][month - 1];
