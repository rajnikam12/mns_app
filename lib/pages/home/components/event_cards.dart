import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mns_app/widgets/events.dart';
import 'package:mns_app/pages/home/components/event_detail_page.dart';
import 'package:shimmer/shimmer.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String imageUrl;
  final String? location;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.imageUrl,
    this.location,
  });

  bool get isCompleted => DateTime(
    dateTime.year,
    dateTime.month,
    dateTime.day,
  ).isBefore(DateTime.now());

  bool get isToday {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  bool get isUpcoming => dateTime.isAfter(DateTime.now());
}

class CustomShimmer extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const CustomShimmer({super.key, required this.child, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: enabled,
      child: child,
    );
  }
}

class EventsSlider extends StatefulWidget {
  final List<Event> events;

  const EventsSlider({super.key, required this.events});

  @override
  _EventsSliderState createState() => _EventsSliderState();
}

class _EventsSliderState extends State<EventsSlider> {
  final PageController _pageController = PageController(viewportFraction: 1);
  int _currentIndex = 0;

  late final List<Event> upcomingEvents;

  @override
  void initState() {
    super.initState();
    upcomingEvents = widget.events
        .where((e) => e.isUpcoming || e.isToday)
        .toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (upcomingEvents.isEmpty) {
      return const Center(
        child: Text(
          'No upcoming events',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: upcomingEvents.length,
            itemBuilder: (context, index) {
              final event = upcomingEvents[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: EventCard(
                  event: event,
                  onReadMore: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailPage(event: event),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class EventCard extends StatefulWidget {
  final Event event;
  final VoidCallback? onReadMore;

  const EventCard({super.key, required this.event, this.onReadMore});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color get _statusColor {
    if (widget.event.isCompleted) return Colors.grey.shade600;
    if (widget.event.isToday) return Colors.red.shade500;
    return Colors.green.shade500;
  }

  String get _statusText {
    if (widget.event.isCompleted) return 'Completed';
    if (widget.event.isToday) return 'Today';
    return 'Upcoming';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: GestureDetector(
          onTapDown: (_) => _animationController.forward(),
          onTapUp: (_) => _animationController.reverse(),
          onTapCancel: () => _animationController.reverse(),
          child: Container(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: theme.colorScheme.surface,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildEventImage(screenHeight),
                  _buildEventContent(theme, screenWidth),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventImage(double screenHeight) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: screenHeight * 0.25,
          child: Image.network(
            widget.event.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) {
                return child; // Image loaded, no shimmer
              }
              return CustomShimmer(
                enabled: true,
                child: Container(
                  width: double.infinity,
                  height: screenHeight * 0.25,
                  color: Colors.grey.shade300,
                ),
              );
            },
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey.shade100,
              child: Center(
                child: Icon(
                  Icons.event,
                  size: 48,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: screenHeight * 0.25,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(top: 16, left: 16, child: _statusChip()),
        Positioned(bottom: 16, right: 16, child: _dateChip()),
      ],
    );
  }

  Widget _statusChip() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: _statusColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: _statusColor.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Text(
      _statusText,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    ),
  );

  Widget _dateChip() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.95),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat('MMM').format(widget.event.dateTime).toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
        Text(
          DateFormat('dd').format(widget.event.dateTime),
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );

  Widget _buildEventContent(ThemeData theme, double screenWidth) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.event.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: screenWidth * 0.03),
          _buildEventDetails(screenWidth),
          SizedBox(height: screenWidth * 0.03),
          Text(
            widget.event.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: screenWidth * 0.035,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: screenWidth * 0.09),
          _buildReadMoreButton(screenWidth),
        ],
      ),
    );
  }

  Widget _buildEventDetails(double screenWidth) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: screenWidth * 0.04,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: screenWidth * 0.015),
            Expanded(
              child: Text(
                DateFormat(
                  'EEEE, MMMM d, y • h:mm a',
                ).format(widget.event.dateTime),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: screenWidth * 0.035,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (widget.event.location != null) ...[
          SizedBox(height: screenWidth * 0.015),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: screenWidth * 0.04,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: screenWidth * 0.015),
              Expanded(
                child: Text(
                  widget.event.location!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: screenWidth * 0.035,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildReadMoreButton(double screenWidth) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: widget.onReadMore,
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            child: Text(
              'Read More',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.035,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
