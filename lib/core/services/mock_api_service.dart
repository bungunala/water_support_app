//import '../constants/api_constants.dart';
import 'network_service.dart';
import 'cache_service.dart';
import 'api_service.dart';

class MockApiService implements ApiService {
  final NetworkService networkService;
  final CacheService cacheService;

  MockApiService({
    required this.networkService,
    required this.cacheService,
  });

  @override
  Future<Map<String, dynamic>> getMainPage() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockMainPageData;
  }

  @override
  Future<List<Map<String, dynamic>>> getWaterSystems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockWaterSystemsData;
  }

  @override
  Future<List<Map<String, dynamic>>> getProblems(String systemId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockProblemsData[systemId] ?? [];
  }

  @override
  Future<bool> sendContactForm(Map<String, dynamic> formData) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  static final Map<String, dynamic> _mockMainPageData = {
    'background_image': 'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=1280',
    'title': {
      'en': 'Water Support',
      'es': 'Soporte de Agua',
    },
    'social_links': [
      {
        'platform': 'instagram',
        'url': 'https://instagram.com/elaguadepablo',
        'icon_url': 'https://cdn-icons-png.flaticon.com/512/174/174855.png',
      },
      {
        'platform': 'tiktok',
        'url': 'https://www.tiktok.com/@elaguadepablo',
        'icon_url': 'https://cdn-icons-png.flaticon.com/512/3046/3046121.png',
      },
      {
        'platform': 'whatsapp',
        'url': 'https://wa.me/1234567890',
        'icon_url': 'https://cdn-icons-png.flaticon.com/512/733/733585.png',
      },
    ],
    'options': [
      {
        'id': 'option_a',
        'title': {
          'en': 'What kind of water system do you have?',
          'es': '¿Qué tipo de sistema de agua tiene?',
        },
        'icon': 'water_drop',
      },
      {
        'id': 'option_b',
        'title': {
          'en': 'Do you want to get a check on your water system?',
          'es': '¿Desea revisar su sistema de agua?',
        },
        'icon': 'build',
      },
      {
        'id': 'option_c',
        'title': {
          'en': 'Do you wish to refer us to someone else?',
          'es': '¿Desea recomendarnos a alguien más?',
        },
        'icon': 'people',
      },
    ],
  };

  static final List<Map<String, dynamic>> _mockWaterSystemsData = [
    {
      'id': 'pozo',
      'title': {
        'en': 'Well Water',
        'es': 'Agua de Pozo',
      },
      'subtitle': {
        'en': 'Well water systems',
        'es': 'Sistemas de agua de pozo',
      },
      'icon': 'water_drop',
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      'children': [
        {
          'id': 'pozo_2_tanques',
          'title': {
            'en': 'Well Water 2 Tanks',
            'es': 'Agua de Pozo 2 Tanques',
          },
          'subtitle': {
            'en': 'Two tank system',
            'es': 'Sistema de dos tanques',
          },
          'image': 'https://images.unsplash.com/photo-1585675315678-4a818c0e3c84?w=400',
        },
        {
          'id': 'pozo_osmosis',
          'title': {
            'en': 'Well Water Reverse Osmosis (Whole House)',
            'es': 'Agua de Pozo Osmosis Inversa (Toda la Casa)',
          },
          'subtitle': {
            'en': 'Whole house reverse osmosis',
            'es': 'Osmosis inversa para toda la casa',
          },
          'image': 'https://images.unsplash.com/photo-1559631658-39c4b43f5c8a?w=400',
        },
      ],
    },
    {
      'id': 'ciudad',
      'title': {
        'en': 'City Water',
        'es': 'Agua de la Ciudad',
      },
      'subtitle': {
        'en': 'City water systems',
        'es': 'Sistemas de agua de la ciudad',
      },
      'icon': 'location_city',
      'image': 'https://images.unsplash.com/photo-1565703127086-ce6e91f57c98?w=400',
      'children': [],
    },
    {
      'id': 'osmosis_cocina',
      'title': {
        'en': 'Kitchen Reverse Osmosis',
        'es': 'Osmosis Inversa Cocina',
      },
      'subtitle': {
        'en': 'Kitchen reverse osmosis',
        'es': 'Osmosis inversa de cocina',
      },
      'icon': 'kitchen',
      'image': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400',
      'children': [],
    },
  ];

  static final Map<String, List<Map<String, dynamic>>> _mockProblemsData = {
    'pozo': [
      {
        'id': 1,
        'title': {
          'en': 'Low Water Pressure',
          'es': 'Baja Presión de Agua',
        },
        'description': {
          'en': 'Common causes include clogged filters, pipe corrosion, or pump issues.',
          'es': 'Las causas comunes incluyen filtros obstruidos, corrosión de tuberías o problemas con la bomba.',
        },
        'image': 'https://images.unsplash.com/photo-1585675315678-4a818c0e3c84?w=600',
      },
      {
        'id': 2,
        'title': {
          'en': 'Cloudy or Murky Water',
          'es': 'Agua Turbia o Nublada',
        },
        'description': {
          'en': 'Usually caused by sediment, air pockets, or bacterial contamination.',
          'es': 'Generalmente causado por sedimentos, bolsas de aire o contaminación bacteriana.',
        },
        'image': 'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=600',
      },
      {
        'id': 3,
        'title': {
          'en': 'Strange Taste or Smell',
          'es': 'Sabor o Olor Extraño',
        },
        'description': {
          'en': 'May indicate mineral content, bacteria, or chlorine residues.',
          'es': 'Puede indicar contenido mineral, bacterias o residuos de cloro.',
        },
        'image': 'https://images.unsplash.com/photo-1564419320461-6870880221ad?w=600',
      },
    ],
    'pozo_2_tanques': [
      {
        'id': 1,
        'title': {
          'en': 'Tank Leaks',
          'es': 'Fugas en los Tanques',
        },
        'description': {
          'en': 'Inspect tanks for cracks, rust, or loose fittings.',
          'es': 'Inspeccione los tanques en busca de grietas, óxido o conexiones sueltas.',
        },
        'image': 'https://images.unsplash.com/photo-1585675315678-4a818c0e3c84?w=600',
      },
      {
        'id': 2,
        'title': {
          'en': 'Pressure Fluctuations',
          'es': 'Fluctuaciones de Presión',
        },
        'description': {
          'en': 'Check pressure switch and tank bladders for proper function.',
          'es': 'Verifique el interruptor de presión y las vejigas del tanque.',
        },
        'image': 'https://images.unsplash.com/photo-1559631658-39c4b43f5c8a?w=600',
      },
      {
        'id': 3,
        'title': {
          'en': 'Sediment Buildup',
          'es': 'Acumulación de Sedimentos',
        },
        'description': {
          'en': 'Regular tank flushing can prevent sediment-related issues.',
          'es': 'La limpieza regular de tanques puede prevenir problemas de sedimentos.',
        },
        'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600',
      },
    ],
    'pozo_osmosis': [
      {
        'id': 1,
        'title': {
          'en': 'Membrane Fouling',
          'es': 'Ensuciamiento de la Membrana',
        },
        'description': {
          'en': 'Regular filter changes extend membrane life and performance.',
          'es': 'Los cambios regulares de filtros prolongan la vida útil de la membrana.',
        },
        'image': 'https://images.unsplash.com/photo-1559631658-39c4b43f5c8a?w=600',
      },
      {
        'id': 2,
        'title': {
          'en': 'Low Rejection Rate',
          'es': 'Baja Tasa de Rechazo',
        },
        'description': {
          'en': 'May indicate membrane degradation or improper installation.',
          'es': 'Puede indicar degradación de la membrana o instalación incorrecta.',
        },
        'image': 'https://images.unsplash.com/photo-1564419320461-6870880221ad?w=600',
      },
      {
        'id': 3,
        'title': {
          'en': 'High Waste Water Ratio',
          'es': 'Alta Proporción de Agua de Desecho',
        },
        'description': {
          'en': 'Check for clogs and adjust flow restrictors if needed.',
          'es': 'Verifique obstrucciones y ajuste los restrictores de flujo si es necesario.',
        },
        'image': 'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=600',
      },
    ],
    'ciudad': [
      {
        'id': 1,
        'title': {
          'en': 'Chlorine Taste',
          'es': 'Sabor a Cloro',
        },
        'description': {
          'en': 'Carbon filters effectively remove chlorine taste and odor.',
          'es': 'Los filtros de carbón eliminan efectivamente el sabor y olor a cloro.',
        },
        'image': 'https://images.unsplash.com/photo-1565703127086-ce6e91f57c98?w=600',
      },
      {
        'id': 2,
        'title': {
          'en': 'Hard Water Spots',
          'es': 'Manchas de Agua Dura',
        },
        'description': {
          'en': 'Water softeners prevent scale buildup on fixtures and appliances.',
          'es': 'Los suavizadores de agua previenen la acumulación de sarro.',
        },
        'image': 'https://images.unsplash.com/photo-1585675315678-4a818c0e3c84?w=600',
      },
      {
        'id': 3,
        'title': {
          'en': 'Discolored Water',
          'es': 'Agua Descolorida',
        },
        'description': {
          'en': 'May indicate pipe corrosion or main break - contact your utility.',
          'es': 'Puede indicar corrosión de tuberías o ruptura en la red principal.',
        },
        'image': 'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=600',
      },
    ],
    'osmosis_cocina': [
      {
        'id': 1,
        'title': {
          'en': 'Slow Water Flow',
          'es': 'Flujo de Agua Lento',
        },
        'description': {
          'en': 'Replace prefilters and check membrane status regularly.',
          'es': 'Reemplace los prefiltros y verifique el estado de la membrana.',
        },
        'image': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=600',
      },
      {
        'id': 2,
        'title': {
          'en': 'Leaking Connections',
          'es': 'Conexiones con Fugas',
        },
        'description': {
          'en': 'Check and replace fitting O-rings and tighten connections.',
          'es': 'Verifique y reemplace las juntas tóricas y apriete las conexiones.',
        },
        'image': 'https://images.unsplash.com/photo-1559631658-39c4b43f5c8a?w=600',
      },
      {
        'id': 3,
        'title': {
          'en': 'Strange Noises',
          'es': 'Ruido Extraño',
        },
        'description': {
          'en': 'Humming or gurgling may indicate air in the system.',
          'es': 'Zumbidos o gorgoteos pueden indicar aire en el sistema.',
        },
        'image': 'https://images.unsplash.com/photo-1564419320461-6870880221ad?w=600',
      },
    ],
  };
}
