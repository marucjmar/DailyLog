import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class _TimelineContent extends StatelessWidget {
  const _TimelineContent({required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Wpisy z dnia '
          '${selectedDate.day.toString().padLeft(2, '0')}.'
          '${selectedDate.month.toString().padLeft(2, '0')}.'
          '${selectedDate.year}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        const Card(
          child: ListTile(
            leading: Icon(Icons.circle, size: 12),
            title: Text('Brak wpisów'),
            subtitle: Text('Kliknij przycisk +, aby dodać wpis.'),
          ),
        ),
      ],
    );
  }
}

class TimelinePage extends StatefulWidget {
  const TimelinePage({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.activityByDay,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final Map<DateTime, int> activityByDay;

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  static const double _itemWidth = 72;

  // Ile dni wstecz/w przód od kotwicy jest dostępne w poziomym pasku.
  // To tylko granice przewijania (dla scrollbara) — lista i tak jest
  // budowana leniwie, więc te liczby mogą być duże bez wpływu na wydajność.
  static const int _pastDaysLimit = 365 * 20; // ok. 20 lat wstecz
  static const int _futureDaysLimit = 3650; // spójne z showDatePicker

  final Key _centerKey = const ValueKey('timeline-forward-sliver');

  late final DateTime _anchorDate;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _anchorDate = DateTime(now.year, now.month, now.day);

    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate(animate: false);
    });
  }

  @override
  void didUpdateWidget(covariant TimelinePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_isSameDay(oldWidget.selectedDate, widget.selectedDate)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedDate();
      });
    }
  }

  /// Przesunięcie (dodatnie lub ujemne) w dniach względem kotwicy.
  int _indexForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return normalizedDate.difference(_anchorDate).inDays;
  }

  DateTime _dateForIndex(int index) {
    return _anchorDate.add(Duration(days: index));
  }

  Future<void> _scrollToSelectedDate({bool animate = true}) async {
    if (!_scrollController.hasClients) {
      return;
    }

    final index = _indexForDate(widget.selectedDate);

    if (index < -_pastDaysLimit || index > _futureDaysLimit) {
      // Data poza dostępnym zakresem przewijania paska — po prostu nie
      // przewijamy (wybrana data i tak jest ustawiona wyżej, w treści).
      return;
    }

    final screenWidth = MediaQuery.sizeOf(context).width;

    final targetOffset =
        index * _itemWidth - (screenWidth / 2) + (_itemWidth / 2);

    final minOffset = _scrollController.position.minScrollExtent;
    final maxOffset = _scrollController.position.maxScrollExtent;

    final offset = targetOffset.clamp(minOffset, maxOffset);

    if (animate) {
      await _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(offset);
    }
  }

  Future<void> _openCalendar() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 3650)),
      lastDate: today,
      helpText: 'Wybierz datę',
      cancelText: 'Anuluj',
      confirmText: 'Wybierz',
    );

    if (selectedDate == null) {
      return;
    }

    widget.onDateChanged(selectedDate);
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  String _weekdayName(DateTime date) {
    const weekdays = ['pon.', 'wt.', 'śr.', 'czw.', 'pt.', 'sob.', 'niedz.'];

    return weekdays[date.weekday - 1];
  }

  int _activityForDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);

    return widget.activityByDay[normalized] ?? 0;
  }

  String _monthName(DateTime date) {
    const months = [
      'stycznia',
      'lutego',
      'marca',
      'kwietnia',
      'maja',
      'czerwca',
      'lipca',
      'sierpnia',
      'września',
      'października',
      'listopada',
      'grudnia',
    ];

    return months[date.month - 1];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildDayItem(BuildContext context, DateTime date) {
    final isSelected = _isSameDay(date, widget.selectedDate);
    final isToday = _isSameDay(date, DateTime.now());
    final isFuture = date.isAfter(DateTime.now());
    final activity = _activityForDate(date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isFuture ? null : () => widget.onDateChanged(date),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primaryContainer
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isToday && !isSelected
                ? Border.all(color: Theme.of(context).colorScheme.primary)
                : null,
          ),
          child: Opacity(
            opacity: isFuture ? 0.35 : 1.0, // wizualnie wyszarza przyszłe dni
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _weekdayName(date),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${date.day}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : null,
                  ),
                ),
                const SizedBox(height: 5),
                ActivityIndicator(activity: activity, selected: isSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 1,
          color: Theme.of(context).colorScheme.surface,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${widget.selectedDate.day} '
                          '${_monthName(widget.selectedDate)} '
                          '${widget.selectedDate.year}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget.onDateChanged(DateTime.now());
                        },
                        tooltip: 'Dzisiaj',
                        icon: const Icon(Icons.today_outlined),
                      ),
                      IconButton(
                        onPressed: _openCalendar,
                        tooltip: 'Wybierz datę',
                        icon: const Icon(Icons.calendar_month_outlined),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 82,
                  child: CustomScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    center: _centerKey,
                    slivers: [
                      // Dni przed kotwicą (rosnąco w przeszłość).
                      SliverFixedExtentList(
                        itemExtent: _itemWidth,
                        delegate: SliverChildBuilderDelegate((context, i) {
                          final date = _anchorDate.subtract(
                            Duration(days: i + 1),
                          );
                          return _buildDayItem(context, date);
                        }, childCount: _pastDaysLimit),
                      ),
                      // Dni od kotwicy w przyszłość (włącznie z kotwicą).
                      SliverFixedExtentList(
                        key: _centerKey,
                        itemExtent: _itemWidth,
                        delegate: SliverChildBuilderDelegate((context, i) {
                          final date = _dateForIndex(i);
                          return _buildDayItem(context, date);
                        }, childCount: _futureDaysLimit + 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: _TimelineContent(selectedDate: widget.selectedDate)),
      ],
    );
  }
}

class ActivityIndicator extends StatelessWidget {
  const ActivityIndicator({
    super.key,
    required this.activity,
    this.selected = false,
  });

  final int activity;
  final bool selected;

  double get intensity {
    if (activity <= 0) {
      return 0;
    }

    const maximumActivity = 10;

    return (activity / maximumActivity).clamp(0.15, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (activity == 0) {
      return Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? colorScheme.onSecondary.withValues(alpha: 0.35)
                : colorScheme.outlineVariant,
          ),
        ),
      );
    }

    return Tooltip(
      message: 'Aktywność: $activity',
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected
              ? colorScheme.onPrimaryContainer.withValues(alpha: intensity)
              : colorScheme.primary.withValues(alpha: intensity),
        ),
      ),
    );
  }
}
