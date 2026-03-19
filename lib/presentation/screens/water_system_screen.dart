import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/models.dart';
import '../../data/repositories/water_repository.dart';
import '../providers/language_provider.dart';
import '../widgets/widgets.dart';
import 'slideshow_screen.dart';

class WaterSystemScreen extends StatefulWidget {
  const WaterSystemScreen({super.key});

  @override
  State<WaterSystemScreen> createState() => _WaterSystemScreenState();
}

class _WaterSystemScreenState extends State<WaterSystemScreen>
    with SingleTickerProviderStateMixin {
  List<WaterSystem> _systems = [];
  bool _isLoading = true;
  String? _error;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_systems.isEmpty && _isLoading && _error == null) {
      _loadSystems();
    }
  }

  Future<void> _loadSystems() async {
    try {
      final repository = context.read<WaterRepository>();
      final data = await repository.getWaterSystems();
      //print('Loaded ${data.length} water systems');
      setState(() {
        _systems = data;
        _isLoading = false;
      });
      _fadeController.forward();
    } catch (e) {
      //print('Error loading systems: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'water_drop':
        return Icons.water_drop;
      case 'location_city':
        return Icons.location_city;
      case 'kitchen':
        return Icons.kitchen;
      case 'science':
        return Icons.science;
      default:
        return Icons.water_drop;
    }
  }

  void _navigateToSystem(WaterSystem system) {
    if (system.hasChildren) {
      Navigator.of(context).push(
        _createRoute(_WaterSystemListScreen(
          systems: system.children,
          parentTitle: system.title,
        )),
      );
    } else {
      Navigator.of(context).push(
        _createRoute(SlideshowScreen(systemId: system.id, title: system.title)),
      );
    }
  }

  PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().currentLanguage;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppStrings.getString('water_systems', lang),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: AppColors.primaryDark,
                blurRadius: 10,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedBackground(
        child: _buildContent(lang),
      ),
    );
  }

  Widget _buildContent(String lang) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.getString('error_loading', lang),
              style: TextStyle(fontSize: 18, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadSystems();
              },
              icon: const Icon(Icons.refresh),
              label: Text(AppStrings.getString('try_again', lang)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: _systems.length,
          itemBuilder: (context, index) {
            final system = _systems[index];
            return _buildSystemCard(system, lang, index);
          },
        ),
      ),
    );
  }

  Widget _buildSystemCard(WaterSystem system, String lang, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () => _navigateToSystem(system),
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryDark.withValues(alpha: 0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          system.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: AppColors.waterGradient,
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.primaryDark.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      _getIconData(system.icon),
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          system.title[lang] ?? system.title['en']!,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        if (system.hasChildren)
                                          Text(
                                            '${system.children.length} options',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white.withValues(alpha: 0.8),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    system.hasChildren
                                        ? Icons.arrow_forward_ios
                                        : Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 20,
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
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WaterSystemListScreen extends StatelessWidget {
  final List<WaterSystem> systems;
  final Map<String, String> parentTitle;

  const _WaterSystemListScreen({
    required this.systems,
    required this.parentTitle,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().currentLanguage;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          parentTitle[lang] ?? parentTitle['en']!,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: AppColors.primaryDark, blurRadius: 10),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: AnimatedBackground(
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: systems.length,
            itemBuilder: (context, index) {
              final system = systems[index];
              return _buildSystemCard(context, system, lang, index);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSystemCard(
    BuildContext context,
    WaterSystem system,
    String lang,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SlideshowScreen(systemId: system.id, title: system.title),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 400),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryDark.withValues(alpha: 0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: AppColors.waterGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.water_drop,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      system.title[lang] ?? system.title['en']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      system.subtitle[lang] ?? system.subtitle['en']!,
                      style: TextStyle(
                        color: AppColors.textPrimary.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
