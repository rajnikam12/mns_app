import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<Announcement> announcements = [
    Announcement(
      id: '1',
      title: 'Rally at Shivaji Park Tomorrow',
      message:
          'Join MNS President Raj Thackeray for a massive rally at Shivaji Park on Sunday, 4:00 PM. Show your support for Maharashtra\'s development and the rights of Marathi Manoos.',
      type: AnnouncementType.rally,
      date: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
    ),
    Announcement(
      id: '2',
      title: 'MNS Stands with Local Vendors',
      message:
          'Our party strongly opposes illegal hawking permits. We demand immediate action from BMC to protect legitimate Marathi vendors and shopkeepers in Mumbai.',
      type: AnnouncementType.statement,
      date: DateTime.now().subtract(const Duration(hours: 8)),
      isRead: false,
    ),
    Announcement(
      id: '3',
      title: 'Blood Donation Camp - Dadar',
      message:
          'MNS Youth Wing organizes blood donation camp at Dadar on Saturday, 9:00 AM to 5:00 PM. Help save lives and serve Maharashtra. Registration mandatory.',
      type: AnnouncementType.social,
      date: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
    ),
    Announcement(
      id: '4',
      title: 'Employment Drive for Youth',
      message:
          'MNS Employment Cell announces job fair at Worli Sports Club on Monday. 500+ positions available for qualified Maharashtrian candidates in various sectors.',
      type: AnnouncementType.employment,
      date: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    Announcement(
      id: '5',
      title: 'Marathi Language Day Celebration',
      message:
          'Celebrate Marathi Bhasha Din with cultural programs across Mumbai. MNS organizes poetry recitation, folk dance, and essay competitions in all constituencies.',
      type: AnnouncementType.cultural,
      date: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
    Announcement(
      id: '6',
      title: 'Toll Tax Protest March',
      message:
          'MNS calls for peaceful protest against increased toll charges on Mumbai-Pune Expressway. Assemble at Kalamboli toll plaza on Friday, 10:00 AM.',
      type: AnnouncementType.protest,
      date: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unreadCount = announcements.where((a) => !a.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Announcements',
          style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        ),
        actions: [
          if (unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: TextButton.icon(
                onPressed: _markAllAsRead,
                icon: const Icon(Icons.done_all, size: 18),
                label: Text('Mark all read'),
                style: TextButton.styleFrom(foregroundColor: Colors.white),
              ),
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              if (unreadCount > 0) _buildUnreadHeader(unreadCount, theme),
              Expanded(
                child: announcements.isEmpty
                    ? _buildEmptyState(theme)
                    : _buildAnnouncementList(theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnreadHeader(int count, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.notifications_active,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            '$count unread announcement${count > 1 ? 's' : ''}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementList(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        final announcement = announcements[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _buildAnnouncementCard(announcement, theme),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAnnouncementCard(Announcement announcement, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, top: 16),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: announcement.isRead ? 1 : 3,
        shadowColor: theme.colorScheme.primary.withOpacity(0.1),
        child: InkWell(
          onTap: () => _toggleReadStatus(announcement),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: announcement.isRead
                  ? null
                  : Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      width: 1,
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAnnouncementIcon(announcement.type, theme),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  announcement.title,
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontSize: 18,
                                        fontWeight: announcement.isRead
                                            ? FontWeight.w600
                                            : FontWeight.w700,
                                      ),
                                ),
                              ),
                              if (!announcement.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDate(announcement.date),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  announcement.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: announcement.isRead
                        ? theme.colorScheme.onSurface.withOpacity(0.8)
                        : theme.colorScheme.onSurface,
                  ),
                ),
                if (announcement.type == AnnouncementType.rally ||
                    announcement.type == AnnouncementType.protest ||
                    announcement.type == AnnouncementType.employment) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _getTypeColor(
                        announcement.type,
                        theme,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getTypeSecondaryIcon(announcement.type),
                          size: 16,
                          color: _getTypeColor(announcement.type, theme),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _getTypeLabel(announcement.type),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _getTypeColor(announcement.type, theme),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementIcon(AnnouncementType type, ThemeData theme) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _getTypeColor(type, theme).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getTypeIcon(type),
        color: _getTypeColor(type, theme),
        size: 22,
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'No announcements',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for updates',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.rally:
        return Icons.campaign;
      case AnnouncementType.statement:
        return Icons.record_voice_over;
      case AnnouncementType.social:
        return Icons.volunteer_activism;
      case AnnouncementType.employment:
        return Icons.work;
      case AnnouncementType.cultural:
        return Icons.festival;
      case AnnouncementType.protest:
        return Icons.groups;
    }
  }

  IconData _getTypeSecondaryIcon(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.rally:
        return Icons.schedule;
      case AnnouncementType.protest:
        return Icons.location_on;
      case AnnouncementType.employment:
        return Icons.business_center;
      default:
        return Icons.info;
    }
  }

  Color _getTypeColor(AnnouncementType type, ThemeData theme) {
    switch (type) {
      case AnnouncementType.rally:
        return theme.colorScheme.primary; // MNS orange
      case AnnouncementType.statement:
        return theme.colorScheme.secondary; // Blue
      case AnnouncementType.social:
        return Colors.green;
      case AnnouncementType.employment:
        return Colors.purple;
      case AnnouncementType.cultural:
        return Colors.amber;
      case AnnouncementType.protest:
        return Colors.red;
    }
  }

  String _getTypeLabel(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.rally:
        return 'Rally';
      case AnnouncementType.statement:
        return 'Statement';
      case AnnouncementType.social:
        return 'Social Work';
      case AnnouncementType.employment:
        return 'Employment';
      case AnnouncementType.cultural:
        return 'Cultural';
      case AnnouncementType.protest:
        return 'Protest';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _toggleReadStatus(Announcement announcement) {
    HapticFeedback.lightImpact();
    setState(() {
      announcement.isRead = !announcement.isRead;
    });
  }

  void _markAllAsRead() {
    HapticFeedback.mediumImpact();
    setState(() {
      for (var announcement in announcements) {
        announcement.isRead = true;
      }
    });
  }
}

class Announcement {
  final String id;
  final String title;
  final String message;
  final AnnouncementType type;
  final DateTime date;
  bool isRead;

  Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.date,
    this.isRead = false,
  });
}

enum AnnouncementType {
  rally,
  statement,
  social,
  employment,
  cultural,
  protest,
}
