import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mns_app/pages/about/about_page.dart';
import 'package:mns_app/pages/achievements/achievements.dart';
import 'package:mns_app/pages/drawer/widgets/custom_dropdown.dart';
import 'package:mns_app/pages/drawer/drawer_pages.dart/journey_screen.dart';
import 'package:mns_app/pages/yt/youtube.dart';

/// A custom drawer widget with improved styling and functionality
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40),
            // Drawer Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                children: [
                  DrawerSection(
                    title: 'Our Journey',
                    icon: Icons.timeline_outlined,
                    onTap: () {
                      Get.to(
                        () => const JourneyScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  DrawerSection(
                    title: 'Voters Section',
                    icon: Icons.how_to_vote_sharp,
                    onTap: () {
                      Get.to(
                        () => const Voters(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                  ),
                  // Add more drawer items here
                  SizedBox(height: 10),

                  DrawerSection(
                    title: 'About Us',
                    icon: Icons.info_outline,
                    onTap: () {
                      Get.to(
                        () => const AboutPage(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  DrawerSection(
                    title: 'Our Achievements',
                    icon: Icons.info_outline,
                    onTap: () {
                      Get.to(
                        () => const AchievementsScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  DrawerSection(
                    title: 'Videos',
                    icon: Icons.info_outline,
                    onTap: () {
                      Get.to(
                        () => const VideosScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A reusable drawer section widget with improved styling and animation
class DrawerSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const DrawerSection({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: onTap != null
                    ? Theme.of(context).primaryColor
                    : Colors.grey.withOpacity(0.3),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: onTap != null
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Colors.grey,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: onTap != null
                            ? Theme.of(context).scaffoldBackgroundColor
                            : Colors.grey,
                      ),
                    ),
                  ),
                  if (onTap != null)
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      size: 16,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
