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
  static const int _daysBefore = 180;
  static const int _daysAfter = 180;

  late final ScrollController _scrollController;

  static const double _itemWidth = 72;

  @override
  void initState() {
    super.initState();

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

  DateTime get _startDate => DateTime(2020, 1, 1);

  DateTime get _endDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  int get _numberOfDays {
    return _endDate.difference(_startDate).inDays + 2;
  }

  DateTime _dateForIndex(int index) {
    return _startDate.add(Duration(days: index));
  }

  int _indexForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    return normalizedDate.difference(_startDate).inDays;
  }

  Future<void> _scrollToSelectedDate({bool animate = true}) async {
    if (!_scrollController.hasClients) {
      return;
    }

    final index = _indexForDate(widget.selectedDate);

    if (index < 0 || index >= _numberOfDays) {
      return;
    }

    final screenWidth = MediaQuery.sizeOf(context).width;

    final targetOffset =
        index * _itemWidth - (screenWidth / 2) + (_itemWidth / 2);

    final maxOffset = _scrollController.position.maxScrollExtent;

    final offset = targetOffset.clamp(0.0, maxOffset);

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
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 3650)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
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
    final normalized = DateTime(
      date.year,
      date.month,
      date.day,
    );

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
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: _numberOfDays,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemBuilder: (context, index) {
                      final date = _dateForIndex(index);

                      final isSelected = _isSameDay(date, widget.selectedDate);

                      final isToday = _isSameDay(date, DateTime.now());
                      final activity = _activityForDate(date);

                      return SizedBox(
                        width: _itemWidth,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 8,
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              widget.onDateChanged(date);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                border: isToday && !isSelected
                                    ? Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      )
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _weekdayName(date),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: isSelected
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.onPrimaryContainer
                                              : null,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${date.day}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.onPrimaryContainer
                                              : null,
                                        ),
                                  ),
                                  const SizedBox(height: 5),
                                  ActivityIndicator(
                                    activity: activity,
                                    selected: isSelected,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
                ? colorScheme.onSecondary.withValues(
                    alpha: 0.35,
                  )
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
              ? colorScheme.onPrimaryContainer.withValues(
                  alpha: intensity,
                )
              : colorScheme.primary.withValues(
                  alpha: intensity,
                ),
        ),
      ),
    );
  }
}