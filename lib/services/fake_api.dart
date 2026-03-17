import 'dart:async';

Map<int, Map<String, dynamic>> fakeDb = {
  1: {
    "id": 1,
    "text": {
      "en": "Does your water come from?",
      "es": "¿De dónde proviene el agua?"
    },
    "is_final": false,
    "options": [
      {
        "text": {"en": "Well 💧", "es": "Pozo 💧"},
        "next_id": 2
      },
      {
        "text": {"en": "City 🚰", "es": "Red pública 🚰"},
        "next_id": 3
      }
    ]
  },
  2: {
    "id": 2,
    "text": {
      "en": "Use a sediment filter",
      "es": "Utilice un filtro de sedimentos"
    },
    "is_final": true,
    "options": []
  },
  3: {
    "id": 3,
    "text": {
      "en": "Install a carbon filter",
      "es": "Instale un filtro de carbón"
    },
    "is_final": true,
    "options": []
  }
};

Future<Map<String, dynamic>> getNode(int id) async {
  await Future.delayed(const Duration(milliseconds: 300)); // simulate network
  return fakeDb[id]!;
}