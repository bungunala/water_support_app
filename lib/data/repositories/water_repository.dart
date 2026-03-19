import '../../core/services/api_service.dart';
import '../../core/services/cache_service.dart';
import '../models/models.dart';

abstract class WaterRepository {
  Future<MainPageContent> getMainPage();
  Future<List<WaterSystem>> getWaterSystems();
  Future<List<ProblemSlide>> getProblems(String systemId);
  Future<bool> sendContact(ContactForm form);
}

class WaterRepositoryImpl implements WaterRepository {
  final ApiService apiService;
  final CacheService cacheService;

  WaterRepositoryImpl({
    required this.apiService,
    required this.cacheService,
  });

  @override
  Future<MainPageContent> getMainPage() async {
    final data = await apiService.getMainPage();
    return MainPageContent.fromJson(data);
  }

  @override
  Future<List<WaterSystem>> getWaterSystems() async {
    final data = await apiService.getWaterSystems();
    return data.map((e) => WaterSystem.fromJson(e)).toList();
  }

  @override
  Future<List<ProblemSlide>> getProblems(String systemId) async {
    final data = await apiService.getProblems(systemId);
    return data.map((e) => ProblemSlide.fromJson(e)).toList();
  }

  @override
  Future<bool> sendContact(ContactForm form) async {
    return apiService.sendContactForm(form.toJson());
  }
}
