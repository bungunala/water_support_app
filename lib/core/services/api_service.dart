import '../constants/api_constants.dart';
import 'network_service.dart';
import 'cache_service.dart';

abstract class ApiService {
  Future<Map<String, dynamic>> getMainPage();
  Future<List<Map<String, dynamic>>> getWaterSystems();
  Future<List<Map<String, dynamic>>> getProblems(String systemId);
  Future<bool> sendContactForm(Map<String, dynamic> formData);
}

class ApiServiceImpl implements ApiService {
  final NetworkService networkService;
  final CacheService cacheService;

  ApiServiceImpl({
    required this.networkService,
    required this.cacheService,
  });

  @override
  Future<Map<String, dynamic>> getMainPage() async {
    if (await networkService.isConnected()) {
      final cached = await cacheService.get(ApiConstants.cacheKeyMainPage);
      if (cached != null) {
        return cached as Map<String, dynamic>;
      }
      throw UnimplementedError('Real API not implemented');
    } else {
      final cached = await cacheService.get(ApiConstants.cacheKeyMainPage);
      if (cached != null) {
        return cached as Map<String, dynamic>;
      }
      throw Exception('No internet connection and no cached data');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getWaterSystems() async {
    if (await networkService.isConnected()) {
      final cached = await cacheService.get(ApiConstants.cacheKeyWaterSystems);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached);
      }
      throw UnimplementedError('Real API not implemented');
    } else {
      final cached = await cacheService.get(ApiConstants.cacheKeyWaterSystems);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached);
      }
      throw Exception('No internet connection and no cached data');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getProblems(String systemId) async {
    if (await networkService.isConnected()) {
      final cached = await cacheService.get(ApiConstants.cacheKeyProblems(systemId));
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached);
      }
      throw UnimplementedError('Real API not implemented');
    } else {
      final cached = await cacheService.get(ApiConstants.cacheKeyProblems(systemId));
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached);
      }
      throw Exception('No internet connection and no cached data');
    }
  }

  @override
  Future<bool> sendContactForm(Map<String, dynamic> formData) async {
    if (await networkService.isConnected()) {
      throw UnimplementedError('Real API not implemented');
    }
    return false;
  }
}
