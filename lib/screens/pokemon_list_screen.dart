import 'package:flutter/material.dart';
import '../services/pokeapi_service.dart';
import '../models/pokemon_list_item.dart';
import '../widgets/pokemon_grid_item.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({Key? key}) : super(key: key);

  @override
  _PokemonListScreenState createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  late Future<List<PokemonListItem>> _pokemonListFuture;
  final PokeApiService _apiService = PokeApiService();

  @override
  void initState() {
    super.initState();
    _pokemonListFuture = _apiService.fetchPokemonList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<List<PokemonListItem>>(
        future: _pokemonListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final pokemonList = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Adjust columns based on screen size if needed
                childAspectRatio: 1.0, // Adjust aspect ratio as needed
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: pokemonList.length,
              itemBuilder: (context, index) {
                return PokemonGridItem(pokemon: pokemonList[index]);
              },
            );
          } else {
            return const Center(child: Text('No Pokemon found.'));
          }
        },
      ),
    );
  }
}

