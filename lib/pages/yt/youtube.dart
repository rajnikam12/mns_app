import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Add this to pubspec.yaml: url_launcher: ^6.2.2

class VideosScreen extends StatefulWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<VideoItem> videos = [
    VideoItem(
      id: '1',
      title: 'Raj Thackeray Speech - Marathi Language Pride',
      youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      description:
          'Powerful speech by MNS Chief Raj Thackeray on the importance of Marathi language and culture in Maharashtra.',
      duration: '15:30',
      views: '2.3M',
      uploadDate: DateTime(2024, 8, 15),
    ),
    VideoItem(
      id: '2',
      title: 'Mumbai Local Train Rally - Commuter Rights',
      youtubeUrl: 'https://www.youtube.com/watch?v=jNQXAC9IVRw',
      description:
          'MNS organizing rally for better local train facilities and commuter rights in Mumbai.',
      duration: '8:45',
      views: '856K',
      uploadDate: DateTime(2024, 7, 20),
    ),
    VideoItem(
      id: '3',
      title: 'Employment Fair 2024 - Youth Development',
      youtubeUrl: 'https://www.youtube.com/watch?v=9bZkp7q19f0',
      description:
          'Coverage of the massive employment fair organized by MNS for Maharashtrian youth.',
      duration: '12:20',
      views: '1.2M',
      uploadDate: DateTime(2024, 6, 10),
    ),
    VideoItem(
      id: '4',
      title: 'Street Vendor Rights - Success Story',
      youtubeUrl: 'https://www.youtube.com/watch?v=ScMzIvxBSi4',
      description:
          'How MNS successfully fought for street vendor rights and created a better system for legitimate vendors.',
      duration: '6:15',
      views: '645K',
      uploadDate: DateTime(2024, 5, 5),
    ),
    VideoItem(
      id: '5',
      title: 'Marathi Bhasha Din Celebration 2024',
      youtubeUrl: 'https://www.youtube.com/watch?v=kXYiU_JCYtU',
      description:
          'Grand celebration of Marathi Language Day with cultural programs across Maharashtra.',
      duration: '22:10',
      views: '3.1M',
      uploadDate: DateTime(2024, 2, 27),
    ),
    VideoItem(
      id: '6',
      title: 'Anti-Toll Tax Protest - Victory March',
      youtubeUrl: 'https://www.youtube.com/watch?v=M7lc1UVf-VE',
      description:
          'Massive protest march against excessive toll taxes on Mumbai-Pune expressway.',
      duration: '18:35',
      views: '1.8M',
      uploadDate: DateTime(2024, 4, 12),
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
      appBar: AppBar(title: const Text('Videos')),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: videos.isEmpty
            ? _buildEmptyState(theme)
            : _buildVideosList(theme),
      ),
    );
  }

  Widget _buildVideosList(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _buildVideoCard(video, theme),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVideoCard(VideoItem video, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: 3,
        shadowColor: theme.colorScheme.primary.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Thumbnail Section
            Container(
              height: 220,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: _buildVideoThumbnail(video, theme),
              ),
            ),
            // Video Info Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    video.description,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        video.duration,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.visibility,
                        size: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${video.views} views',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(video.uploadDate),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _launchYouTubeVideo(video.youtubeUrl),
                          icon: const Icon(Icons.play_arrow, size: 20),
                          label: const Text('Watch on YouTube'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _shareVideo(video),
                        icon: const Icon(Icons.share),
                        tooltip: 'Share Video',
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary
                              .withOpacity(0.1),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showVideoOptions(video),
                        icon: const Icon(Icons.more_vert),
                        tooltip: 'More Options',
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary
                              .withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoThumbnail(VideoItem video, ThemeData theme) {
    String videoId = _extractYouTubeId(video.youtubeUrl);

    return Stack(
      children: [
        // YouTube thumbnail
        Container(
          width: double.infinity,
          height: double.infinity,
          child: videoId.isNotEmpty
              ? Image.network(
                  'https://img.youtube.com/vi/$videoId/maxresdefault.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildVideoPlaceholder(theme);
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildLoadingThumbnail(theme);
                  },
                )
              : _buildVideoPlaceholder(theme),
        ),
        // Dark overlay for better visibility
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.3),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Play button overlay
        Center(
          child: GestureDetector(
            onTap: () => _launchYouTubeVideo(video.youtubeUrl),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ),
        // Duration badge
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              video.duration,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        // YouTube logo
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.play_arrow, color: Colors.white, size: 12),
                const SizedBox(width: 2),
                const Text(
                  'YouTube',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Views overlay
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.visibility, color: Colors.white, size: 12),
                const SizedBox(width: 4),
                Text(
                  video.views,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingThumbnail(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.2),
            theme.colorScheme.secondary.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: theme.colorScheme.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading thumbnail...',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlaceholder(ThemeData theme) {
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
              Icons.video_library,
              size: 50,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 8),
            Text(
              'Video Unavailable',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 80,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'No Videos Available',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new content',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  String _extractYouTubeId(String url) {
    RegExp regExp = RegExp(
      r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
      caseSensitive: false,
      multiLine: false,
    );

    Match? match = regExp.firstMatch(url);
    return match?.group(1) ?? '';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<void> _launchYouTubeVideo(String url) async {
    HapticFeedback.mediumImpact();

    try {
      // For production, uncomment this and add url_launcher package:
      // if (await canLaunchUrl(Uri.parse(url))) {
      //   await launchUrl(
      //     Uri.parse(url),
      //     mode: LaunchMode.externalApplication,
      //   );
      // } else {
      //   throw 'Could not launch $url';
      // }

      // For demo purposes:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening YouTube: $url'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Copy URL',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open video: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _shareVideo(VideoItem video) {
    HapticFeedback.lightImpact();

    // For production, you can use share_plus package or native sharing:
    // Share.share(
    //   '${video.title}\n\n${video.description}\n\nWatch: ${video.youtubeUrl}',
    //   subject: video.title,
    // );

    // For demo:
    Clipboard.setData(
      ClipboardData(
        text:
            '${video.title}\n\n${video.description}\n\nWatch: ${video.youtubeUrl}',
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video details copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showVideoOptions(VideoItem video) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => _buildVideoOptionsSheet(video),
    );
  }

  Widget _buildVideoOptionsSheet(VideoItem video) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            video.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 24),
          _buildOptionItem(
            icon: Icons.play_arrow,
            title: 'Watch on YouTube',
            subtitle: 'Open in YouTube app',
            onTap: () {
              Navigator.pop(context);
              _launchYouTubeVideo(video.youtubeUrl);
            },
          ),
          _buildOptionItem(
            icon: Icons.share,
            title: 'Share Video',
            subtitle: 'Share with friends',
            onTap: () {
              Navigator.pop(context);
              _shareVideo(video);
            },
          ),
          _buildOptionItem(
            icon: Icons.link,
            title: 'Copy Link',
            subtitle: 'Copy YouTube URL',
            onTap: () {
              Navigator.pop(context);
              Clipboard.setData(ClipboardData(text: video.youtubeUrl));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('YouTube URL copied!')),
              );
            },
          ),
          _buildOptionItem(
            icon: Icons.info_outline,
            title: 'Video Details',
            subtitle: 'Show more information',
            onTap: () {
              Navigator.pop(context);
              _showVideoDetails(video);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  void _showVideoDetails(VideoItem video) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(video.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Description:',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(video.description),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 4),
                  Text('${video.duration} • '),
                  Icon(Icons.visibility, size: 16),
                  const SizedBox(width: 4),
                  Text('${video.views} views'),
                ],
              ),
              const SizedBox(height: 8),
              Text('Uploaded: ${_formatDate(video.uploadDate)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _launchYouTubeVideo(video.youtubeUrl);
            },
            child: const Text('Watch'),
          ),
        ],
      ),
    );
  }
}

class VideoItem {
  final String id;
  final String title;
  final String youtubeUrl;
  final String description;
  final String duration;
  final String views;
  final DateTime uploadDate;

  VideoItem({
    required this.id,
    required this.title,
    required this.youtubeUrl,
    required this.description,
    required this.duration,
    required this.views,
    required this.uploadDate,
  });
}
