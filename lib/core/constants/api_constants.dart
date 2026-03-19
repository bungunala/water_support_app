class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.watersupport.example.com';
  static const String apiVersion = 'v1';

  static const Duration timeout = Duration(seconds: 30);

  static const String mainPageEndpoint = '/$apiVersion/main-page';
  static const String waterSystemsEndpoint = '/$apiVersion/water-systems';
  static String problemsEndpoint(String systemId) => '/$apiVersion/systems/$systemId/problems';
  static const String contactEndpoint = '/$apiVersion/contact';

  static const String cacheKeyMainPage = 'cache_main_page';
  static const String cacheKeyWaterSystems = 'cache_water_systems';
  static String cacheKeyProblems(String systemId) => 'cache_problems_$systemId';
  static const Duration cacheDuration = Duration(hours: 24);
}
