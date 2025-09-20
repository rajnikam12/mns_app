import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mns_app/constants/assets.dart';

class Member {
  final String id;
  final String name;
  final String position;
  final String imageUrl;
  final String? email;
  final String? phone;
  final String? bio;

  Member({
    required this.id,
    required this.name,
    required this.position,
    required this.imageUrl,
    this.email,
    this.phone,
    this.bio,
  });
}

class MembersPage extends StatefulWidget {
  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  late List<Member> allMembers;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _initializeMembers();
  }

  void _initializeMembers() {
    allMembers = [
      Member(
        id: '1',
        name: 'Sandeep Vare',
        position: 'Party Chairman',
        imageUrl: Assets.assetsImagesRaj,
        email: 'sandeep.vare@party.org',
        phone: '+91 98765-43210',
        bio:
            'Experienced leader with over 15 years in public service. Committed to community development and progressive policies.',
      ),
      Member(
        id: '2',
        name: 'Michael Rodriguez',
        position: 'Vice Chairman',
        imageUrl: Assets.assetsImagesRaj,
        email: 'michael.rodriguez@party.org',
        phone: '+91 98765-43211',
        bio:
            'Strategic planner focused on youth engagement and digital transformation initiatives.',
      ),
      Member(
        id: '3',
        name: 'Raj Thackeray',
        position: 'Secretary',
        imageUrl: Assets.assetsImagesRaj,
        email: 'raj.thackeray@party.org',
        phone: '+91 98765-43212',
        bio:
            'Administrative expert with strong background in organizational management.',
      ),
      Member(
        id: '4',
        name: 'Priya Sharma',
        position: 'Treasurer',
        imageUrl: Assets.assetsImagesRaj,
        email: 'priya.sharma@party.org',
        phone: '+91 98765-43213',
        bio:
            'Financial expert ensuring transparency and fiscal responsibility.',
      ),
      Member(
        id: '5',
        name: 'Amit Patel',
        position: 'Communications Head',
        imageUrl: Assets.assetsImagesRaj,
        email: 'amit.patel@party.org',
        phone: '+91 98765-43214',
        bio:
            'Media relations specialist with expertise in public communications.',
      ),
      Member(
        id: '6',
        name: 'Kavya Nair',
        position: 'Youth Coordinator',
        imageUrl: Assets.assetsImagesRaj,
        email: 'kavya.nair@party.org',
        phone: '+91 98765-43215',
        bio: 'Dynamic leader focused on empowering young voices in politics.',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Party Members',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            tooltip: _isGridView
                ? 'Switch to List View'
                : 'Switch to Grid View',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isGridView
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: allMembers.length,
                itemBuilder: (context, index) => _MemberCard(
                  member: allMembers[index],
                  onTap: () => _showMemberDetails(context, allMembers[index]),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: allMembers.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: _MemberListTile(
                  member: allMembers[index],
                  onTap: () => _showMemberDetails(context, allMembers[index]),
                ),
              ),
            ),
    );
  }

  void _showMemberDetails(BuildContext context, Member member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MemberDetailsSheet(member: member),
    );
  }
}

// ------------------- Member Card (Grid View) -------------------
class _MemberCard extends StatelessWidget {
  final Member member;
  final VoidCallback onTap;

  const _MemberCard({required this.member, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: AssetImage(member.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        member.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        member.position,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------- Member List Tile (List View) -------------------
class _MemberListTile extends StatelessWidget {
  final Member member;
  final VoidCallback onTap;

  const _MemberListTile({required this.member, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(member.imageUrl),
        ),
        title: Text(
          member.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              member.position,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (member.email != null)
              Text(
                member.email!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}

// ------------------- Member Details Sheet -------------------
class _MemberDetailsSheet extends StatelessWidget {
  final Member member;

  const _MemberDetailsSheet({required this.member});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(member.imageUrl),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.name,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                member.position,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Bio Section
                  if (member.bio != null) ...[
                    Text(
                      'About',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        member.bio!,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Contact Information
                  Text(
                    'Contact Information',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (member.email != null)
                    _ContactTile(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      value: member.email!,
                      onTap: () => _launchEmail(member.email!),
                    ),

                  if (member.phone != null)
                    _ContactTile(
                      icon: Icons.phone_outlined,
                      title: 'Phone',
                      value: member.phone!,
                      onTap: () => _launchPhone(member.phone!),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchEmail(String email) {
    // Implement email launching logic
    print('Launching email to: $email');
  }

  void _launchPhone(String phone) {
    // Implement phone dialing logic
    print('Calling: $phone');
  }
}

// ------------------- Contact Tile -------------------
class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withOpacity(0.3),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 20),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          Icons.launch,
          size: 18,
          color: colorScheme.onSurfaceVariant,
        ),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
      ),
    );
  }
}
