class AppStrings {
  AppStrings._();

  static const Map<String, Map<String, String>> appStrings = {
    'splash': {
      'en': 'Water Support',
      'es': 'Soporte de Agua',
    },
    'splash_tagline': {
      'en': 'Your trusted water solution',
      'es': 'Tu solución confiable de agua',
    },
    'main_page': {
      'en': 'Water Support',
      'es': 'Soporte de Agua',
    },
    'option_a': {
      'en': 'What kind of water system do you have?',
      'es': '¿Qué tipo de sistema de agua tiene?',
    },
    'option_b': {
      'en': 'Do you want to get a check on your water system?',
      'es': '¿Desea revisar su sistema de agua?',
    },
    'option_c': {
      'en': 'Do you wish to refer us to someone else?',
      'es': '¿Desea recomendarnos a alguien más?',
    },
    'water_systems': {
      'en': 'Water Systems',
      'es': 'Sistemas de Agua',
    },
    'pozo': {
      'en': 'Agua de Pozo',
      'es': 'Agua de Pozo',
    },
    'ciudad': {
      'en': 'Agua de la Ciudad',
      'es': 'Agua de la Ciudad',
    },
    'osmosis_cocina': {
      'en': 'Osmosis Inversa Cocina',
      'es': 'Osmosis Inversa Cocina',
    },
    'pozo_2_tanques': {
      'en': 'Agua de Pozo 2 Tanques',
      'es': 'Agua de Pozo 2 Tanques',
    },
    'pozo_osmosis': {
      'en': 'Agua de Pozo Osmosis Inversa (Toda la Casa)',
      'es': 'Agua de Pozo Osmosis Inversa (Toda la Casa)',
    },
    'problems': {
      'en': 'Common Problems',
      'es': 'Problemas Comunes',
    },
    'contact': {
      'en': 'Contact Us',
      'es': 'Contáctenos',
    },
    'name': {
      'en': 'Name',
      'es': 'Nombre',
    },
    'phone': {
      'en': 'Phone',
      'es': 'Teléfono',
    },
    'email': {
      'en': 'Email',
      'es': 'Correo Electrónico',
    },
    'message': {
      'en': 'Message',
      'es': 'Mensaje',
    },
    'send': {
      'en': 'Send',
      'es': 'Enviar',
    },
    'no_image': {
      'en': 'No image available',
      'es': 'No hay imagen disponible',
    },
    'error_loading': {
      'en': 'Error loading content',
      'es': 'Error al cargar contenido',
    },
    'try_again': {
      'en': 'Try Again',
      'es': 'Intentar de Nuevo',
    },
    'back': {
      'en': 'Back',
      'es': 'Atrás',
    },
    'loading': {
      'en': 'Loading...',
      'es': 'Cargando...',
    },
    'referral_title': {
      'en': 'Refer a Friend',
      'es': 'Recomienda a un Amigo',
    },
    'check_title': {
      'en': 'Schedule a Check',
      'es': 'Programar una Revisión',
    },
    'contact_success': {
      'en': 'Message sent successfully!',
      'es': '¡Mensaje enviado exitosamente!',
    },
    'contact_error': {
      'en': 'Error sending message',
      'es': 'Error al enviar mensaje',
    },
  };

  static String getString(String key, String lang) {
    return appStrings[key]?[lang] ?? appStrings[key]?['en'] ?? key;
  }
}
