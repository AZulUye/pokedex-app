import 'dart:convert';

class PokemonDetail {
  final int id;
  final String name;
  final int height; // in decimetres
  final int weight; // in hectograms
  final List<String> types;
  final List<String> abilities;
  final Map<String, int> stats;
  final String imageUrl;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.stats,
    required this.imageUrl,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    // Extract types
    final List<dynamic> typesList = json['types'];
    final List<String> types = typesList
        .map((typeInfo) => typeInfo['type']['name'] as String)
        .toList();

    // Extract abilities
    final List<dynamic> abilitiesList = json['abilities'];
    final List<String> abilities = abilitiesList
        .map((abilityInfo) => abilityInfo['ability']['name'] as String)
        .toList();

    // Extract stats
    final List<dynamic> statsList = json['stats'];
    final Map<String, int> stats = {};
    for (var statInfo in statsList) {
      stats[statInfo['stat']['name']] = statInfo['base_stat'] as int;
    }

    // Extract image URL (official artwork)
    String imageUrl = json['sprites']?['other']?['official-artwork']?['front_default'] ?? 
                      json['sprites']?['front_default'] ?? // Fallback to default sprite
                      ''; // Fallback if no image found

    return PokemonDetail(
      id: json['id'],
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      types: types,
      abilities: abilities,
      stats: stats,
      imageUrl: imageUrl,
    );
  }
}

