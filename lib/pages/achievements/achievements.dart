import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Achievement> achievements = [
    Achievement(
      id: '1',
      title: 'Marathi Language Campaign Success',
      description:
          'Successfully implemented Marathi language mandatory policy in Maharashtra schools and colleges. This initiative has strengthened our cultural roots and provided better opportunities for Marathi-speaking students across the state.',
      images: [
        'assets/marathi_1.jpg',
        'assets/marathi_2.jpg',
        'assets/marathi_3.jpg',
        'assets/marathi_4.jpg',
      ],
    ),
    Achievement(
      id: '2',
      title: 'Employment Drive for Local Youth',
      description:
          'Organized multiple job fairs and employment drives across Mumbai and Maharashtra. Connected thousands of local youth with employment opportunities in various sectors including IT, manufacturing, and services.',
      images: [
        'assets/employment_1.jpg',
        'assets/employment_2.jpg',
        'assets/employment_3.jpg',
      ],
    ),
    Achievement(
      id: '3',
      title: 'Toll Tax Reduction Victory',
      description:
          'Led successful protests and negotiations that resulted in significant toll tax reductions on major highways. This achievement has saved crores of rupees for daily commuters and transport operators.',
      images: [
        'assets/toll_1.jpg',
        'assets/toll_2.jpg',
        'assets/toll_3.jpg',
        'assets/toll_4.jpg',
        'assets/toll_5.jpg',
      ],
    ),
    Achievement(
      id: '4',
      title: 'Street Vendor Rights Protection',
      description:
          'Fought for and secured rights of legitimate street vendors across Mumbai. Established proper licensing system and protected vendors from harassment while ensuring cleaner and organized street vending.',
      images: ['assets/vendor_1.jpg', 'assets/vendor_2.jpg'],
    ),
    Achievement(
      id: '5',
      title: 'Youth Sports Development Program',
      description:
          'Launched comprehensive sports development programs across Maharashtra. Built new sports facilities, provided equipment, and arranged coaching for underprivileged youth in cricket, football, and traditional sports.',
      images: [
        'assets/sports_1.jpg',
        'assets/sports_2.jpg',
        'assets/sports_3.jpg',
        'assets/sports_4.jpg',
        'assets/sports_5.jpg',
        'assets/sports_6.jpg',
      ],
    ),
    Achievement(
      id: '6',
      title: 'Housing Rights for Slum Dwellers',
      description:
          'Successfully negotiated with government authorities to secure housing rights for slum dwellers in Mumbai. Ensured rehabilitation without displacement from their original localities and provided dignified housing solutions.',
      images: [
        'assets/housing_1.jpg',
        'assets/housing_2.jpg',
        'assets/housing_3.jpg',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: achievements.isEmpty
            ? _buildEmptyState(theme)
            : _buildAchievementsList(theme),
      ),
    );
  }

  Widget _buildAchievementsList(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _buildAchievementCard(achievement, theme),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: theme.colorScheme.primary.withOpacity(0.1),
        child: InkWell(
          onTap: () => _openAchievementDetail(achievement),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Images Section
              Container(
                height: 200,
                child: _buildImageCarousel(achievement.images, theme),
              ),
              // Content Section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achievement.title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      achievement.description,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${achievement.images.length} Photos',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'View Details',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel(List<String> images, ThemeData theme) {
    if (images.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Center(
          child: Icon(
            Icons.image,
            size: 60,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.3),
                      theme.colorScheme.secondary.withOpacity(0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_camera,
                        size: 40,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Image ${index + 1}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (images.length > 1)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '1/${images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 80,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'No Achievements Yet',
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

  void _openAchievementDetail(Achievement achievement) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AchievementDetailScreen(achievement: achievement),
      ),
    );
  }
}

class AchievementDetailScreen extends StatefulWidget {
  final Achievement achievement;

  const AchievementDetailScreen({Key? key, required this.achievement})
    : super(key: key);

  @override
  State<AchievementDetailScreen> createState() =>
      _AchievementDetailScreenState();
}

class _AchievementDetailScreenState extends State<AchievementDetailScreen> {
  PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Achievement Details'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery Section
            Container(height: 300, child: _buildImageGallery(theme)),
            // Content Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.achievement.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${widget.achievement.images.length} Photos',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Description',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.achievement.description,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Photo Gallery',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildImageThumbnails(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery(ThemeData theme) {
    if (widget.achievement.images.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
        ),
        child: Center(
          child: Icon(
            Icons.image,
            size: 80,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
        ),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemCount: widget.achievement.images.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.4),
                    theme.colorScheme.secondary.withOpacity(0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_camera,
                      size: 60,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Image ${index + 1}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.achievement.images[index].split('/').last,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // Image Counter
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${_currentImageIndex + 1}/${widget.achievement.images.length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        // Navigation Arrows
        if (widget.achievement.images.length > 1) ...[
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: _currentImageIndex > 0
                    ? () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white.withOpacity(
                    _currentImageIndex > 0 ? 0.8 : 0.3,
                  ),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed:
                    _currentImageIndex < widget.achievement.images.length - 1
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(
                    _currentImageIndex < widget.achievement.images.length - 1
                        ? 0.8
                        : 0.3,
                  ),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImageThumbnails(ThemeData theme) {
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.achievement.images.length,
        itemBuilder: (context, index) {
          final isSelected = index == _currentImageIndex;
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  width: 2,
                ),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(
                      isSelected ? 0.5 : 0.2,
                    ),
                    theme.colorScheme.secondary.withOpacity(
                      isSelected ? 0.5 : 0.2,
                    ),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo,
                      color: Colors.white.withOpacity(0.8),
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final List<String> images;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
  });
}
