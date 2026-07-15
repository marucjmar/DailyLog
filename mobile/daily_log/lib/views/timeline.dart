import 'dart:async';
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
    required this.loadActivityCounts,
    this.initialActivityByDay = const {},
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  /// Dociąga liczby aktywności dla dni z zakresu [start, end] (włącznie).
  /// Wywoływane leniwie tylko dla dni, których nie ma jeszcze w cache.
  final Future<Map<DateTime, int>> Function(DateTime start, DateTime end)
      loadActivityCounts;

  /// Opcjonalny wstępny zestaw danych (np. dla dnia dzisiejszego),
  /// żeby uniknąć migotania przy starcie.
  final Map<DateTime, int> initialActivityByDay;

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  static const double _itemWidth = 72;

  static const int _pastDaysLimit = 365 * 20;
  static const int _futureDaysLimit = 0; // brak dni z przyszłości

  static const int _prefetchBufferDays = 10;
  static const Duration _scrollThrottle = Duration(milliseconds: 200);

  final Key _centerKey = const ValueKey('timeline-forward-sliver');

  late final DateTime _anchorDate;
  late final ScrollController _scrollController;

  final Map<DateTime, int> _activityCache = {};
  final Set<DateTime> _loadingDays = {};

  Timer? _scrollThrottleTimer;
  bool _isProgrammaticScroll = false;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _anchorDate = DateTime(now.year, now.month, now.day);

    _activityCache.addAll(
      widget.initialActivityByDay.map(
        (date, count) => MapEntry(_normalize(date), count),
      ),
    );

    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate(animate: false);
      _loadVisibleRange(); // wstępne dociągnięcie widocznego zakresu
    });
  }

  @override
  void didUpdateWidget(covariant TimelinePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  @override
  void dispose() {
    _scrollThrottleTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  int _indexForDate(DateTime date) {
    return _normalize(date).difference(_anchorDate).inDays;
  }

  DateTime _dateForIndex(int index) {
    return _anchorDate.add(Duration(days: index));
  }

  // ---------------------------------------------------------------
  // Leniwe ładowanie aktywności dla widocznego (+ bufor) zakresu dni.
  // ---------------------------------------------------------------

  void _onScroll() {
    _scrollThrottleTimer?.cancel();
    _scrollThrottleTimer = Timer(_scrollThrottle, _loadVisibleRange);
  }

  ({int start, int end})? _visibleIndexRange() {
    if (!_scrollController.hasClients) return null;

    final position = _scrollController.position;
    final viewportWidth = position.viewportDimension;

    if (viewportWidth == 0) return null;

    final firstVisible = (position.pixels / _itemWidth).floor();
    final lastVisible =
        ((position.pixels + viewportWidth) / _itemWidth).ceil();

    return (
      start: firstVisible - _prefetchBufferDays,
      end: lastVisible + _prefetchBufferDays,
    );
  }

  Future<void> _loadVisibleRange() async {
    final range = _visibleIndexRange();
    if (range == null) return;

    final clampedStart = range.start.clamp(-_pastDaysLimit, _futureDaysLimit);
    final clampedEnd = range.end.clamp(-_pastDaysLimit, _futureDaysLimit);

    final missingDates = <DateTime>[];

    for (var i = clampedStart; i <= clampedEnd; i++) {
      final date = _dateForIndex(i);
      if (!_activityCache.containsKey(date) && !_loadingDays.contains(date)) {
        missingDates.add(date);
      }
    }

    if (missingDates.isEmpty) return;

    missingDates.sort();
    final rangeStart = missingDates.first;
    final rangeEnd = missingDates.last;

    setState(() {
      _loadingDays.addAll(missingDates);
    });

    try {
      final result = await widget.loadActivityCounts(rangeStart, rangeEnd);

      if (!mounted) return;

      setState(() {
        for (final date in missingDates) {
          _loadingDays.remove(date);
          _activityCache[date] = result[date] ?? 0;
        }
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loadingDays.removeAll(missingDates);
      });
      // Nie ustawiamy wartości w cache — przy kolejnym przewinięciu
      // przez ten zakres próba zostanie powtórzona.
    }
  }

  // ---------------------------------------------------------------

  Future<void> _scrollToSelectedDate({bool animate = true}) async {
    if (!_scrollController.hasClients) return;

    final index = _indexForDate(widget.selectedDate);

    if (index < -_pastDaysLimit || index > _futureDaysLimit) return;

    final screenWidth = MediaQuery.sizeOf(context).width;

    final targetOffset =
        index * _itemWidth - (screenWidth / 2) + (_itemWidth / 2);

    final minOffset = _scrollController.position.minScrollExtent;
    final maxOffset = _scrollController.position.maxScrollExtent;

    final offset = targetOffset.clamp(minOffset, maxOffset);

    _isProgrammaticScroll = true;

    if (animate) {
      await _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(offset);
    }

    _isProgrammaticScroll = false;
    _loadVisibleRange();
  }

  Future<void> _openCalendar() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final selectedDate = await showDatePicker(
      context: context,
      initialDate:
          widget.selectedDate.isAfter(today) ? today : widget.selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 3650)),
      lastDate: today,
      helpText: 'Wybierz datę',
      cancelText: 'Anuluj',
      confirmText: 'Wybierz',
    );

    if (selectedDate == null) return;

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

  String _monthName(DateTime date) {
    const months = [
      'stycznia', 'lutego', 'marca', 'kwietnia', 'maja', 'czerwca',
      'lipca', 'sierpnia', 'września', 'października', 'listopada', 'grudnia',
    ];
    return months[date.month - 1];
  }

  Widget _buildDayItem(BuildContext context, DateTime date) {
    final isSelected = _isSameDay(date, widget.selectedDate);
    final isToday = _isSameDay(date, DateTime.now());
    final isFuture = date.isAfter(DateTime.now());

    final normalized = _normalize(date);
    final isLoadingActivity = _loadingDays.contains(normalized);
    final activity = _activityCache[normalized];

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
            opacity: isFuture ? 0.35 : 1.0,
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
                ActivityIndicator(
                  activity: activity,
                  isLoading: isLoadingActivity,
                  selected: isSelected,
                ),
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
                        onPressed: () => widget.onDateChanged(DateTime.now()),
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
                  child: NotificationListener<ScrollEndNotification>(
                    onNotification: (notification) {
                      if (!_isProgrammaticScroll) _loadVisibleRange();
                      return false;
                    },
                    child: CustomScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      center: _centerKey,
                      slivers: [
                        SliverFixedExtentList(
                          itemExtent: _itemWidth,
                          delegate: SliverChildBuilderDelegate(
                            (context, i) => _buildDayItem(
                              context,
                              _anchorDate.subtract(Duration(days: i + 1)),
                            ),
                            childCount: _pastDaysLimit,
                          ),
                        ),
                        SliverFixedExtentList(
                          key: _centerKey,
                          itemExtent: _itemWidth,
                          delegate: SliverChildBuilderDelegate(
                            (context, i) => _buildDayItem(
                              context,
                              _dateForIndex(i),
                            ),
                            childCount: _futureDaysLimit + 1,
                          ),
                        ),
                      ],
                    ),
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

class ActivityIndicator extends StatefulWidget {
  const ActivityIndicator({
    super.key,
    required this.activity,
    required this.isLoading,
    this.selected = false,
  });

  /// null = nieznane (jeszcze nie pobrane i nie w trakcie ładowania).
  final int? activity;
  final bool isLoading;
  final bool selected;

  double _intensity(int value) {
    if (value <= 0) return 0;
    const maximumActivity = 10;
    return (value / maximumActivity).clamp(0.15, 1.0);
  }

  @override
  State<ActivityIndicator> createState() => _ActivityIndicatorState();
}

class _ActivityIndicatorState extends State<ActivityIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Kropka w trakcie ładowania: subtelne pulsowanie, żeby odróżnić
    // "jeszcze nie wiemy" od "wiemy, że brak aktywności".
    if (widget.isLoading || widget.activity == null) {
      return AnimatedBuilder(
        animation: _pulseController,
        builder: (context, _) {
          final t = _pulseController.value; // 0..1
          final alpha = 0.15 + 0.25 * t;

          return Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (widget.selected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant)
                  .withValues(alpha: alpha),
            ),
          );
        },
      );
    }

    final activity = widget.activity!;

    if (activity == 0) {
      return Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.selected
                ? colorScheme.onSecondary.withValues(alpha: 0.35)
                : colorScheme.outlineVariant,
          ),
        ),
      );
    }

    final intensity = widget._intensity(activity);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      builder: (context, t, _) {
        return Tooltip(
          message: 'Aktywność: $activity',
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (widget.selected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.primary)
                  .withValues(alpha: intensity * t),
            ),
          ),
        );
      },
    );
  }
}