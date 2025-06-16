import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_list_item.dart';
import '../models/pokemon_detail.dart';
import '../utils/constants.dart';

class PokeApiService {
  Future<List<PokemonListItem>> fetchPokemonList({int limit = 151, int offset = 0}) async {
    final response = await http.get(Uri.parse(
        '${AppConstants.pokeApiBaseUrl}/pokemon?limit=$limit&offset=$offset'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((e) => PokemonListItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load Pokemon list');
    }
  }

  Future<PokemonDetail> fetchPokemonDetails(int pokemonId) async {
    final response = await http.get(Uri.parse(
        '${AppConstants.pokeApiBaseUrl}/pokemon/$pokemonId/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PokemonDetail.fromJson(data);
    } else {
      throw Exception('Failed to load Pokemon details for ID: $pokemonId');
    }
  }
}

