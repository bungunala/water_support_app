import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/models.dart';
import '../../data/repositories/water_repository.dart';
import '../providers/language_provider.dart';
import '../widgets/widgets.dart';
import 'water_system_screen.dart';
import 'contact_form_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  MainPageContent? _content;
  bool _isLoading = true;
  String? _error;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_content == null && _isLoading && _error == null) {
      _loadContent();
    }
  }

  Future<void> _loadContent() async {
    try {
      final repository = context.read<WaterRepository>();
      final data = await repository.getMainPage();
      setState(() {
        _content = data;
        _isLoading = false;
      });
      _fadeController.forward();
    } catch (e) {
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
      case 'build':
        return Icons.build;
      case 'people':
        return Icons.people;
      case 'location_city':
        return Icons.location_city;
      case 'kitchen':
        return Icons.kitchen;
      default:
        return Icons.water_drop;
    }
  }

  void _handleOptionTap(String optionId) {
    switch (optionId) {
      case 'option_a':
        Navigator.of(context).push(
          _createRoute(const WaterSystemScreen()),
        );
        break;
      case 'option_b':
        Navigator.of(context).push(
          _createRoute(const ContactFormScreen(
            formType: ContactFormType.check,
          )),
        );
        break;
      case 'option_c':
        Navigator.of(context).push(
          _createRoute(const ContactFormScreen(
            formType: ContactFormType.referral,
          )),
        );
        break;
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
        title: Text(
          _content != null
              ? AppStrings.getString('main_page', lang)
              : AppStrings.getString('main_page', 'en'),
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
        actions: [
          TextButton(
            onPressed: () {
              context.read<LanguageProvider>().toggleLanguage();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                lang.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AnimatedBackground(
        imageUrl: _content?.backgroundImage ?? _getDefaultBackground(),
        child: _buildContent(lang),
      ),
    );
  }

  String _getDefaultBackground() {
    return 'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=1280';
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
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadContent();
              },
              icon: const Icon(Icons.refresh),
              label: Text(AppStrings.getString('try_again', lang)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),
              ..._buildOptions(lang),
              const Spacer(),
              _buildSocialLinks(lang),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOptions(String lang) {
    if (_content == null) return [];

    return _content!.options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;

      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 400 + (index * 150)),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: Opacity(
              opacity: value,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: OptionCard(
                  title: AppStrings.getString(option.id, lang),
                  icon: _getIconData(option.icon),
                  onTap: () => _handleOptionTap(option.id),
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }

  Widget _buildSocialLinks(String lang) {
    if (_content == null) return const SizedBox.shrink();

    return Column(
      children: [
        Text(
          lang == 'en' ? 'Follow us' : 'Síguenos',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _content!.socialLinks.map((link) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SocialMediaButton(
                platform: link.platform,
                iconUrl: link.iconUrl,
                url: link.url,
                onTap: () async {
                  final uri = Uri.parse(link.url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Could not open ${link.platform}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
