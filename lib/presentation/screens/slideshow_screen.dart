import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/models.dart';
import '../../data/repositories/water_repository.dart';
import '../providers/language_provider.dart';
import '../widgets/widgets.dart';
import 'contact_form_screen.dart';

class SlideshowScreen extends StatefulWidget {
  final String systemId;
  final Map<String, String> title;

  const SlideshowScreen({
    super.key,
    required this.systemId,
    required this.title,
  });

  @override
  State<SlideshowScreen> createState() => _SlideshowScreenState();
}

class _SlideshowScreenState extends State<SlideshowScreen>
    with SingleTickerProviderStateMixin {
  List<ProblemSlide> _slides = [];
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
    if (_slides.isEmpty && _isLoading && _error == null) {
      _loadProblems();
    }
  }

  Future<void> _loadProblems() async {
    try {
      final repository = context.read<WaterRepository>();
      final data = await repository.getProblems(widget.systemId);
      setState(() {
        _slides = data;
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

  String _getText(Map<String, String> textMap) {
    final lang = context.read<LanguageProvider>().currentLanguage;
    return textMap[lang] ?? textMap['en'] ?? '';
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
          widget.title[lang] ?? widget.title['en']!,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            shadows: [
              Shadow(color: AppColors.primaryDark, blurRadius: 10),
            ],
          ),
          textAlign: TextAlign.center,
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
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadProblems();
              },
              icon: const Icon(Icons.refresh),
              label: Text(AppStrings.getString('try_again', lang)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      );
    }

    if (_slides.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 64,
              color: Colors.white.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 16),
            Text(
              'No problems found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              AppStrings.getString('problems', lang),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(color: AppColors.primaryDark, blurRadius: 10),
                ],
              ),
            ),
          ),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideshowWidget(
                slides: _slides,
                getText: _getText,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const ContactFormScreen(formType: ContactFormType.check),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 400),
                    ),
                  );
                },
                icon: const Icon(Icons.contact_mail),
                label: Text(
                  AppStrings.getString('contact', lang),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
