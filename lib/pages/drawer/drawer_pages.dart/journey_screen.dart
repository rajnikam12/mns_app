import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mns_app/services/theme.dart';

enum TimelineEventType {
  foundation,
  success,
  decline,
  movement,
  policy,
  crisis,
  achievement,
}

class TimelineItem {
  final String year;
  final String title;
  final String description;
  final String detailedDescription;
  final String imagePath;
  final TimelineEventType eventType;
  final List<String> keyPoints;

  const TimelineItem({
    required this.year,
    required this.title,
    required this.description,
    required this.detailedDescription,
    required this.imagePath,
    required this.eventType,
    this.keyPoints = const [],
  });

  Color getColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (eventType) {
      case TimelineEventType.foundation:
        return AppTheme.primaryColor;
      case TimelineEventType.success:
      case TimelineEventType.achievement:
        return AppTheme.accentColor;
      case TimelineEventType.decline:
      case TimelineEventType.crisis:
        return Colors.red;
      case TimelineEventType.movement:
      case TimelineEventType.policy:
        return AppTheme.accentColor;
    }
  }
}

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen>
    with TickerProviderStateMixin {
  Set<int> expandedItems = {};
  late AnimationController _staggerController;
  late AnimationController _floatingController;
  late ScrollController _scrollController;

  final List<TimelineItem> timelineItems = const [
    TimelineItem(
      year: '2006',
      title: 'Foundation of MNS',
      description: 'Raj Thackeray formed MNS after leaving Shiv Sena',
      detailedDescription:
          'The Maharashtra Navnirman Sena was founded on March 9, 2006, by Raj Thackeray after parting ways with Shiv Sena. It was established with a vision to promote the rights of the local Marathi people.',
      imagePath: 'https://via.placeholder.com/400x250/BC3208/FFFFFF?text=2006',
      eventType: TimelineEventType.foundation,
      keyPoints: ['March 9, 2006 - Official founding in Mumbai'],
    ),
    TimelineItem(
      year: '2008',
      title: 'Anti-North Indian Campaign',
      description: 'MNS launched an aggressive campaign against outsiders.',
      detailedDescription:
          'In 2008, the MNS began targeting North Indian migrants in Maharashtra, demanding job reservations for locals. This stirred huge controversy and multiple legal cases against Raj Thackeray.',
      imagePath: 'https://via.placeholder.com/400x250/0277BD/FFFFFF?text=2008',
      eventType: TimelineEventType.crisis,
      keyPoints: [
        'Protests in Mumbai & Pune',
        'Raj Thackeray arrested briefly',
      ],
    ),
    TimelineItem(
      year: '2009',
      title: 'First Major Electoral Success',
      description: 'Won 13 seats in Maharashtra Assembly elections.',
      detailedDescription:
          'MNS contested its first Maharashtra Assembly elections in 2009 and surprised everyone by winning 13 seats, especially in urban centers like Mumbai, Pune, and Nashik.',
      imagePath: 'https://via.placeholder.com/400x250/4CAF50/FFFFFF?text=2009',
      eventType: TimelineEventType.success,
      keyPoints: ['13 MLAs elected', 'Strong debut in Maharashtra politics'],
    ),
    TimelineItem(
      year: '2014',
      title: 'Decline of Influence',
      description: 'Failed to maintain electoral momentum.',
      detailedDescription:
          'In the 2014 Maharashtra Assembly elections, MNS failed to repeat its earlier success. The rise of BJP and Shiv Sena’s alliance weakened MNS significantly.',
      imagePath: 'https://via.placeholder.com/400x250/F44336/FFFFFF?text=2014',
      eventType: TimelineEventType.decline,
      keyPoints: ['Lost most seats', 'Party morale dropped'],
    ),
    TimelineItem(
      year: '2019',
      title: 'Shift in Ideology',
      description: 'Raj Thackeray shifted towards Hindutva politics.',
      detailedDescription:
          'Ahead of the 2019 elections, Raj Thackeray attempted to reposition MNS with a Hindutva agenda, even changing the party flag. However, this did not translate into electoral success.',
      imagePath: 'https://via.placeholder.com/400x250/673AB7/FFFFFF?text=2019',
      eventType: TimelineEventType.policy,
      keyPoints: ['New saffron flag adopted', 'Hindutva speeches'],
    ),
    TimelineItem(
      year: '2022',
      title: 'Hanuman Chalisa Row',
      description: 'MNS demanded loudspeakers be removed from mosques.',
      detailedDescription:
          'In 2022, Raj Thackeray reignited political debates by demanding that loudspeakers on mosques be taken down. This move aimed to consolidate the Hindutva voter base.',
      imagePath: 'https://via.placeholder.com/400x250/FF9800/FFFFFF?text=2022',
      eventType: TimelineEventType.movement,
      keyPoints: ['Gained media attention', 'Mixed political reactions'],
    ),
    TimelineItem(
      year: '2024',
      title: 'Rebuilding Phase',
      description: 'MNS focuses on rebuilding party structure.',
      detailedDescription:
          'By 2024, MNS continues efforts to rebuild its organizational structure and grassroots connect, though its electoral impact remains limited compared to major parties.',
      imagePath: 'https://via.placeholder.com/400x250/2196F3/FFFFFF?text=2024',
      eventType: TimelineEventType.achievement,
      keyPoints: ['Reorganization underway', 'Raj Thackeray active again'],
    ),
  ];

  // add more items here...

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scrollController = ScrollController();

    _staggerController.forward();
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _floatingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleExpansion(int index) {
    HapticFeedback.mediumImpact();
    setState(() {
      if (expandedItems.contains(index)) {
        expandedItems.remove(index);
      } else {
        expandedItems.clear();
        expandedItems.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final delay = index * 150.0;
                return AnimatedBuilder(
                  animation: _staggerController,
                  builder: (context, child) {
                    final slideAnimation =
                        Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _staggerController,
                            curve: Interval(
                              (delay / 1200).clamp(0.0, 1.0),
                              ((delay + 300) / 1200).clamp(0.0, 1.0),
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                        );

                    final fadeAnimation = Tween<double>(begin: 0, end: 1)
                        .animate(
                          CurvedAnimation(
                            parent: _staggerController,
                            curve: Interval(
                              (delay / 1200).clamp(0.0, 1.0),
                              ((delay + 200) / 1200).clamp(0.0, 1.0),
                            ),
                          ),
                        );

                    return SlideTransition(
                      position: slideAnimation,
                      child: FadeTransition(
                        opacity: fadeAnimation,
                        child: _buildTimelineItem(
                          context,
                          timelineItems[index],
                          index,
                          index == timelineItems.length - 1,
                        ),
                      ),
                    );
                  },
                );
              }, childCount: timelineItems.length),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: 120,
      floating: true,
      pinned: false,
      elevation: 2,
      backgroundColor: Theme.of(context).colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Theme.of(context).colorScheme.primary,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.timeline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'MNS Political Journey',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(color: Colors.white, fontSize: 22),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '2006 - 2024 • 18 Years',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    TimelineItem item,
    int index,
    bool isLast,
  ) {
    final isExpanded = expandedItems.contains(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 60,
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _floatingController,
                    builder: (context, child) {
                      final floatingOffset =
                          math.sin(
                            _floatingController.value * 2 * math.pi +
                                index * 0.5,
                          ) *
                          2;

                      return Transform.translate(
                        offset: Offset(0, floatingOffset),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: item.getColor(context),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            item.year,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      );
                    },
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 3,
                        margin: const EdgeInsets.only(top: 8),
                        color: item.getColor(context).withOpacity(0.6),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: _buildTimelineCard(context, item, index, isExpanded),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineCard(
    BuildContext context,
    TimelineItem item,
    int index,
    bool isExpanded,
  ) {
    return GestureDetector(
      onTap: () => _toggleExpansion(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
          border: Border.all(
            color: isExpanded
                ? item.getColor(context).withOpacity(0.3)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (isExpanded) ...[
              const SizedBox(height: 16),
              _buildExpandedContent(context, item),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context, TimelineItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        AspectRatio(
          aspectRatio: 16 / 10,
          child: Image.network(item.imagePath, fit: BoxFit.cover),
        ),
        const SizedBox(height: 12),
        Text(
          item.detailedDescription,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        final scale =
            1 + math.sin(_floatingController.value * 2 * math.pi) * 0.05;

        return Transform.scale(
          scale: scale,
          child: FloatingActionButton(
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOutCubic,
              );
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(
              Icons.keyboard_arrow_up_rounded,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
