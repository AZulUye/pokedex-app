class PokemonListItem {
  final String name;
  final String url;
  late final int id;
  late final String imageUrl;

  PokemonListItem({required this.name, required this.url}) {
    // Extract ID from URL (e.g., "https://pokeapi.co/api/v2/pokemon/1/")
    final uri = Uri.parse(url);
    id = int.parse(uri.pathSegments[uri.pathSegments.length - 2]);
    // Construct image URL using the ID
    imageUrl = 
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png";
  }

  factory PokemonListItem.fromJson(Map<String, dynamic> json) {
    return PokemonListItem(
      name: json["name"],
      url: json["url"],
    );
  }
}

