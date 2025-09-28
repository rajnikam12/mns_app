import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mns_app/constants/assets.dart';
import 'package:mns_app/widgets/events.dart';
import 'package:mns_app/pages/drawer/custom_drawer.dart';
import 'package:mns_app/pages/home/components/event_cards.dart';
import 'package:mns_app/pages/home/components/view_all.dart';
import 'package:mns_app/widgets/custom_slider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          'महाराष्ट्र नवनिर्माण सेना',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.to(
              () => CustomDrawer(),
              transition: Transition.leftToRightWithFade,
            );
          },
          child: Icon(
            Icons.menu_open_outlined,
            color: Theme.of(context).scaffoldBackgroundColor,
            size: 40,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Banner Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
              child: CustomSlider(
                bannerImages: [
                  Assets.assetsImagesBanner,
                  Assets.assetsImagesBanner,
                  Assets.assetsImagesBanner,
                ],
              ),
            ),

            // Events Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Events',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AllEventsPage(events: events),
                            ),
                          );
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stay updated with our upcoming celebrations and activities',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  EventsSlider(events: events),
                ],
              ),
            ),

            // Improved Contacts Section
            Container(
              margin: EdgeInsets.all(screenWidth * 0.04),
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Title
                  Text(
                    'Contact Us',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  Text(
                    'Reach out to us for inquiries or support',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: screenWidth * 0.038,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 24),
                  // Contact Items
                  _buildContactItem(
                    context,
                    icon: Icons.email,
                    title: 'Email',
                    detail: 'info@mnsadhikrut.org',
                    onTap: () {
                      // Launch email client
                    },
                    screenWidth: screenWidth,
                  ),
                  const SizedBox(height: 16),
                  _buildContactItem(
                    context,
                    icon: Icons.phone,
                    title: 'Phone',
                    detail: '+91 22 1234 5678',
                    onTap: () {
                      // Launch phone dialer
                    },
                    screenWidth: screenWidth,
                  ),
                  const SizedBox(height: 16),
                  _buildContactItem(
                    context,
                    icon: Icons.location_on,
                    title: 'Address',
                    detail:
                        'MNS Headquarters, Shivaji Park, Mumbai, Maharashtra 400028',
                    onTap: () {
                      // Launch map
                    },
                    screenWidth: screenWidth,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24), // Bottom spacing
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String detail,
    required VoidCallback onTap,
    required double screenWidth,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).primaryColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              Container(
                width: screenWidth * 0.12,
                height: screenWidth * 0.12,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).primaryColor),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: screenWidth * 0.05,
                ),
              ),
              const SizedBox(width: 16),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.038,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detail,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: screenWidth * 0.036,
                        color: colorScheme.onSurfaceVariant,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Arrow Icon for interactivity
              Icon(
                Icons.arrow_forward_ios,
                size: screenWidth * 0.035,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
