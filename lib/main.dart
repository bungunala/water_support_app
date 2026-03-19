import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/services.dart';
import 'data/repositories/water_repository.dart';
import 'presentation/providers/language_provider.dart';
import 'presentation/screens/splash_screen.dart';

void main() {
  runApp(const WaterSupportApp());
}

class WaterSupportApp extends StatelessWidget {
  const WaterSupportApp({super.key});

  @override
  Widget build(BuildContext context) {
    final networkService = MockNetworkService();
    final cacheService = CacheServiceImpl();
    final apiService = MockApiService(
      networkService: networkService,
      cacheService: cacheService,
    );
    final repository = WaterRepositoryImpl(
      apiService: apiService,
      cacheService: cacheService,
    );

    return MultiProvider(
      providers: [
        Provider<WaterRepository>.value(value: repository),
        ChangeNotifierProvider<LanguageProvider>(
          create: (_) => LanguageProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Water Support',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF2196F3),
          scaffoldBackgroundColor: const Color(0xFFE3F2FD),
          fontFamily: 'Roboto',
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
            brightness: Brightness.light,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
