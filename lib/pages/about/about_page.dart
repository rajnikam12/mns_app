import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mns_app/constants/assets.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _headerAnimationController;
  late Animation<double> _headerOpacityAnimation;
  bool _showFloatingTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _headerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _headerOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    const double threshold = 200;
    final bool shouldShowTitle = _scrollController.offset > threshold;

    if (shouldShowTitle != _showFloatingTitle) {
      setState(() {
        _showFloatingTitle = shouldShowTitle;
      });

      if (_showFloatingTitle) {
        _headerAnimationController.forward();
      } else {
        _headerAnimationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final primaryColor = colorScheme.primary;
    final accentColor = colorScheme.secondary;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontScale = screenWidth < 360 ? 0.9 : 1.0;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Enhanced Hero Header Section
          SliverAppBar(
            expandedHeight: 320,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: primaryColor,
            foregroundColor: colorScheme.onPrimary,
            systemOverlayStyle: theme.brightness == Brightness.light
                ? SystemUiOverlayStyle.dark
                : SystemUiOverlayStyle.light,
            title: AnimatedBuilder(
              animation: _headerOpacityAnimation,
              builder: (context, child) =>
                  Opacity(opacity: _headerOpacityAnimation.value, child: child),
              child: Semantics(
                label: 'Maharashtra Navnirman Sena',
                child: Text(
                  'Maharashtra Navnirman Sena',
                  style: textTheme.headlineMedium?.copyWith(
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    color: colorScheme.onPrimary,
                    fontSize: 18 * fontScale,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryColor.withOpacity(0.9),
                      primaryColor,
                      primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Background Pattern
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: const AssetImage(
                              'assets/images/pattern.png',
                            ),
                            fit: BoxFit.cover,
                            opacity: 0.1,
                            onError: (exception, stackTrace) => null,
                          ),
                        ),
                      ),
                    ),
                    // Floating Elements
                    Positioned(
                      top: 80,
                      right: 30,
                      child: Container(
                        width: screenWidth * 0.25,
                        height: screenWidth * 0.25,
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.125,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 120,
                      left: 20,
                      child: Container(
                        width: screenWidth * 0.15,
                        height: screenWidth * 0.15,
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.075,
                          ),
                        ),
                      ),
                    ),
                    // Main Content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          // MNS Logo Container
                          Hero(
                            tag: 'mns_logo',
                            child: Image.asset(
                              Assets.assetsImagesLogo,
                              width: 120,
                              height: 120,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Party Name (Marathi)
                          Semantics(
                            label: 'महाराष्ट्र नवनिर्माण सेना',
                            child: Text(
                              'महाराष्ट्र नवनिर्माण सेना',
                              style: textTheme.headlineLarge?.copyWith(
                                fontFamily:
                                    GoogleFonts.notoSansDevanagari().fontFamily,
                                fontSize: 24 * fontScale,
                                color: colorScheme.onPrimary,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Party Name (English)
                          Semantics(
                            label: 'Maharashtra Navnirman Sena',
                            child: Text(
                              'Maharashtra Navnirman Sena',
                              style: textTheme.headlineMedium?.copyWith(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                fontSize: 18 * fontScale,
                                color: colorScheme.onPrimary.withOpacity(0.95),
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Party Motto
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.onPrimary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: colorScheme.onPrimary.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Semantics(
                              label: 'स्वाभिमान • स्वत्व • शिस्त',
                              child: Text(
                                'स्वाभिमान • स्वत्व • शिस्त',
                                style: textTheme.bodyLarge?.copyWith(
                                  fontFamily: GoogleFonts.notoSansDevanagari()
                                      .fontFamily,
                                  fontSize: 16 * fontScale,
                                  color: colorScheme.onPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content Sections
          SliverPadding(
            padding: EdgeInsets.all(screenWidth < 360 ? 16 : 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Party Overview Card
                _buildEnhancedSection(
                  title: 'पार्टी परिचय',
                  subtitle: 'About MNS',
                  icon: Icons.info_outline,
                  color: primaryColor,
                  content: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              primaryColor.withOpacity(0.05),
                              primaryColor.withOpacity(0.02),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Semantics(
                          label: 'Party Overview in Marathi',
                          child: Text(
                            'महाराष्ट्र नवनिर्माण सेना ही २००६ मध्ये राज ठाकरे यांनी स्थापन केलेली राजकीय पक्ष आहे. ही पक्ष महाराष्ट्राच्या अभिमानासाठी आणि विकासासाठी काम करते. मराठी लोकांच्या कल्याणावर भर देत राज्याच्या प्रगतीसाठी प्रयत्नशील आहे.',
                            style: textTheme.bodyLarge?.copyWith(
                              fontFamily:
                                  GoogleFonts.notoSansDevanagari().fontFamily,
                              fontSize: 16 * fontScale,
                              height: 1.8,
                            ),
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Semantics(
                          label: 'Party Overview in English',
                          child: Text(
                            'The Maharashtra Navnirman Sena (MNS) is a political party founded in 2006 by Raj Thackeray. The party stands for the pride and development of Maharashtra, focusing on the welfare of Marathi people and the progress of the state while preserving Marathi culture and heritage.',
                            style: textTheme.bodyLarge?.copyWith(
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              fontSize: 16 * fontScale,
                              height: 1.7,
                            ),
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenWidth < 360 ? 24 : 32),

                // Vision Section
                _buildEnhancedSection(
                  title: 'आमचे ध्येय',
                  subtitle: 'Our Vision',
                  icon: Icons.visibility_outlined,
                  color: accentColor,
                  content: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          accentColor.withOpacity(0.1),
                          accentColor.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: accentColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          label: 'Vision Title',
                          child: Text(
                            'समृद्ध महाराष्ट्र निर्मितीसाठी:',
                            style: textTheme.headlineMedium?.copyWith(
                              fontFamily:
                                  GoogleFonts.notoSansDevanagari().fontFamily,
                              fontSize: 18 * fontScale,
                              color: accentColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._buildVisionPoints(fontScale),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenWidth < 360 ? 24 : 32),

                // Core Principles
                _buildEnhancedSection(
                  title: 'मूलभूत तत्त्वे',
                  subtitle: 'Core Principles',
                  icon: Icons.gavel_outlined,
                  color: primaryColor,
                  content: Column(
                    children: [
                      _buildPrincipleCard(
                        'स्वाभिमान',
                        'Self-Respect',
                        'मराठी माणसाच्या गर्वाला आणि सन्मानाला उंचावणे',
                        'Upholding the dignity and pride of Marathi people',
                        Icons.psychology_outlined,
                        primaryColor,
                        fontScale,
                      ),
                      const SizedBox(height: 16),
                      _buildPrincipleCard(
                        'स्वत्व',
                        'Identity',
                        'मराठी संस्कृती, भाषा आणि परंपरेचे जतन',
                        'Preserving Marathi culture, language, and traditions',
                        Icons.language_outlined,
                        accentColor,
                        fontScale,
                      ),
                      const SizedBox(height: 16),
                      _buildPrincipleCard(
                        'शिस्त',
                        'Discipline',
                        'शासनकार्यात सुव्यवस्था आणि पद्धतशीरपणा',
                        'Maintaining order and systematic approach in governance',
                        Icons.balance_outlined,
                        const Color(0xFF388E3C),
                        fontScale,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenWidth < 360 ? 24 : 32),

                // Key Focus Areas
                _buildEnhancedSection(
                  title: 'मुख्य कार्यक्षेत्रे',
                  subtitle: 'Key Focus Areas',
                  icon: Icons.track_changes_outlined,
                  color: const Color(0xFF388E3C),
                  content: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: screenWidth < 600 ? 2 : 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: screenWidth < 360 ? 1.2 : 1.1,
                    children: [
                      _buildFocusCard(
                        'रोजगार',
                        'Employment',
                        'स्थानिक तरुणांसाठी नोकऱ्यांची संधी',
                        Icons.work_outline,
                        primaryColor,
                        fontScale,
                      ),
                      _buildFocusCard(
                        'शिक्षण',
                        'Education',
                        'मराठी माध्यमातील दर्जेदार शिक्षण',
                        Icons.school_outlined,
                        accentColor,
                        fontScale,
                      ),
                      _buildFocusCard(
                        'पायाभूत सुविधा',
                        'Infrastructure',
                        'आधुनिक पायाभूत सुविधांचा विकास',
                        Icons.construction_outlined,
                        const Color(0xFF388E3C),
                        fontScale,
                      ),
                      _buildFocusCard(
                        'संस्कृती',
                        'Culture',
                        'मराठी कला आणि संस्कृतीचा प्रचार',
                        Icons.theater_comedy_outlined,
                        const Color(0xFFE65100),
                        fontScale,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenWidth < 360 ? 24 : 32),

                // Leadership Section
                _buildEnhancedSection(
                  title: 'नेतृत्व',
                  subtitle: 'Leadership',
                  icon: Icons.person_outline,
                  color: primaryColor,
                  content: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primaryColor.withOpacity(0.08),
                          primaryColor.withOpacity(0.03),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'raj_thackeray',
                          child: Container(
                            width: screenWidth * 0.2,
                            height: screenWidth * 0.2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  primaryColor,
                                  primaryColor.withOpacity(0.8),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.person,
                              size: 40 * fontScale,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Semantics(
                                label: 'राज ठाकरे',
                                child: Text(
                                  'राज ठाकरे',
                                  style: textTheme.headlineLarge?.copyWith(
                                    fontFamily: GoogleFonts.notoSansDevanagari()
                                        .fontFamily,
                                    fontSize: 22 * fontScale,
                                    color: primaryColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Semantics(
                                label: 'Raj Thackeray',
                                child: Text(
                                  'Raj Thackeray',
                                  style: textTheme.headlineMedium?.copyWith(
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
                                    fontSize: 18 * fontScale,
                                    color: primaryColor.withOpacity(0.8),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Semantics(
                                  label: 'पक्षाध्यक्ष आणि संस्थापक',
                                  child: Text(
                                    'पक्षाध्यक्ष आणि संस्थापक',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontFamily:
                                          GoogleFonts.notoSansDevanagari()
                                              .fontFamily,
                                      fontSize: 12 * fontScale,
                                      color: primaryColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Semantics(
                                label: 'Leadership Description',
                                child: Text(
                                  'महाराष्ट्राच्या विकासासाठी आणि मराठी लोकांच्या कल्याणासाठी समर्पित दूरदर्शी नेता.',
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontFamily: GoogleFonts.notoSansDevanagari()
                                        .fontFamily,
                                    fontSize: 13 * fontScale,
                                    height: 1.4,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenWidth < 360 ? 24 : 32),

                // Achievements
                _buildEnhancedSection(
                  title: 'मुख्य कामगिरी',
                  subtitle: 'Key Achievements',
                  icon: Icons.emoji_events_outlined,
                  color: const Color(0xFFE65100),
                  content: Column(children: _buildAchievementsList(fontScale)),
                ),

                SizedBox(height: screenWidth < 360 ? 24 : 32),

                // Contact Information
                _buildEnhancedSection(
                  title: 'संपर्क साधा',
                  subtitle: 'Connect With Us',
                  icon: Icons.contact_mail_outlined,
                  color: accentColor,
                  content: Column(
                    children: [
                      _buildContactCard(
                        'पक्षाचे कार्यालय',
                        'Party Headquarters',
                        'महाराष्ट्र नवनिर्माण सेना\nशिवाजी पार्क, दादर, मुंबई - ४०००२८',
                        'Maharashtra Navnirman Sena\nShivaji Park, Dadar, Mumbai - 400028',
                        Icons.location_on_outlined,
                        primaryColor,
                        fontScale,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildContactCard(
                              'दूरध्वनी',
                              'Phone',
                              '+९१ २२ २४४६ ४१४१',
                              '+91 22 2446 4141',
                              Icons.phone_outlined,
                              accentColor,
                              fontScale,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildContactCard(
                              'ईमेल',
                              'Email',
                              'contact@mns.org.in',
                              'contact@mns.org.in',
                              Icons.email_outlined,
                              const Color(0xFF388E3C),
                              fontScale,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildContactCard(
                              'संकेतस्थळ',
                              'Website',
                              'www.mns.org.in',
                              'www.mns.org.in',
                              Icons.language_outlined,
                              const Color(0xFFE65100),
                              fontScale,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildContactCard(
                              'सामाजिक माध्यम',
                              'Social Media',
                              '@MNSOfficial',
                              '@MNSOfficial',
                              Icons.share_outlined,
                              const Color(0xFF7B1FA2),
                              fontScale,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenWidth < 360 ? 24 : 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAchievementsList(double fontScale) {
    final achievements = [
      {
        'marathi': 'स्थानिक रोजगार धोरणांसाठी यशस्वी वकिली',
        'english': 'Successfully advocated for local employment policies',
        'icon': Icons.work_outline,
      },
      {
        'marathi': 'शिक्षण आणि शासनकार्यात मराठी भाषेला प्रोत्साहन',
        'english': 'Promoted Marathi language in education and government',
        'icon': Icons.language_outlined,
      },
      {
        'marathi': 'विविध पायाभूत सुविधा विकास प्रकल्पांची सुरुवात',
        'english': 'Initiated various infrastructure development projects',
        'icon': Icons.construction_outlined,
      },
      {
        'marathi': 'असंख्य सांस्कृतिक कार्यक्रम आणि उत्सवांचे आयोजन',
        'english': 'Organized numerous cultural events and festivals',
        'icon': Icons.celebration_outlined,
      },
      {
        'marathi': 'तरुण विकास आणि कौशल्य प्रशिक्षण कार्यक्रमांना पाठिंबा',
        'english': 'Supported youth development and skill training programs',
        'icon': Icons.school_outlined,
      },
    ];

    return achievements
        .map(
          (achievement) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: const Color(0xFFE65100).withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFE65100),
                        const Color(0xFFE65100).withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    achievement['icon'] as IconData,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 20 * fontScale,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        label: achievement['marathi'] as String,
                        child: Text(
                          achievement['marathi'] as String,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontFamily:
                                    GoogleFonts.notoSansDevanagari().fontFamily,
                                fontSize: 14 * fontScale,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Semantics(
                        label: achievement['english'] as String,
                        child: Text(
                          achievement['english'] as String,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                fontSize: 12 * fontScale,
                                height: 1.4,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _buildContactCard(
    String marathiTitle,
    String englishTitle,
    String marathiInfo,
    String englishInfo,
    IconData icon,
    Color color,
    double fontScale,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 18 * fontScale,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      label: marathiTitle,
                      child: Text(
                        marathiTitle,
                        style: textTheme.bodyMedium?.copyWith(
                          fontFamily:
                              GoogleFonts.notoSansDevanagari().fontFamily,
                          fontSize: 12 * fontScale,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Semantics(
                      label: englishTitle,
                      child: Text(
                        englishTitle,
                        style: textTheme.bodySmall?.copyWith(
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          fontSize: 10 * fontScale,
                          fontWeight: FontWeight.w600,
                          color: color.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (marathiInfo != englishInfo) ...[
            Semantics(
              label: marathiInfo,
              child: Text(
                marathiInfo,
                style: textTheme.bodySmall?.copyWith(
                  fontFamily: GoogleFonts.notoSansDevanagari().fontFamily,
                  fontSize: 11 * fontScale,
                  height: 1.4,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Semantics(
            label: englishInfo,
            child: Text(
              englishInfo,
              style: textTheme.bodySmall?.copyWith(
                fontFamily: GoogleFonts.montserrat().fontFamily,
                fontSize: 11 * fontScale,
                height: 1.4,
                color: marathiInfo != englishInfo
                    ? textTheme.bodySmall?.color
                    : null,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget content,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final double fontScale = MediaQuery.of(context).size.width < 360
        ? 0.9
        : 1.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 24 * fontScale,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      label: title,
                      child: Text(
                        title,
                        style: textTheme.headlineMedium?.copyWith(
                          fontFamily:
                              GoogleFonts.notoSansDevanagari().fontFamily,
                          fontSize: 20 * fontScale,
                          color: color,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Semantics(
                      label: subtitle,
                      child: Text(
                        subtitle,
                        style: textTheme.bodyMedium?.copyWith(
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          fontSize: 14 * fontScale,
                          color: color.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  List<Widget> _buildVisionPoints(double fontScale) {
    final points = [
      'मराठी लोकांना रोजगाराच्या संधींमध्ये प्राधान्य',
      'शिक्षण आणि रोजगारामुळे तरुणांचे सक्षमीकरण',
      'जीवनमानाच्या गुणवत्तेत सुधारणा करणारा पायाभूत विकास',
      'सांस्कृतिक वारशाचे जतन आणि संवर्धन',
      'समाजाच्या सर्व घटकांना फायद्याची आर्थिक वाढ',
    ];

    return points
        .map(
          (point) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 8, right: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.7),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Semantics(
                    label: point,
                    child: Text(
                      point,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: GoogleFonts.notoSansDevanagari().fontFamily,
                        fontSize: 15 * fontScale,
                        height: 1.6,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _buildPrincipleCard(
    String marathiTitle,
    String englishTitle,
    String marathiDescription,
    String englishDescription,
    IconData icon,
    Color color,
    double fontScale,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.08), color.withOpacity(0.03)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 28 * fontScale,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  label: marathiTitle,
                  child: Text(
                    marathiTitle,
                    style: textTheme.headlineMedium?.copyWith(
                      fontFamily: GoogleFonts.notoSansDevanagari().fontFamily,
                      fontSize: 18 * fontScale,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Semantics(
                  label: englishTitle,
                  child: Text(
                    englishTitle,
                    style: textTheme.bodyMedium?.copyWith(
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontSize: 14 * fontScale,
                      color: color.withOpacity(0.8),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Semantics(
                  label: marathiDescription,
                  child: Text(
                    marathiDescription,
                    style: textTheme.bodyMedium?.copyWith(
                      fontFamily: GoogleFonts.notoSansDevanagari().fontFamily,
                      fontSize: 14 * fontScale,
                      height: 1.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Semantics(
                  label: englishDescription,
                  child: Text(
                    englishDescription,
                    style: textTheme.bodySmall?.copyWith(
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontSize: 13 * fontScale,
                      height: 1.4,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusCard(
    String marathiTitle,
    String englishTitle,
    String description,
    IconData icon,
    Color color,
    double fontScale,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 28 * fontScale,
            ),
          ),
          SizedBox(height: 5),
          Semantics(
            label: marathiTitle,
            child: Text(
              marathiTitle,
              style: textTheme.bodyMedium?.copyWith(
                fontFamily: GoogleFonts.notoSansDevanagari().fontFamily,
                fontSize: 14 * fontScale,
                fontWeight: FontWeight.w700,
                color: color,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Semantics(
            label: englishTitle,
            child: Text(
              englishTitle,
              style: textTheme.bodySmall?.copyWith(
                fontFamily: GoogleFonts.montserrat().fontFamily,
                fontSize: 12 * fontScale,
                fontWeight: FontWeight.w600,
                color: color.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Semantics(
            label: description,
            child: Text(
              description,
              style: textTheme.bodySmall?.copyWith(
                fontFamily: GoogleFonts.notoSansDevanagari().fontFamily,
                fontSize: 11 * fontScale,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
