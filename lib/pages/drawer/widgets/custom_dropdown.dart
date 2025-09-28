import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:math';

// ------------------- Constants -------------------
class AppConstants {
  static const double cardPadding = 16.0;
  static const double defaultSpacing = 12.0;
  static const double smallSpacing = 8.0;
  static const double largeSpacing = 20.0;
  static const double borderRadius = 12.0;
  static const double cardBorderRadius = 12.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration chartAnimationDuration = Duration(milliseconds: 1000);
}

// ------------------- Data Model -------------------
class AreaInfo {
  final int totalVoters;
  final int maleVoters;
  final int femaleVoters;
  final String description;
  final double area; // in sq km
  final int pollingBooths;

  AreaInfo({
    required this.totalVoters,
    required this.maleVoters,
    required this.femaleVoters,
    required this.description,
    required this.area,
    required this.pollingBooths,
  });

  double get voterDensity => totalVoters / area;
  double get malePercentage => (maleVoters / totalVoters) * 100;
  double get femalePercentage => (femaleVoters / totalVoters) * 100;
  double get genderRatio => maleVoters / femaleVoters;
}

// ------------------- Interactive Pie Chart -------------------
class InteractivePieChart extends StatefulWidget {
  final Map<String, double> dataMap;
  final List<Color> colorList;

  const InteractivePieChart({
    super.key,
    required this.dataMap,
    required this.colorList,
  });

  @override
  State<InteractivePieChart> createState() => _InteractivePieChartState();
}

class _InteractivePieChartState extends State<InteractivePieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String? activeSlice;
  Offset? touchPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.chartAnimationDuration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _getSliceFromAngle(double angle) {
    double startAngle = 0;
    final total = widget.dataMap.values.reduce((a, b) => a + b);
    for (var entry in widget.dataMap.entries) {
      double sweepAngle = (entry.value / total) * 2 * pi;
      if (angle >= startAngle && angle <= startAngle + sweepAngle) {
        return entry.key;
      }
      startAngle += sweepAngle;
    }
    return null;
  }

  void _handleTouch(TapDownDetails details, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final touchVector = details.localPosition - center;
    final angle = atan2(touchVector.dy, touchVector.dx) + pi / 2;
    double normalizedAngle = angle < 0 ? 2 * pi + angle : angle;

    setState(() {
      activeSlice = _getSliceFromAngle(normalizedAngle);
      touchPosition = details.localPosition;
    });
  }

  void _handleTouchEnd(_) {
    setState(() {
      activeSlice = null;
      touchPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxWidth);
        return GestureDetector(
          onTapDown: (details) => _handleTouch(details, size),
          onPanUpdate: (details) => _handleTouch(
            TapDownDetails(localPosition: details.localPosition),
            size,
          ),
          onPanEnd: _handleTouchEnd,
          onTapUp: _handleTouchEnd,
          child: Stack(
            children: [
              Center(
                child: ScaleTransition(
                  scale: _animation,
                  child: PieChart(
                    dataMap: widget.dataMap,
                    animationDuration: AppConstants.chartAnimationDuration,
                    chartRadius: size.width / 2.5,
                    colorList: widget.colorList,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    legendOptions: const LegendOptions(showLegends: false),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValues: false,
                    ),
                    gradientList: [
                      [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withOpacity(0.7),
                      ],
                      [
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.7),
                      ],
                    ],
                  ),
                ),
              ),
              if (activeSlice != null && touchPosition != null)
                Positioned(
                  left: (touchPosition!.dx - 80).clamp(0, size.width - 160),
                  top: (touchPosition!.dy - 100).clamp(0, size.height - 80),
                  child: AnimatedOpacity(
                    opacity: 1,
                    duration: AppConstants.animationDuration,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeSlice!,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              '${widget.dataMap[activeSlice]!.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} voters',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ------------------- Custom Dropdown Widget -------------------
class CustomDropdown extends StatefulWidget {
  final Function(String) onAreaSelected;
  final List<String> areas;
  final String? selectedArea;

  const CustomDropdown({
    super.key,
    required this.onAreaSelected,
    required this.areas,
    this.selectedArea,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  String? selectedArea;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    selectedArea = widget.selectedArea;
    _animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _hideOverlay();
    _animationController.dispose();
    super.dispose();
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
  }

  void _hideOverlay() {
    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 8),
          child: ScaleTransition(
            scale: _expandAnimation,
            alignment: Alignment.topCenter,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(
                AppConstants.cardBorderRadius,
              ),
              color: Theme.of(context).colorScheme.surface,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shrinkWrap: true,
                  itemCount: widget.areas.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final area = widget.areas[index];
                    final isSelected = area == selectedArea;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedArea = area;
                          isExpanded = false;
                        });
                        widget.onAreaSelected(area);
                        _hideOverlay();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: AppConstants.defaultSpacing,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 20,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                area,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: () {
          setState(() => isExpanded = !isExpanded);
          isExpanded ? _showOverlay() : _hideOverlay();
        },
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultSpacing,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(
              color: isExpanded
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              width: isExpanded ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedArea ?? 'Select Area',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: AppConstants.animationDuration,
                child: Icon(
                  Icons.expand_more,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------- Stat Card Widget -------------------
class StatCard extends StatefulWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.color,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = widget.color ?? Theme.of(context).colorScheme.primary;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
        child: InkWell(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) => _controller.reverse(),
          onTapCancel: () => _controller.reverse(),
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(widget.icon, color: cardColor, size: 20),
                ),
                const SizedBox(height: AppConstants.defaultSpacing),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    TweenAnimationBuilder<int>(
                      tween: IntTween(
                        begin: 0,
                        end:
                            int.tryParse(
                              widget.value.replaceAll(RegExp(r'[^\d]'), ''),
                            ) ??
                            0,
                      ),
                      duration: AppConstants.chartAnimationDuration,
                      builder: (context, value, child) {
                        return Text(
                          widget.value.contains('%') ||
                                  widget.value.contains(':')
                              ? widget.value
                              : value.toString().replaceAllMapped(
                                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                  (Match m) => '${m[1]},',
                                ),
                          style: Theme.of(context).textTheme.headlineMedium!
                              .copyWith(color: cardColor),
                        );
                      },
                    ),
                    if (widget.subtitle != null)
                      Text(
                        widget.subtitle!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------- Loading Widget -------------------
class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({super.key, this.message = 'Loading data...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppConstants.defaultSpacing),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

// ------------------- Empty State Widget -------------------
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onActionPressed,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largeSpacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: AppConstants.defaultSpacing),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.smallSpacing),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onActionPressed != null && actionLabel != null) ...[
              const SizedBox(height: AppConstants.largeSpacing),
              ElevatedButton.icon(
                onPressed: onActionPressed,
                icon: const Icon(Icons.refresh),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ------------------- Legend Item -------------------
class LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int value;
  final double percentage;

  const LegendItem({
    super.key,
    required this.color,
    required this.label,
    required this.value,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultSpacing,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              Text(
                '${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} (${percentage.toStringAsFixed(1)}%)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------- Main Voters Screen -------------------
class Voters extends StatefulWidget {
  const Voters({super.key});

  @override
  State<Voters> createState() => _VotersState();
}

class _VotersState extends State<Voters> with TickerProviderStateMixin {
  String? selectedArea;
  AreaInfo? selectedAreaInfo;
  bool isLoading = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> _areas = [
    'Khindipada',
    'Amar Nagar',
    'Mulund Colony',
    'Hindustan Chowk',
  ];

  final Map<String, AreaInfo> _areaData = {
    'Khindipada': AreaInfo(
      totalVoters: 125000,
      maleVoters: 65000,
      femaleVoters: 60000,
      description: 'Urban residential area with high voter density',
      area: 15.5,
      pollingBooths: 45,
    ),
    'Amar Nagar': AreaInfo(
      totalVoters: 89000,
      maleVoters: 44500,
      femaleVoters: 44500,
      description: 'Mixed residential and commercial district',
      area: 12.3,
      pollingBooths: 32,
    ),
    'Mulund Colony': AreaInfo(
      totalVoters: 67000,
      maleVoters: 33500,
      femaleVoters: 33500,
      description: 'Suburban colony with balanced demographics',
      area: 18.7,
      pollingBooths: 28,
    ),
    'Hindustan Chowk': AreaInfo(
      totalVoters: 45000,
      maleVoters: 28000,
      femaleVoters: 17000,
      description: 'Commercial hub with diverse population',
      area: 8.2,
      pollingBooths: 18,
    ),
  };

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _onAreaSelected(String area) async {
    if (selectedArea == area) return;

    setState(() {
      isLoading = true;
      selectedArea = area;
    });

    _fadeController.reset();
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      selectedAreaInfo = _areaData[area];
      isLoading = false;
    });
    _fadeController.forward();
  }

  Widget _buildStatsGrid() {
    if (selectedAreaInfo == null) return const SizedBox.shrink();

    final stats = [
      {
        'title': 'Total Voters',
        'value': selectedAreaInfo!.totalVoters.toString(),
        'subtitle': 'Registered voters',
        'icon': Icons.how_to_vote,
        'color': Theme.of(context).colorScheme.primary,
      },
      {
        'title': 'Male Voters',
        'value': selectedAreaInfo!.maleVoters.toString(),
        'subtitle': '${selectedAreaInfo!.malePercentage.toStringAsFixed(1)}%',
        'icon': Icons.male,
        'color': Colors.blue.shade600,
      },
      {
        'title': 'Female Voters',
        'value': selectedAreaInfo!.femaleVoters.toString(),
        'subtitle': '${selectedAreaInfo!.femalePercentage.toStringAsFixed(1)}%',
        'icon': Icons.female,
        'color': Colors.pink.shade400,
      },
      {
        'title': 'Polling Booths',
        'value': selectedAreaInfo!.pollingBooths.toString(),
        'subtitle': 'Active locations',
        'icon': Icons.location_on,
        'color': Colors.orange.shade600,
      },
      {
        'title': 'Area Coverage',
        'value': '${selectedAreaInfo!.area.toStringAsFixed(1)} km²',
        'subtitle': 'Total area',
        'icon': Icons.map,
        'color': Colors.green.shade600,
      },
      {
        'title': 'Voter Density',
        'value': selectedAreaInfo!.voterDensity.toInt().toString(),
        'subtitle': 'Voters per km²',
        'icon': Icons.density_medium,
        'color': Colors.purple.shade600,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppConstants.defaultSpacing,
            crossAxisSpacing: AppConstants.defaultSpacing,
            childAspectRatio: constraints.maxWidth > 600 ? 1.2 : 1.0,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return StatCard(
              title: stat['title'] as String,
              value: stat['value'] as String,
              subtitle: stat['subtitle'] as String,
              icon: stat['icon'] as IconData,
              color: stat['color'] as Color,
            );
          },
        );
      },
    );
  }

  Widget _buildPieChart() {
    if (selectedAreaInfo == null) return const SizedBox.shrink();

    final pieData = {
      'Male': selectedAreaInfo!.maleVoters.toDouble(),
      'Female': selectedAreaInfo!.femaleVoters.toDouble(),
    };

    final colorList = [Colors.blue.shade600, Colors.pink.shade400];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gender Distribution',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppConstants.largeSpacing),
            SizedBox(
              height: 200,
              child: InteractivePieChart(
                dataMap: pieData,
                colorList: colorList,
              ),
            ),
            const SizedBox(height: AppConstants.defaultSpacing),
            Wrap(
              spacing: AppConstants.defaultSpacing,
              runSpacing: AppConstants.defaultSpacing,
              children: [
                LegendItem(
                  color: colorList[0],
                  label: 'Male',
                  value: selectedAreaInfo!.maleVoters,
                  percentage: selectedAreaInfo!.malePercentage,
                ),
                LegendItem(
                  color: colorList[1],
                  label: 'Female',
                  value: selectedAreaInfo!.femaleVoters,
                  percentage: selectedAreaInfo!.femalePercentage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaDetails() {
    if (selectedAreaInfo == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_city,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedArea!,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultSpacing),
            Text(
              selectedAreaInfo!.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppConstants.defaultSpacing),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gender Ratio',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          '${selectedAreaInfo!.genderRatio.toStringAsFixed(2)}:1 (Male:Female)',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voter Insights Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Data refreshed successfully'),
                  action: SnackBarAction(label: 'OK', onPressed: () {}),
                ),
              );
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh data',
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About'),
                  content: const Text(
                    'Voter Insights Dashboard provides comprehensive statistics about voter demographics across different areas.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Voting Area',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: AppConstants.smallSpacing),
                    Text(
                      'Choose an area to view voter statistics',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppConstants.defaultSpacing),
                    CustomDropdown(
                      areas: _areas,
                      selectedArea: selectedArea,
                      onAreaSelected: _onAreaSelected,
                    ),
                    const SizedBox(height: AppConstants.largeSpacing),
                    isLoading
                        ? const LoadingWidget(message: 'Loading voter data...')
                        : selectedAreaInfo == null
                        ? EmptyStateWidget(
                            title: 'No Area Selected',
                            subtitle:
                                'Select an area to view voter statistics.',
                            icon: Icons.analytics_outlined,
                            actionLabel: 'Select Area',
                            onActionPressed: () =>
                                _onAreaSelected(_areas.first),
                          )
                        : FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildAreaDetails(),
                                const SizedBox(
                                  height: AppConstants.largeSpacing,
                                ),
                                Text(
                                  'Voter Statistics',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displayMedium,
                                ),
                                const SizedBox(
                                  height: AppConstants.defaultSpacing,
                                ),
                                _buildStatsGrid(),
                                const SizedBox(
                                  height: AppConstants.largeSpacing,
                                ),
                                _buildPieChart(),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
